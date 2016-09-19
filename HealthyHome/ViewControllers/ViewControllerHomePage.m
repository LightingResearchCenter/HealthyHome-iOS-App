//
//  ViewControllerHomePage.m
//  HealthyHome
//
//  Created by Rajeev Bhalla on 4/22/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerHomePage.h"
#import "PopMenu.h"
#import "ViewControllerGoals.h"
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralCell.h"
#include "GlobalConfig.h"
#import "ViewControllerSelectDaysimeter.h"
#import "UIViewGlow.h"
#import "ViewControllerGoals.h"
#import "DaysiUtilities.h"

#include "MBHUDView.h"
#include "JSCustomBadge.h"
#include "CustomCategories.h"
#include "ViewControllerConfirm.h"
#include "UserSettings.h"


#include "RscMgr.h"
#include "DaysiUtilities.h"

#include "AppDelegate.h"
#include "DaysiLight.h"
#include "CLACScalc.h"
#import "CoreDataManager.h"
#include "CircadianModelManager.h"
#include "AFNetworking.h"
#include "ProgressHUD.h"

#include "TestFairy.h"


@interface ViewControllerHomePage ()
@property (nonatomic, strong) PopMenu *popMenu;



-(void)SetGaugeToValueInAngles: (int)currentValue;
@end

@implementation ViewControllerHomePage

//View Controllers managed by ViewControllerMain
ViewControllerDevices *myViewControllerDevices;
ViewControllerProfile *myViewControllerProfile;
ViewControllerGoals *myViewControllerGoals;
ViewControllerInformation *myViewControllerInformation;
ViewControllerSettings *myViewControllerSettings;
ViewControllerDebug *myViewControllerDebug;
ViewControllerConfirm *myViewControllerConfirm;



// Timers
NSTimer *timerRefreshUI;
NSTimer *timerConnectionTimeout;                // Timer for establishing a connection with a selected peripheral
NSTimer *timerScanForPeripherals;               // Timer for scanning looking for peripherals
NSTimer *timerAuthenticateWithDevice;          // Timer to Authenticate the iPad with the Daysi Watch
NSTimer *timerAuthenticateWithGoggle;           // Timer to Authenticate the Daysi Goggles
NSTimer *timerCircadianModelCompute;            // Timer used to Compute the circadian Model
NSTimer *timerCircadianModelRecomputeHoldOff;   // Timer used to hold off the circadian model recompute
//Animations
CABasicAnimation *myPulseAnimation;       // Simple Animation to create a pulse effect


//GUID's
NSString * const pUUIDDaysiMotionAdverttiseServiceId =        @"1723";
NSString * const pUUIDDaysiMotionService =        @"00001723-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionDataChar =         @"00001724-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionCommandChar =      @"00001725-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionBatteryChar =      @"00001726-1212-efde-1523-785feabcd123";


NSString * const pUUIDDaysiLightAdverttiseServiceId =        @"1623";
NSString * const pUUIDDaysiLightService =       @"00001623-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightDataChar =       @"00001624-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightCommandChar =    @"00001625-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightBatteryChar =    @"00001626-1212-efde-1523-785feabcd123";

NSString const *pUUID_DAYSI_DEVICE_DIS =                @"180a";
NSString const *pUUID_DAYSI_DEVICE_BATTERY=             @"180f";

NSString const *pUUIDRaptorDIS_ModelNumber =                      @"2a24";
NSString const *pUUIDRaptorDIS_SerialNumber =                     @"2a25";
NSString const *pUUIDRaptorDIS_FirmwareRevision =                 @"2a26";
NSString const *pUUIDRaptorDIS_HardwareRevision =                 @"2a27";
NSString const *pUUIDRaptorDIS_ManufacturerName =                 @"2a29";

NSArray *myListOfServicesToScan;
// Names of different BLE periherals that we are interested in.  These match the strings that are
// advertised by the peripherals - Do not change unless you change the peripheral

NSString *const pDaysiMotionDeviceName = @"Daysi*Motion";
NSString *const pDaysiLightDeviceName = @"Daysi*Light";

//Business Objects
DaysiMotion *myDaysiMotionDevice;           //Member variable that stores the DaysiMotion data
DaysiLight *myDaysiLightDevice;             //Member variable that stores the DaysiLight data

//Animations
CABasicAnimation *myPulseAnimation;       // Simple Animation to create a pulse effect

//Switch Control for Goggles
DVSwitch *myDVSwitchGoggles;

#define PULSESCALE 1.1
#define PULSEDURATION 0.2


typedef enum AppState
{
    E_Disconnected,
    E_CannotConnect,
    E_ScanningForPeripherals,
    E_ReadyToConnect,
    E_AttemptingToConnect,
    E_StabalizingReading,
    E_Measuring,
    E_AppState_Count
} E_AppState_T;

E_AppState_T m_AppState;

CircadianModelManager  *myCircadianManager;

JSCustomBadge * myTreatmentCountBadge;
NSMutableArray *myLightArray;
NSMutableArray *myMotionArray;
UITapGestureRecognizer *tapGestureRecognizer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
         NSLog(@"Screen H/W\r\n %f %f", [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        if([UIScreen mainScreen].bounds.size.height >= 667.0)
        {
            //Use iPhone5 VC
            //self = [super initWithNibName:@"ViewControllerHomePageIphone6" bundle:nibBundleOrNil];
             self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        }
        else{
            //Use Default VC
            self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        }
    }
    return self;
   
}


- (void)viewDidAppear:(BOOL)animated {
    
    [self becomeFirstResponder];

}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    static bool state = 0;
    state ^=1;
    [self.UIButtonDebug setHidden:state];
    NSLog(@"Shaken");
    
}

-(void) StartRotateAnimation: (int)animationTimeSeconds
{
    [self.UIImageViewSync setHidden:false];
    [DaysiUtilities rotateAndFadeView:self.UIImageViewSync ForDurationInSecs:animationTimeSeconds];
    
}

-(void) RefreshUI :(E_AppState_T)newState
{
    
    NSTimeInterval timeIntervalDaysiLight = [[NSDate date] timeIntervalSinceDate:myDaysiLightDevice.lastSeen];
   
    NSTimeInterval timeIntervalDaysMotion = [[NSDate date] timeIntervalSinceDate:myDaysiMotionDevice.lastSeen];
    
    [DaysiUtilities SetLayerToGlow:self.UILabelActivityGraph.layer WithColor:
                                         myDaysiMotionDevice.isDevicePresent?
         [DaysiUtilities GetDeviceConnectedGlowColor]:
         [UIColor clearColor]] ;
        
    
    
    [DaysiUtilities SetLayerToGlow:self.UILabelLightGraph.layer WithColor:
     myDaysiLightDevice.isDevicePresent?
     [DaysiUtilities GetDeviceConnectedGlowColor]:
     [UIColor clearColor]] ;
    
    
    if (timeIntervalDaysiLight > kSYNC_WARN_INTERVAL_SECS)
    {
      self.UILabelInfo.text = @"DaysiLight Sync Required!";
    }
    
    else if (timeIntervalDaysMotion > kSYNC_WARN_INTERVAL_SECS)
    {
         self.UILabelInfo.text = @"DaysiMotion Sync Required!";
    }

    else
    {
         self.UILabelInfo.text = @"";
    }
    


    //Check if the devices are paired
    if ( [[UserSettings GetDaysiMotionId]  isEqual: @"0000"] || [[UserSettings GetDaysiLightId]  isEqual: @"0000"] )
    {
        self.UILabelOffsetValue.text = [NSString stringWithFormat:@"!"];
        self.UILabelGaugeUnits.text = @"Pairing Required";
    }
    else
    {
        
        long lightReadingCount  = [CoreDataManager GetLightReadingCount];
        long activityReadingCount = [CoreDataManager GetMotionReadingCount];
        bool dataAvailableToCompute =  lightReadingCount > 0 && activityReadingCount > 0;
        if (  dataAvailableToCompute == 0)
        {
            self.UILabelOffsetValue.text = [NSString stringWithFormat:@"!"];
            self.UILabelGaugeUnits.text = @"Need More Data";
            
        }
        
        
    }
    
    //Update the last Sync on the Home Page for DaysiMotion
    if (! [[UserSettings GetDaysiMotionId]  isEqual: @"0000"]  )
    {
        NSDate *lastSeenDaysiMotion =  myDaysiMotionDevice.lastSeen;
        
        if (lastSeenDaysiMotion != nil)
        {
            NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:lastSeenDaysiMotion NewDate:[NSDate date] ThresholdSeconds:60];
            self.UILabelDaysiWatchLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];
        }
        else
        {
            lastSeenDaysiMotion  = [CoreDataManager GetLatestSyncTimeForDaysiMotionId:0];
            if (lastSeenDaysiMotion != nil)
            {
                NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:lastSeenDaysiMotion NewDate:[NSDate date] ThresholdSeconds:60];
                self.UILabelDaysiWatchLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];
            }else
            {
                
                self.UILabelDaysiWatchLastSeen.text = @"";
            }
        }
        
    }
    else
    {
        self.UILabelDaysiWatchLastSeen.text = @"Pair DaysiMotion Device!";
    }

    
    //Update the last Sync on the Home Page for DaysiMotion
    if (! [[UserSettings GetDaysiLightId]  isEqual: @"0000"]  )
    {
        NSDate *lastSeenDaysiLight = myDaysiLightDevice.lastSeen;
    
        if (lastSeenDaysiLight != nil)
        {
            NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:lastSeenDaysiLight NewDate:[NSDate date] ThresholdSeconds:60];
            self.UILabelDaysiLightLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];
        }
        else
        {
            lastSeenDaysiLight = [CoreDataManager GetLatestSyncTimeForDaysiLightId:0];
            if (lastSeenDaysiLight != nil)
            {
                NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:lastSeenDaysiLight NewDate:[NSDate date] ThresholdSeconds:60];
                self.UILabelDaysiLightLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];

            }
            else
            {
                self.UILabelDaysiLightLastSeen.text = @"";
            }
            
        }
        
    }
    else
    {
         self.UILabelDaysiLightLastSeen.text = @"Pair DaysiLight Device!";
    }

    

   
    
}

-(void) SetAppState:(E_AppState_T)state
{

}

- (void)viewDidLoad { 
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.

    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%f",timeInMiliseconds);
    
    NSLog(@"%@", [DaysiUtilities deviceUUID]);
    
    // Configure the temperature plot strip (sparkline)
    //Todo - Load the PlotStrips from DataManager
    myLightArray  = [NSMutableArray arrayWithCapacity:kLIGHT_TRENDLINE_ARRAY_MAX];
    myMotionArray  = [NSMutableArray arrayWithCapacity:kMOTION_TRENDLINE_ARRAY_MAX];

    [CoreDataManager GetLightReadingCSArray:myLightArray Count:kLIGHT_TRENDLINE_ARRAY_MAX];
    [CoreDataManager GetMotionReadingCSArray:myMotionArray Count:kMOTION_TRENDLINE_ARRAY_MAX];
    self.UILabelPlotStripHeadline.text = [NSString stringWithFormat:@"Activity & Light Trendline - %d Hrs", (int)k_TRENDLINE_ARRAY_MAX_HRS];
    
    //Setup the Plot Tickers
    
    _F3PlotStripLight.showDot = YES;
    _F3PlotStripLight.capacity = kLIGHT_TRENDLINE_ARRAY_MAX;
    _F3PlotStripLight.lineColor = [UIColor redColor];
    _F3PlotStripLight.labelFormat = @"%0.1f °F";    
    _F3PlotStripLight.upperLimit = kLIGHT_CS_MAX;
    _F3PlotStripLight.lowerLimit = kLIGHT_CS_MIN;
    _F3PlotStripLight.backgroundColor = [UIColor lightGrayColor];
    
    _F3PlotStripMotion.showDot = YES;
    _F3PlotStripMotion.capacity = kLIGHT_TRENDLINE_ARRAY_MAX;
    _F3PlotStripMotion.lineColor = [UIColor blueColor];
    _F3PlotStripMotion.labelFormat = @"%0.1f °F";
    _F3PlotStripMotion.upperLimit = kMOTION_AI_MAX;
    _F3PlotStripMotion.lowerLimit = kMOTION_AI_MIN;
    _F3PlotStripMotion.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [self SetGaugeToValue:0];
    //_F3PlotStripActivity.label = tempPlotLabel;
    
    //Instantiate the Central Manager Object.
    //The first argument represents the CBCentralManager delegate (in this case the view controller).
    //The second argument is instead the dispatch queue on which the events will be dispatched.
    //If you pass nil, you are telling the Central Manager that you want to use the main queue.
    myCBManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
    myConnectedPeripheral=nil;
    
    myListOfPeripherals = [NSMutableArray arrayWithCapacity:1];
    
    [self SetAppState:E_Disconnected];
    
    //   [self.UIViewGlow startGlowingWithColor:[UIColor redColor] intensity:1.0];
    
    
    // Create a Pulse animation to create a pulse effect.  This animation can then be added to any layer that we wish to "pulsate"
    myPulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    myPulseAnimation.toValue = [NSNumber numberWithFloat:k_PULSE_BUTTON_ANIMATION_SCALE_MAX];
    myPulseAnimation.fromValue = [NSNumber numberWithFloat:k_PULSE_BUTTON_ANIMATION_SCALE_MIN];
    myPulseAnimation.duration = PULSEDURATION*4;
    myPulseAnimation.repeatCount = LONG_MAX;
    myPulseAnimation.autoreverses = YES;
    myPulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    

    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    
    
    
    // Instantiate the DaysiMotion object that manages all activity related logic
    myDaysiMotionDevice = [[DaysiMotion alloc]init];
    
    // Instantiate the DaysiLight object that manages all Light related logic
    myDaysiLightDevice = [[DaysiLight alloc]init];
    
    
    
    // Test to see if the iPad supports Proximity Detection
#ifdef USE_PROXIMITY
    UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = YES;
    if ([device isProximityMonitoringEnabled])
    {
        NSLog(@"Proximity Enabled");
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proximityChanged)
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    }
#endif
    
#ifdef USE_BARCODE
    // Set the delegate for the UIViewBarCode object to self
    self.UIViewBarCode.barCodeDelegate = self;
    
    if (k_FEATURE_USE_BARCODE_READER)
    {
        [self.UIViewBarCode setHidden:FALSE];
        CGRect newFrame = self.UIViewBarCode.frame;
        newFrame.size.width=200;
        newFrame.size.height=200;
        [self.UIViewBarCode setFrame:newFrame];
    }
    else
    {
        [self.UIViewBarCode setHidden:TRUE];
    }
#endif
    
#if USE_NOTIFICATIONS
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    device.batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryChanged:) name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:device];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationIsActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
#endif
    
    // Clear out the list of all peripherals - we will start fresh
    [myListOfPeripherals removeAllObjects];
    
    

    // myMailComposer = [[MFMailComposeViewController alloc] init];
    
    
    [self SetToGlow:self.UIImageViewGoals WithColor:[UIColor orangeColor]];
    [self SetToGlow:self.UIImageViewProfile WithColor:[UIColor orangeColor]];
    [self SetToGlow:self.UIImageViewTreatments WithColor:[UIColor orangeColor]];
    [self SetButtonToGlow:self.UIButtonInfo WithColor:[UIColor orangeColor]];
    
  //  [DaysiUtilities SetLayerToGlow:self.UILabelDevices.layer WithColor:[UIColor orangeColor]];
  //  [DaysiUtilities SetLayerToGlow:self.UILabelGoals.layer WithColor:[UIColor orangeColor]];
  //  [DaysiUtilities SetLayerToGlow:self.UIButtonSettings.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiLight.layer WithColor:[UIColor orangeColor]];

    [DaysiUtilities SetLayerToGlow:self.UIButtonDebug.layer WithColor:[UIColor orangeColor]];
    
    
    // Create a Pulse animation to create a pulse effect.  This animation can then be added to any layer that we wish to "pulsate"
    myPulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    myPulseAnimation.toValue = [NSNumber numberWithFloat:k_PULSE_BUTTON_ANIMATION_SCALE_MAX];
    myPulseAnimation.fromValue = [NSNumber numberWithFloat:k_PULSE_BUTTON_ANIMATION_SCALE_MIN];
    myPulseAnimation.duration = PULSEDURATION*4;
    myPulseAnimation.repeatCount = LONG_MAX;
    myPulseAnimation.autoreverses = YES;
    myPulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.UIButtonDebug setHidden:false];
    


    //Set up the Circadian Model Timer.  This timer computes the Circadian Algorithm
    timerCircadianModelCompute =  [NSTimer scheduledTimerWithTimeInterval:(k_TIMER_CIRCADIAN_MODEL_COMPUTE_SECS)
                                                                  target:self
                                                            selector:@selector(timerCircadianModelCompute)
                                                            userInfo:nil
                                                             repeats:YES];
    
    //Set up the Circadian Model Hold Off Timer.  This timer computes the Circadian Algorithm
    timerCircadianModelRecomputeHoldOff =  [NSTimer scheduledTimerWithTimeInterval:(k_TIMER_CIRCADIAN_MODEL_RECOMPUTE_HOLDOFF_SECS)
                                                                   target:self
                                                                 selector:@selector(ReComputeHoldOffComplete)
                                                                 userInfo:nil
                                                                  repeats:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // Create a timer - when this timer times out we are done scanning for peripherals
    timerScanForPeripherals  = [NSTimer scheduledTimerWithTimeInterval:(k_SCAN_ATTEMPT_DELAY_INTERVAL_SECONDS)
                                                                    target:self
                                                                  selector:@selector(timerScanForPeripheralsTimeoutCallback)
                                                                  userInfo:nil
                                                                   repeats:NO];

    // Create a timer for refreshing the UI
    timerRefreshUI  = [NSTimer scheduledTimerWithTimeInterval:(k_REFRESH_UI_INTERVAL_SECONDS)
                                                                target:self
                                                              selector:@selector(timerRefreshUICallback)
                                                              userInfo:nil
                                                               repeats:YES];
    //Allocate a view Controller for Devices
    myViewControllerDevices = [[ViewControllerDevices alloc] init];
    

    myTreatmentCountBadge = [JSCustomBadge customBadgeWithString:@"Retina Ready!"
                                                 withStringColor:[UIColor whiteColor]
                                                  withInsetColor:[UIColor redColor]
                                                  withBadgeFrame:YES
                                             withBadgeFrameColor:[UIColor whiteColor]
                                                       withScale:1.0
                                                     withShining:NO
                                                      withShadow:YES];
    [self.UIViewBadge addSubview:myTreatmentCountBadge];
    self.UIViewBadge.backgroundColor = [UIColor clearColor];
    
    [self.UILabelLightGraph setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [self.UILabelActivityGraph setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
    [self.UILabelLightLastSeen setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [self.UILabelActivityLastSeen setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];

    
    self.UILabelInfo.text = @"";
    
    //Instantiate the Circadian Manager that manages the Circadian Treatments
    myCircadianManager = [[CircadianModelManager alloc]init];
    
    
    //Run the Circadian Model and Refresh Tickers on a background thread
    if (k_FEATURE_RUN_CIRCADIAN_AT_STARTUP == 1)
    {
        [self ReCompute];  // Run the ReCompute when App is launched
    }
    
    [self RefreshLightAndActivityTicker:1];
    tapGestureRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPresed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.UILabelMenu addGestureRecognizer:tapGestureRecognizer];
    self.UILabelMenu.userInteractionEnabled = YES;
    [self.UIViewMenu addGestureRecognizer:tapGestureRecognizer];
    self.UIViewMenu.userInteractionEnabled = YES;
    
    
    myListOfServicesToScan = [NSArray arrayWithObjects:
                        [CBUUID UUIDWithString:pUUIDDaysiLightAdverttiseServiceId],
                        [CBUUID UUIDWithString:pUUIDDaysiMotionAdverttiseServiceId],
                        nil];
    
    UIFont *myFont = [UIFont systemFontOfSize:80 weight:UIFontWeightUltraLight];
    [self.UILabelOffsetValue setFont:myFont];

    //Set up the Switch Control for Goggles
    [self.UIImageViewGoggle setHidden:!k_FEATURE_SHOW_GOGGLE_CONTROL];
    if (k_FEATURE_SHOW_GOGGLE_CONTROL)
    {

        myDVSwitchGoggles = [DVSwitch switchWithStringsArray:@[@"Blue", @"Clear", @"Orange"]];
        myDVSwitchGoggles.frame =  self.DVSwitchGoggles.frame;
        myDVSwitchGoggles.font = [UIFont fontWithName:@"Helvetica" size:26];
        myDVSwitchGoggles.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        myDVSwitchGoggles.sliderColor = [UIColor colorWithRed:99/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
        [self.view addSubview:myDVSwitchGoggles];
        [myDVSwitchGoggles setPressedHandler:^(NSUInteger index) {
            
            NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
            switch (index)
            {
                case 0:
                    myDVSwitchGoggles.sliderColor = [UIColor colorWithRed:51/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
                    
                    break;
                    
                case 1:
                    myDVSwitchGoggles.sliderColor = [UIColor clearColor];
                    break;
                    
                case 2:
                    myDVSwitchGoggles.sliderColor = [UIColor orangeColor];
                    break;
                    
                    
            }
            [myDVSwitchGoggles layoutSubviews];
        }];
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) SetToGlow: (UIImageView *) pImage WithColor:(UIColor *)glowColor
{
    
    pImage.layer.shadowColor = [glowColor CGColor];
    pImage.layer.shadowRadius = 4.0f;
    pImage.layer.shadowOpacity = .9;
    pImage.layer.shadowOffset = CGSizeZero;
    pImage.layer.masksToBounds = NO;
}

-(void) SetButtonToGlow: (UIButton *) pImage WithColor:(UIColor *)glowColor
{
    
    pImage.layer.shadowColor = [glowColor CGColor];
    pImage.layer.shadowRadius = 4.0f;
    pImage.layer.shadowOpacity = .9;
    pImage.layer.shadowOffset = CGSizeZero;
    pImage.layer.masksToBounds = NO;
}

- (void)showMenu {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:@"Profile" iconName:@"user-setting-2.png" glowColor:[UIColor grayColor] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"Devices" iconName:@"watch-1 2.png" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"Goals" iconName:@"crosshair-1.png" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"Utilities" iconName:@"setting-wrenches-60" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    
    menuItem = [[MenuItem alloc] initWithTitle:@"Info" titleColor:[UIColor redColor] iconName:@"information-60.png" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    if (!_popMenu) {
        
        _popMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
        _popMenu.menuAnimationType =     kPopMenuAnimationTypeNetEase;//kPopMenuAnimationTypeSina;
        
        
    }
    if (_popMenu.isShowed) {
        return;
    }
    
    _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        
        if ([selectedItem.title  isEqual: @"Goals"])
        {
            myViewControllerGoals = [[ViewControllerGoals alloc] init];
            myViewControllerGoals.delegate = self;
            //self.view.backgroundColor = [UIColor clearColor];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //myViewControllerDevices.delegate = self;
            [self presentViewController:myViewControllerGoals animated:YES completion: ^{[self ConfirmActionCompleted];}];
        }
        if ([selectedItem.title  isEqual: @"Profile"])
        {
            myViewControllerProfile = [[ViewControllerProfile alloc] init];
            //self.view.backgroundColor = [UIColor clearColor];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //myViewControllerDevices.delegate = self;
            [self presentViewController:myViewControllerProfile animated:NO completion: ^{[self ConfirmActionCompleted];}];
        }
        if ([selectedItem.title  isEqual: @"Info"])
        {
            myViewControllerInformation = [[ViewControllerInformation alloc] init];
            myViewControllerInformation.myDaysiLight = myDaysiLightDevice;
            myViewControllerInformation.myDaysiMotion = myDaysiMotionDevice;
            
            //self.view.backgroundColor = [UIColor clearColor];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //myViewControllerDevices.delegate = self;
            [self presentViewController:myViewControllerInformation animated:NO completion: ^{[self ConfirmActionCompleted];}];
        }
        if ([selectedItem.title  isEqual: @"Devices"])
        {
            myViewControllerDevices = [[ViewControllerDevices alloc] init];
            myViewControllerDevices.myDaysiLightData = myDaysiLightDevice;
            myViewControllerDevices.myDaysiMotionData = myDaysiMotionDevice;
            myViewControllerDevices.delegate = self;
            //self.view.backgroundColor = [UIColor clearColor];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            //myViewControllerDevices.delegate = self;
            [self presentViewController:myViewControllerDevices animated:YES completion: ^{[self ConfirmActionCompleted];}];
        }
        if ([selectedItem.title  isEqual: @"Utilities"])
        {
            myViewControllerDebug = [[ViewControllerDebug alloc] init];
            myViewControllerDebug.pDaysiMotionDevice   = myDaysiMotionDevice;
            myViewControllerDebug.pDaysiLightDevice   = myDaysiLightDevice;
            myViewControllerDebug.delegate = self;
            
            self.modalPresentationStyle = UIModalPresentationCurrentContext;

            [self presentViewController:myViewControllerDebug animated:YES completion: ^{[self ConfirmActionCompleted];}];
        }
        
        NSLog(@"%@",selectedItem.title);
    };
    
    [_popMenu showMenuAtView:self.view];
    
    [_popMenu showMenuAtView:self.view startPoint:CGPointMake(CGRectGetWidth(self.view.bounds) - 60, CGRectGetHeight(self.view.bounds)) endPoint:CGPointMake(60, CGRectGetHeight(self.view.bounds))];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CB Manager Services
-(void) CBManager_StartScanningForPeripherals
{
        NSLog(@"Start Scanning for peripherals with %lu services", (unsigned long)myListOfServicesToScan.count);

        // Start a scan - we will stop scanning when a timer expires
        [myCBManager scanForPeripheralsWithServices:myListOfServicesToScan
                                            options: nil];



    // Start a scan - we will stop scanning when a timer expires
    //[myCBManager scanForPeripheralsWithServices:nil
    //                                    options: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
    //                                                                         forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];

    
}

-(void) CBManager_StopScanningForPeripherals
{
    NSLog(@"Stop Scanning for peripherals");
    [myCBManager stopScan];
    [timerScanForPeripherals invalidate];
}


//--------------------------------------------------------------------------------
#pragma mark - Core Bluetooth Callbacks

- (void)StartDiscoveringServices:(CBPeripheral *)per
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    myConnectedPeripheral = per;

    [myConnectedPeripheral setDelegate:self];
    
    [myConnectedPeripheral discoverServices:nil];
    
}

//Once the Central Manager is initialized, its state can be checked. This will allow to verify that the device
//your application is running on is Bluetooth LE compliant. You do this implementing the following delegate method
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *myString;
    bool faultState = false;
    static int startUpFlag = 0;
    
    char * managerStrings[]={
        "Unknown",
        "Resetting",
        "Unsupported",
        "Unauthorized",
        "PoweredOff",
        "PoweredOn"
    };
    
 
    
    NSString * newstring=[NSString stringWithFormat:@"Manager State: %s",managerStrings[central.state]];
    self.UILabelManagerState.text=newstring;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            myString = @"This device does not support Bluetooth Low Energy.";
            faultState = true;
            break;
        case CBCentralManagerStateUnauthorized:
            myString = @"This app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            myString = @"Bluetooth Powered Off";
            //Todo call the disconnect logic here
            [self DisconnectLogic];
            faultState = true;
            break;
        case CBCentralManagerStateResetting:
            myString = @"The BLE Manager is resetting; a state update is pending.";
            break;
            
        case CBCentralManagerStatePoweredOn:
            myString = [NSString stringWithFormat:NSLocalizedString(@"Bluetooth Powered ON", nil)];
            faultState = true;
            //Todo - Start scanning if we were previously not scanning
            if ([myCBManager isScanning] == false )
            {
                //Start Scanning again since we got turned on
                [self CBManager_StartScanningForPeripherals];
                [self SetAppState:E_ScanningForPeripherals];

            }
            break;
        case CBCentralManagerStateUnknown:
            myString = @"The state of the BLE Manager is unknown.";
            break;
        default:
            myString = @"The state of the BLE Manager is unknown.";
            
    }
    
    if (faultState && startUpFlag++ != 0)
    {
        [ProgressHUD showError:myString];
    }
    
    self.UILabelManagerState.text=myString;
    
}




/*
 connected to peripheral
 Show service search view
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);

    
    //  ServiceViewController * hr= [self.storyboard instantiateViewControllerWithIdentifier:@"services"];
    if (timerConnectionTimeout != nil)
    {
        [timerConnectionTimeout invalidate];
    }
    
    myConnectedPeripheral = peripheral;
    NSLog(@"Connected to peripheral ");
    
    
    // Start discovering Services
    [self StartDiscoveringServices:peripheral];
    
    self.UILabelSerialNUmber.text = [[myConnectedPeripheralCell.peripheralMacId hexadecimalString] uppercaseString];
    
}

/*
 connected to peripheral
 Show service search view
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
    NSLog(@"%@", errorString);
 
    //Figure out who disconnected
    
    if (peripheral == myDaysiMotionDevice.blePeripheral)
    {
        myDaysiMotionDevice.isDevicePresent = false;
    }
    
    if (peripheral == myDaysiLightDevice.blePeripheral)
    {
        myDaysiLightDevice.isDevicePresent = false;
    }
    
    [myViewControllerDevices RefreshUIViewControllerDevices];
    
    NSString *myFormattedString = [NSString stringWithFormat:@"Disconnected"];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, myFormattedString);
    
    //Start Scanning again since we got disconnected
    [self CBManager_StartScanningForPeripherals];
    [self SetAppState:E_ScanningForPeripherals];
    
    // Close if we were on the Confirm to Exit Screen
    if (myViewControllerConfirm.isViewLoaded && myViewControllerConfirm.view.window)
    {
        [myViewControllerConfirm dismissViewControllerAnimated:YES completion:nil];
        //Restore the background Color since the ViewControllerConfirm had changed it
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey_light.png"]];
    }
    

    
    //Manage the local objects that kept track of BLE Peripherals
    [myListOfPeripherals removeAllObjects];
    myConnectedPeripheral = nil;
    myConnectedPeripheralCell = nil;
    
}


-(void) DisconnectLogic
{
    

    myDaysiMotionDevice.isDevicePresent = false;
    myDaysiLightDevice.isDevicePresent = false;
    
    NSString *myFormattedString = [NSString stringWithFormat:@"Disconnected"];
    NSLog(@"%s %@", __PRETTY_FUNCTION__, myFormattedString);
    
    
    // Close if we were on the Confirm to Exit Screen
    if (myViewControllerConfirm.isViewLoaded && myViewControllerConfirm.view.window)
    {
        [myViewControllerConfirm dismissViewControllerAnimated:YES completion:nil];
        //Restore the background Color since the ViewControllerConfirm had changed it
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey_light.png"]];
    }
    
    
    
    //Manage the local objects that kept track of BLE Peripherals
    [myListOfPeripherals removeAllObjects];
    myConnectedPeripheral = nil;
    myConnectedPeripheralCell = nil;
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error

{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [error debugDescription]);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"%s %lu Services Found", __PRETTY_FUNCTION__, (unsigned long)peripheral.services.count);
    
    
    bool foundDaysiDevice = false;
    CBService* ser;
    for (int i=0; i< peripheral.services.count; i++)
    {
        ser =[peripheral.services objectAtIndex:i];
        NSLog(@"Service %d: %@", i, [ser.UUID representativeString]);
        
        if([[ser.UUID representativeString]  isEqual:pUUID_DAYSI_DEVICE_DIS])
        {
            NSLog(@"Found the Daysi DIS Service");
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUID_DAYSI_DEVICE_BATTERY])
        {
             NSLog(@"Found the Daysi BATTERY Service");
            foundDaysiDevice = true;
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUIDDaysiMotionService])
        {
            foundDaysiDevice = true;
            NSLog(@"Found the DaysiMotion Service");
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUIDDaysiLightService])
        {
            foundDaysiDevice = true;
            NSLog(@"Found the DaysiLight Service");
            [self connectService:ser];
        }

        
        
    }
    
    
    
}


-(BOOL) peripheralExistsWithMacId:(NSData *)MACId
{
    BOOL doesExist = false;
    for (int i=0; i<myListOfPeripherals.count; i++)
    {
        PeripheralCell *objPeripheralCell = myListOfPeripherals[i];
        NSData *myManufacturerData = objPeripheralCell.peripheralMacId;
        NSLog(@"Comparing %@ with %@", myManufacturerData, MACId);
        doesExist = [myManufacturerData isEqualToData:MACId];
        if (doesExist)
        {
            break;
        }
    }
    return doesExist;
    
}

/**
 
 This call notifies the Central Manager delegate (the view controller) that a peripheral with advertisement data and RSSI was discovered. RSSI stands for Received Signal Strength Indicator. This is a cool parameter, because knowing the strength of the transmitting signal and the RSSI, you can estimate the current distance between the Central and the Peripheral. So, you can use the distance as a filter for a given service: only if the Central is close enough to the Peripheral, then your app does something.
 Called when Central Manager finds peripheral
 First checks if it exists, if not then insert new device
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Discovered %lu peripheral as a result of scanning", (unsigned long)myListOfPeripherals.count);
    
    
    // Get the manufacturer data from the advertisement packet. The manufacturer data contains the MACId of the peripheral
    NSData *pManufacturerData = [advertisementData valueForKey:@"kCBAdvDataManufacturerData"];
    NSLog (@"Manufacturer Data %@", [pManufacturerData hexadecimalString] );
    NSData *pMACIdData = [pManufacturerData subdataWithRange:NSMakeRange(2, [pManufacturerData length]-2) ];
    NSLog (@"MacId Data %@", [pMACIdData hexadecimalString] );
    NSLog(@"MAC Id Data Is %@", pMACIdData);
    //NSLog (@"UUID is  %@", peripheral.UUID);
    NSLog (@"UUID is  %@", peripheral.identifier);
    
    
   NSLog(@"Found Peripheral with Name: %@ RSSI data:%@ AdvData: %@", peripheral.name, peripheral.RSSI, advertisementData);
    
    NSString *localName;
   NSString *strHexId = [pMACIdData hexadecimalString];
    
    //Check if the DaysiMotion Device Exists -
    localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (myDaysiMotionDevice.isDevicePresent == false)
    {
        if ([localName isEqualToString:pDaysiMotionDeviceName])
        {
            if ([strHexId caseInsensitiveCompare:[UserSettings GetDaysiMotionId]] == NSOrderedSame)
            {
                NSLog (@"Found DaysiMotion with Id %@", strHexId);
                myDaysiMotionDevice.isDevicePresent = true;
                myDaysiMotionDevice.blePeripheral = peripheral;
                myDaysiMotionDevice.deviceId = [pMACIdData hexadecimalString];
                [myCBManager connectPeripheral:peripheral options:nil];
            }
            }
        }
    
    //Check if the DaysiLight Device Exists -
    localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (myDaysiLightDevice.isDevicePresent == false)
    {
        if ([localName isEqualToString:pDaysiLightDeviceName])
        {
            if ([strHexId caseInsensitiveCompare:[UserSettings GetDaysiLightId]] == NSOrderedSame)
            {
                NSLog (@"Found DaysiLight with Id %@", strHexId);
                myDaysiLightDevice.isDevicePresent = true;
                myDaysiLightDevice.blePeripheral = peripheral;
                myDaysiLightDevice.deviceId = [pMACIdData hexadecimalString];
                [myCBManager connectPeripheral:peripheral options:nil];
            }
            
        }
    }
    
    //If both devices have been found - stop scanning
    if (myDaysiLightDevice.isDevicePresent && myDaysiMotionDevice.isDevicePresent)
    {
        [myCBManager stopScan];
    }
    
    
}


- (void)connectService:(CBService *)service
{
    NSLog(@"%s for Service %@", __PRETTY_FUNCTION__, [service.UUID representativeString]);
    
    
    [myDaysiMotionDevice Reset];
    [myDaysiLightDevice Reset];
    
    myConnectedPeripheral=service.peripheral;
    [myConnectedPeripheral setDelegate:self];
    [myConnectedPeripheral discoverCharacteristics:nil forService:service];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if(error)
    {
        //handle error
        //myCBCharacteristic_DaysiMotionData=nil;
        //myCBCharacteristic_DaysiMotionBattery=nil;
        
        NSLog(@"%@ %@", [characteristic.UUID representativeString], error.debugDescription);
    }
    
    else
    {
        
    }
}


//Server has updated the value for a characteristic
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    

    
    if(error != nil )
    {
        NSLog(@"Error in %s",  __PRETTY_FUNCTION__);
        return;
    }
    


    
    
    // Characteristic data array is the raw bucket of bytes received from the peripheral
    const uint8_t *characteristicDataArray = [characteristic.value bytes];
    
    CBUUID *pUUID = characteristic.UUID;
    static int motionPlotCount = 0;
    

    // Used for dumping the data to a NSLog as a Hex String
    // #ifdef for Release
    long dataLength = [characteristic.value length];
    NSUInteger capacity =  dataLength* 4;
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
    char *dataBuffer = (char *)[characteristic.value bytes];
    NSInteger i;
    for (i=0; i<[characteristic.value length]; ++i) {
        [stringBuffer appendFormat:@"(%ld)%02x: ", (long)i, (unsigned char)dataBuffer[i]];
    }
    
    //NSLog(@"\r\n\r\nBytes Received %ld Data Received for UDID %@ is %@",dataLength, [pUUID representativeString], stringBuffer);

    NSString *myStr = [NSString stringWithCString:dataBuffer encoding:NSASCIIStringEncoding];

    if ([[pUUID representativeString] isEqual:pUUIDRaptorDIS_FirmwareRevision])
    {
        if (peripheral == myDaysiLightDevice.blePeripheral)
        {
            
            myDaysiLightDevice.strFWVersion = myStr;
            NSLog(@"DIS Data Received for Dayslight %@", myDaysiLightDevice.strFWVersion );
        }

        else if (peripheral == myDaysiMotionDevice.blePeripheral)
        {

            myDaysiMotionDevice.strFWVersion = myStr;
            NSLog(@"DIS Data Received for DaysiMotion %@", myDaysiMotionDevice.strFWVersion );
        }
    
    }
    
    // DaysiMotion data  Received
    // -------------------------
    if ([[pUUID representativeString] isEqual:pUUIDDaysiMotionDataChar])
    {
        bool skipLogging = false;
#ifdef  DEBUG_VERBOSE
        NSLog(@"DaysiMotion Data Received");
#endif
        [self SetAppState:E_Measuring];
        
        m_guard = 1;
        
        // Parse the data recieved from the DaysiMotion ....
        [myDaysiMotionDevice ParseFromByteArray:characteristicDataArray];
        
        
        NSDate *logTimeMotion;
        if ([CoreDataManager GetMotionReadingCount] == 0)
        {
            // If this is the first record - Use the current time
            logTimeMotion = [NSDate date];
            
        }
        else if (myDaysiMotionDevice.forceTimeSync == 1)
        {
            
            //If the user has forced a time sync (via the Debug/Utilities screen - Use the Current time)
            myDaysiMotionDevice.forceTimeSync = 0;
            logTimeMotion = [NSDate date];
            
        }
        else if(   [myDaysiMotionDevice GetDaysiData]->activityIndex == 0xdead &&
                   [myDaysiMotionDevice GetDaysiData]->activityCount == 0xbabe
                )
        {
            
            //If a sync time delimeter is found - Sync the time to current
            myDaysiMotionDevice.forceTimeSync = 1;
            NSLog(@"Detected Power up Sync Delimeter[DaysiMotion]...........");
            return;

        }
        
        else
        {
            logTimeMotion = [CoreDataManager GetLatestSyncTimeForDaysiMotionId:0];
            logTimeMotion = [logTimeMotion dateByAddingTimeInterval:k_DAYSI_MOTION_SYNC_INTERVAL];
        }
        
        
        if (!skipLogging)
        {
            
            // Finally Log the Data
            [CoreDataManager LogDaysiMotionRecord:myDaysiMotionDevice.deviceId
                                         DateTime:logTimeMotion
                                    ActivityCount:[myDaysiMotionDevice GetActivityCount ]
                                    ActivityIndex:[myDaysiMotionDevice GetActivityIndex]
                                   BatteryVoltage:[myDaysiMotionDevice GetBatteryVoltageInMilliVolts]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                motionPlotCount ++;
                
                if (motionPlotCount > 1)
                {
                    motionPlotCount = 0;
                    _F3PlotStripMotion.value = [myDaysiMotionDevice GetActivityIndex];
                }
                
            });
            
            myDaysiMotionDevice.lastSeen = [NSDate date];
            [self StartRotateAnimation:1];
            
            
            //If the debug ViewController is present - update it!
            if (myViewControllerDebug)
            {
                [myViewControllerDebug UpdateDaysiMotionData:myDaysiMotionDevice];
            }
            
            //If the devices ViewController is present - update it!
            if (myViewControllerDevices)
            {
                [myViewControllerDevices UpdateDaysiMotionData];
             }
            
            
#ifdef DEBUG
            // Log the Data to the Serial Port for Debug Purposes
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"HH:mm:ss:SSS"];
            NSDate *currentDate = [NSDate date];
            NSString *dateString = [dateFormater stringFromDate:currentDate];
            NSString *myStrSerialPort = [NSString stringWithFormat:@"%@  %@\r\n", dateString, myDaysiMotionDevice];
            NSLog(@"%@", myStrSerialPort);
            
#endif
            
            m_guard = 0;
        }
        
        NSLog(@"%@", [myDaysiMotionDevice GetDebugString]);
        
    }
    
    // DaysiLight Data Received from DaysLight Device
    // ----------------------------------------------
    if ([[pUUID representativeString] isEqual:pUUIDDaysiLightDataChar])
    {
        NSLog(@"Daysi Light Data Received");
        
        
        // Parse the data recieved from the DaysiLight ....
        uint8_t command = [myDaysiLightDevice ParseFromByteArray:characteristicDataArray];
        if (command == kDEVICE_TO_PHONE_LIGHT_DATA)
        {
            DAYSI_LIGHT_DATA_T *pDaysiLightData = [myDaysiLightDevice GetDaysiLightData];
            
            if( pDaysiLightData->redValue == 0xdead &&
                pDaysiLightData->greenValue == 0xbeef
               )
            {
                myDaysiLightDevice.forceTimeSync = 1;
                NSLog(@"Detected Power up Sync Delimeter[DaysiLight]...........");
                NSLog(@"Will force (Auto) Power Sync ...........");
                return;
            }

            
            
            float computedR,computedG,computedB,computedC,CLA,CS;
            
            
            CLACScalc_ComputeMetrics(pDaysiLightData->redValue,
                                     pDaysiLightData->greenValue,
                                     pDaysiLightData->blueValue,
                                     pDaysiLightData->clearValue,
                                     &computedR,
                                     &computedG,
                                     &computedB,
                                     &computedC,
                                     &CLA,
                                     &CS);
            
            //Update the ticker in a background thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _F3PlotStripLight.value = CS;
                
            });
          
            
            NSDate *logTime;
            if ([CoreDataManager GetLightReadingCount] == 0)
            {
                logTime = [NSDate date];
                
            }
            else if (myDaysiLightDevice.forceTimeSync == 1)
            {
                myDaysiLightDevice.forceTimeSync = 0;
                logTime = [NSDate date];

            }
            

            else
                
            {
                logTime = [CoreDataManager GetLatestSyncTimeForDaysiLightId:0];
                logTime = [logTime dateByAddingTimeInterval:k_DAYSI_LIGHT_SYNC_INTERVAL];
            }
            [CoreDataManager LogDaysiLightRecord:myDaysiLightDevice.deviceId
                                        DateTime:logTime
                                        RedValue:computedR
                                      GreenValue:computedG
                                       BlueValue:computedB
                                      ClearValue:computedC
                                        CLAValue:CLA
                                         CSValue:CS];
            
           // NSLog(@"CLA: %3.2f CS:%3.2f", CLA, CS);
            
            myDaysiLightDevice.lastSeen = [NSDate date];
            //[myDaysiLightDevice WriteInitializeCommand];
            
            //If the debug ViewController is present - update it!

            
            //If the Devices ViewController is present - update it!
            if (myViewControllerDevices)
            {
                [myViewControllerDevices UpdateDaysiLightData];
                
            }

            
            m_guard = 0;
            
            
            NSLog(@"%@", [myDaysiLightDevice GetDebugString]);
        }
        
        else if (command == kDEVICE_TO_PHONE_CALIBRATION_DATA)
        {
            [CoreDataManager LogCalibrationRecordRed:myDaysiLightDevice.calRed
                                               Green:myDaysiLightDevice.calGreen
                                                Blue:myDaysiLightDevice.calBlue
                                               Clear:myDaysiLightDevice.calClear];
            
            NSString *strCal = [NSString stringWithFormat:@"%3.3f::%3.3f::%3.3f::%3.3f",
                                myDaysiLightDevice.calRed,
                                myDaysiLightDevice.calGreen,
                                myDaysiLightDevice.calBlue,
                                myDaysiLightDevice.calClear];
          
            [UserSettings SetCalibrationStr:strCal];
            
            
            if (myViewControllerDebug)
            {
                [myViewControllerDebug  UpdateDaysiLightData:myDaysiLightDevice];

                
            }
        }
        
    }
    

    [timerCircadianModelRecomputeHoldOff invalidate];
    
     timerCircadianModelRecomputeHoldOff =  [NSTimer scheduledTimerWithTimeInterval:(k_TIMER_CIRCADIAN_MODEL_RECOMPUTE_HOLDOFF_SECS)
                                                                            target:self
                                                                          selector:@selector(ReComputeHoldOffComplete)
                                                                          userInfo:nil
                                                                           repeats:NO];
#ifdef DEBUG_VERBOSE
    NSLog(@"Reload Timer for Recompute HoldOff");
#endif
}



- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if(error != nil)
    {
        //TODO: handle error
        return;
    }
    
    NSLog(@"Found %lu Characteristics for service with UUID %@", (unsigned long)service.characteristics.count, [service.UUID representativeString]);
    
    
    for  (int i=0; i<service.characteristics.count; i++)
    {
        CBCharacteristic *myCharacteristic = service.characteristics[i];
        CBUUID *myId = myCharacteristic.UUID;
        NSString *myString =  [myId representativeString];
        NSLog(@"%@", myString);
        
#pragma mark SETUP DAYSIMOTION CHARACTERISTICS
        if ( [myString isEqual: pUUIDDaysiMotionDataChar])
        {
            myDaysiMotionDevice.myCBCharacteristic_DaysiMotionData = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myDaysiMotionDevice.myCBCharacteristic_DaysiMotionData];
        }
        
        if ( [myString isEqual: pUUIDDaysiMotionBatteryChar])
        {
            myDaysiMotionDevice.myCBCharacteristic_DaysiMotionBattery = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myDaysiMotionDevice.myCBCharacteristic_DaysiMotionBattery];
        }
        
        if ( [myString isEqual: pUUIDDaysiMotionCommandChar])
        {
            myDaysiMotionDevice.myCBCharacteristic_DaysiMotionCommand = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myDaysiMotionDevice.myCBCharacteristic_DaysiMotionCommand];
            
            // Authenticate yourself with the DaysiMotion by writing to the Characteristic shortly
            timerAuthenticateWithDevice =   [NSTimer scheduledTimerWithTimeInterval:(1)
                                                                              target:self
                                                                            selector:@selector(WriteInitializeCommandToDaysiMotion)
                                                                            userInfo:nil
                                                                             repeats:NO];
        }

#pragma mark SETUP DAYSILIGHT CHARACTERISTICS
 
        if ( [myString isEqual: pUUIDDaysiLightCommandChar])
        {
            myDaysiLightDevice.myCBCharacteristic_DaysiLightCommand = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myDaysiLightDevice.myCBCharacteristic_DaysiLightCommand];
            
            // Authenticate yourself with the DaysiMotion by writing to the Characteristic shortly
            timerAuthenticateWithGoggle =   [NSTimer scheduledTimerWithTimeInterval:(1)
                                                                              target:self
                                                                            selector:@selector(WriteInitializeCommandToDaysiLight)
                                                                            userInfo:nil
                                                                             repeats:NO];
        }
        
        if ( [myString isEqual: pUUIDDaysiLightDataChar])
        {
            myDaysiLightDevice.myCBCharacteristic_DaysiLightData = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myDaysiLightDevice.myCBCharacteristic_DaysiLightData];
        }
        
        if ( [myString isEqual: pUUIDRaptorDIS_SerialNumber])
        {
            myCBCharacteristic_DIS_SerialNumber = myCharacteristic;
            [myConnectedPeripheral readValueForCharacteristic:myCBCharacteristic_DIS_SerialNumber];
            [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
        }
        
        if ( [myString isEqual: pUUIDRaptorDIS_ManufacturerName])
        {
            myCBCharacteristic_DIS_ManufacturerName = myCharacteristic;
            [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_ManufacturerName];
            [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
        }
        
        if ( [myString isEqual: pUUIDRaptorDIS_FirmwareRevision])
        {
             if (peripheral == myDaysiLightDevice.blePeripheral)
             {
                 myCBCharacteristic_DIS_FirmwareVersion = myCharacteristic;
                 myDaysiLightDevice.myCBCharacteristic_DIS_FirmwareVersion = myCharacteristic;
                 [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_FirmwareVersion];
                 [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
             }
            
            
            if (peripheral == myDaysiMotionDevice.blePeripheral)
            {
                myCBCharacteristic_DIS_FirmwareVersion = myCharacteristic;
                myDaysiMotionDevice.myCBCharacteristic_DIS_FirmwareVersion = myCharacteristic;
                [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_FirmwareVersion];
                [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
            }



        }
        
        if ( [myString isEqual: pUUIDRaptorDIS_HardwareRevision])
        {
            myCBCharacteristic_DIS_HardwareVersion = myCharacteristic;
            [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_HardwareVersion];
            [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
        }
        
        if ( [myString isEqual: pUUIDRaptorDIS_ModelNumber])
        {
            myCBCharacteristic_DIS_ModelNumber = myCharacteristic;
            [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_ModelNumber];
            [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
        }
        

        
    }
    
}




- (NSString*) serviceToString: (CBUUID*) uuid
{
    NSString *rv=[myDictionaryOfServices objectForKey:uuid];
    
    //no text found, return hex string
    if (rv == nil)
        return [uuid.data description];
    
    return rv;
}


-(void)ReCompute
{

    if (k_FEATURE_USE_TEST_LOG_FILE == 0)
    {
        //See if there is any data to Recompute
        long lightReadingCount  = [CoreDataManager GetLightReadingCount];
        long activityReadingCount = [CoreDataManager GetMotionReadingCount];
        bool dataAvailableToCompute =  lightReadingCount > 0 && activityReadingCount > 0;
        if (  dataAvailableToCompute == 0)
        {
            self.UILabelOffsetValue.text = [NSString stringWithFormat:@"!"];
            self.UILabelGaugeUnits.text = @"Need More Data";
            return;
        }
    }
    
    self.UILabelGaugeUnits.text = @"Recomputing";
    [self.UIActivityIndicatorBusy setHidesWhenStopped:true];
    [self.UIActivityIndicatorBusy startAnimating];
    [self.UILabelOffsetValue setHidden:true];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        NSLog(@"Starting Recompute");
        

        int result = [myCircadianManager RecomputeAlgorithm];

        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                        
                           [self.UIActivityIndicatorBusy stopAnimating];
                            [self.UILabelOffsetValue setHidden:false];
                    
                           
                           //Todo Code cleanup required
                           if (result == 0)
                           {
                               if ([myCircadianManager GetLastStatus] == 0)
                               {
                                   double distanceToGoals = [myCircadianManager GetDistanceToGoalInHrs];
                                   self.UILabelOffsetValue.text = [NSString stringWithFormat:@"%3.1f",distanceToGoals ];
                                   [self SetGaugeToValue:distanceToGoals+12 ];
                                   self.UILabelGaugeUnits.text = @"Hrs.";
                               }
                               else
                               {
                                   self.UILabelOffsetValue.text = [NSString stringWithFormat:@"!"];
                                   [myTreatmentCountBadge  autoBadgeSizeWithString:@"!"];
                                   [self setApplicationBadgeNumber:0];
                                   self.UILabelGaugeUnits.text = @"Need More Data";
                                   
                                   NSLog(@"Error %x",[myCircadianManager GetLastStatus]);
                               }
                           }
                           
                           else if (result == 0x8006)
                           {
                               self.UILabelOffsetValue.text = [NSString stringWithFormat:@"!"];
                               [myTreatmentCountBadge  autoBadgeSizeWithString:@"!"];
                               [self setApplicationBadgeNumber:0];
                                NSLog(@"Error %x",[myCircadianManager GetLastStatus]);
                               self.UILabelGaugeUnits.text = @"Need More Data";
                           }
                           else if (result == 0x8803)
                           {
                                 NSLog(@"Error %x",[myCircadianManager GetLastStatus]);
                                 self.UILabelGaugeUnits.text = @"Need New Data";
                           }
                           else if (result == -1)
                           {
                               NSLog(@"Error %x",[myCircadianManager GetLastStatus]);
                               //self.UILabelGaugeUnits.text = @"Need New Data";
                           }

                           else
                           {
                             NSLog(@"Error %x",[myCircadianManager GetLastStatus]);
                             self.UILabelGaugeUnits.text = [NSString stringWithFormat: @"Error %0x", [myCircadianManager GetLastStatus]];
                               
                           }
                           
                       });
        NSLog(@"Ending Recompute");


        
        
    });
    
    
    
}
#pragma mark Badge Handling
- (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    return (currentSettings.types & type);
}

- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
#ifdef __IPHONE_8_0
    // compile with Xcode 6 or higher (iOS SDK >= 8.0)
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else
    {
        if ([self checkNotificationType:UIUserNotificationTypeBadge])
        {
            NSLog(@"badge number changed to %ld", (long)badgeNumber);
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else
            NSLog(@"access denied for UIUserNotificationTypeBadge");
    }
    
#else
    // compile with Xcode 5 (iOS SDK < 8.0)
    application.applicationIconBadgeNumber = badgeNumber;
    
#endif
}
-(void) ConfirmActionCompleted
{
    
    
}



#pragma mark - Call Backs from Other ViewControllers
-(void) OnDismissGoals:(ViewControllerGoals *)controller Confirm:(bool)confirm
{
    if ([timerCircadianModelRecomputeHoldOff isValid])
    {
        return;
        
    }
    
    if (confirm)
    {
        [self ReCompute];
    }
//    [TestFairy checkpoint:@"Goals Dismissed"];
    
}

-(void) OnDismissDevices:(ViewControllerDevices *)controller DisconnectMotion:(bool)disconnectMotion DisconnectLight:(bool)disconnectLight
{
    
    
    if (disconnectMotion)
    {
          if (myDaysiMotionDevice.isDevicePresent)
          {
               [myCBManager cancelPeripheralConnection:myDaysiMotionDevice.blePeripheral];
          }
    }
    
    if (disconnectLight)
    {
        if (myDaysiLightDevice.isDevicePresent)
        {
            [myCBManager cancelPeripheralConnection:myDaysiLightDevice.blePeripheral];
        }
    }
    
    if ([timerCircadianModelRecomputeHoldOff isValid] == false)
    {
      // [self ReCompute];
    }
    
    [self RefreshLightAndActivityTicker :1];
//    [TestFairy checkpoint:@"Devices Dismissed"];
    
}

-(void) RefreshLightAndActivityTicker:(float)scalingFactor
{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        NSLog(@"Starting Ticker Refresh");
        
        //Update Light & Motion Tickers
        [self.F3PlotStripLight clear];
        [myLightArray removeAllObjects];
        long count =     [CoreDataManager GetLightReadingCSArray:myLightArray Count:kLIGHT_TRENDLINE_ARRAY_MAX];
        for (int i=0; i<count; i++)
        {
            //NSLog(@"Plotting Light Ticker Value: %3.2f", [[myLightArray objectAtIndex:i] floatValue]);
            self.F3PlotStripLight.value = [[myLightArray objectAtIndex:i] floatValue];
        }
        
        [self.F3PlotStripMotion clear];
        [myMotionArray removeAllObjects];
        count =     [CoreDataManager GetMotionReadingCSArray:myMotionArray Count:kMOTION_TRENDLINE_ARRAY_MAX];
        for (int i=0; i<count; i++)
        {
            //NSLog(@"Motion Plot Value is %3.2f", [[myMotionArray objectAtIndex:i] floatValue]);
            self.F3PlotStripMotion.value = [[myMotionArray objectAtIndex:i] floatValue];
        }

        
        //Not sure why this neets to be done in the Main thread.
        // Takes up a lot of time. Do not know a workaround though
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.view setNeedsDisplay];
                           [self.F3PlotStripLight.viewForBaselineLayout  setNeedsDisplay];
                           [self.F3PlotStripMotion.viewForBaselineLayout  setNeedsDisplay];
                           
                       });
        NSLog(@"Ending Ticker Refresh");
    });
    
   
    
}

-(void) RefreshLightAndActivityTickerWithZoom:(float)zoomingFactor AndPan:(float)panningFactor
{
    static int busy = 0;
    if (busy == 1){
        NSLog(@" Ticker Busy");
        return;
    }
    
    
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
    NSLog(@"Starting Ticker Refresh With Zoom %3.2f And Offset %3.2f", zoomingFactor, panningFactor) ;
    busy = 1;
    //Update Light & Motion Tickers
    [self.F3PlotStripLight clear];
    [myLightArray removeAllObjects];
    
    int maxValue;
    maxValue = (int)((float)kLIGHT_TRENDLINE_ARRAY_MAX / (zoomingFactor) );
    
    if (maxValue > kLIGHT_TRENDLINE_ARRAY_MAX)
    {
        maxValue = kLIGHT_TRENDLINE_ARRAY_MAX;
        panningFactor = 0;
    }
    
    int startValue = 0;
   
    
    NSLog (@"Plotting Start %d and Max values",startValue, maxValue);
    self.F3PlotStripLight.capacity = maxValue;
    long count =     [CoreDataManager GetLightReadingCSArray:myLightArray Count:maxValue];
    for (int i=startValue; i<count; i++)
    {
        //NSLog(@"Plotting Light Ticker Value: %3.2f", [[myLightArray objectAtIndex:i] floatValue]);
        self.F3PlotStripLight.value = [[myLightArray objectAtIndex:i] floatValue];
    }
    
    [self.F3PlotStripMotion clear];
    [myMotionArray removeAllObjects];
    count =     [CoreDataManager GetMotionReadingCSArray:myMotionArray Count:kMOTION_TRENDLINE_ARRAY_MAX];
    for (int i=0; i<count; i++)
    {
        //NSLog(@"Motion Plot Value is %3.2f", [[myMotionArray objectAtIndex:i] floatValue]);
        self.F3PlotStripMotion.value = [[myMotionArray objectAtIndex:i] floatValue];
    }
    
    
    //Not sure why this neets to be done in the Main thread.
    // Takes up a lot of time. Do not know a workaround though
    //  dispatch_async(dispatch_get_main_queue(), ^
    //  {
    [self.view setNeedsDisplay];
    [self.F3PlotStripLight.viewForBaselineLayout  setNeedsDisplay];
    [self.F3PlotStripMotion.viewForBaselineLayout  setNeedsDisplay];
    busy = 0;
    
    //               });
    NSLog(@"Ending Ticker Refresh");
    //});
    
    
    
}

- (IBAction)UIButtonClearPaceMakerData:(id)sender {
    
}

-(void) OnDismissDebug:(ViewControllerDebug *)controller Confirm:(bool)confirm
{
   
   if (confirm)
   {
       
       [self RefreshLightAndActivityTicker:1];
       
   }

    
    
}




-(IBAction)buttonPresed:(id)sender
{
    [self showMenu];
    
}

#pragma mark -  Read/Write To DaysiMeter
- (IBAction)Read:(id)sender
{
}


-(void) WriteInitializeCommandToDaysiLight
{
    [myDaysiLightDevice WriteInitializeCommand];
}

-(void) WriteInitializeCommandToDaysiMotion
{
    [myDaysiMotionDevice WriteInitializeCommand];
}



#pragma mark - Gauge UserInterface




-(void)SetGaugeToValueInAngles: (int)currentValue
{
    
    static int oldCurrentValue = 0;

    
    
    CABasicAnimation *rotateCurrentPressureTick = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotateCurrentPressureTick setDelegate:self];
    rotateCurrentPressureTick.fromValue = [NSNumber numberWithFloat:oldCurrentValue/57.2958];
    rotateCurrentPressureTick.removedOnCompletion = NO;
    rotateCurrentPressureTick.fillMode = kCAFillModeForwards;
    rotateCurrentPressureTick.toValue = [NSNumber numberWithFloat:  currentValue/57.2958];
    rotateCurrentPressureTick.duration = 3.0; // seconds
    
    [self.ImageViewTick.layer addAnimation:rotateCurrentPressureTick forKey:@"rotateTick"]; // "key" is optional
    
    
    oldCurrentValue = currentValue;

    
}

-(void)SetGaugeToValue: (int)currentValue
{
    float scale = (k_ARC_ANGLE_MAX / k_PSI_MAX);
    [self SetGaugeToValueInAngles:scale*currentValue ];
    

//    self.UILabelPressureValue.text = [NSString stringWithFormat: @"%i", convertedValue];
 //   [self.UIButtonPressureUnit setTitle:UnitString forState:UIControlStateNormal];
//    self.blinkText = blinkState;
//    [self SetPressureTextColor:(blinkText? [UIColor redColor]: [UIColor whiteColor])];
}
#pragma mark - HTTP Post







#pragma mark - APP TIMEOUT HANDLERS
-(void) ReComputeHoldOffComplete
{
#ifdef DEBUG_VERBOSE
    NSLog (@"ReComputeHoldOffComplete");
#endif
    
    [timerCircadianModelRecomputeHoldOff invalidate];
}



- (void) timerCircadianModelCompute
{
    NSLog(@"Timer for Circadian Model Recompute Was Run");
    //Todo Call the Circadian Model Recompute here
    [self ReCompute];
    //[myCircadianManager RecomputeAlgorithm];
    

    //Prepare an archive to post to the back end server
    NSString * myArchiveFileNameWithFullPath;

    
    //Create the Archive File
    //Make sure that you can create an archive file
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    myArchiveFileNameWithFullPath = [NSString stringWithFormat:@"%@/archive.zip",
                                     documentsDirectory ];
    
    bool result =  [CoreDataManager CreateArchiveFile:myArchiveFileNameWithFullPath];
    if (result == 0 )
    {
        [ProgressHUD showError:@"Can't Create Archive"];
        return;
    }
    
    NSString *yalerAddress = [UserSettings GetControlHubId];
    NSString *urlString = [NSString stringWithFormat:@"http://lrc-%@.via.yaler.net/healthyhome/webresources/fileupload",yalerAddress ];
    
    // Todo - Post the results to a HTTP Server
    [myViewControllerDebug PostFileToServer:myArchiveFileNameWithFullPath :urlString];
}


- (void) timerRefreshUICallback
{
    [self RefreshUI:E_Measuring];

}



- (void) timerScanForPeripheralsTimeoutCallback
{
    [self CBManager_StartScanningForPeripherals];
    return;
}

-(void) timerPeripheralConnectTimeoutCallback
{
    [MBHUDView hudWithBody:@"Failed To Connect !" type:MBAlertViewHUDTypeExclamationMark hidesAfter:5 show:YES];
    [self SetAppState:E_Disconnected];
}


    
- (IBAction)UIButtonRecomputeClick:(id)sender {
    
    [self ReCompute];
    


}
- (IBAction)UISliderChanged:(id)sender {
    int current = self.UISlider.value;

    
    [self SetGaugeToValue: current+12];
}


#pragma mark - Gesture Handlers
float panningOffset;
float zoomingFactor;

- (IBAction)UIPinchLightPinched:(id)sender {
    
   
#if k_FEATURE_USE_PINCH_ZOOM_IN_TICKER
    UIPinchGestureRecognizer    *myGesture = (UIPinchGestureRecognizer *)sender;
    CGFloat lastScaleFactor = 1;
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    zoomingFactor = factor;
    NSLog(@"Zoomed With Factor %3.2f", zoomingFactor);
    
    [self RefreshLightAndActivityTickerWithZoom:zoomingFactor AndPan:panningOffset ];
    
    if (myGesture.state == UIGestureRecognizerStateEnded)
    {
        if (factor > 1)
        {
            lastScaleFactor += (factor-1);
        }
        else{
            lastScaleFactor *= factor;
        }
        
        
    }
#endif
    
}

- (IBAction)UIPanGesturePanned:(UIPanGestureRecognizer *)sender {
    
#if k_FEATURE_USE_PINCH_ZOOM_IN_TICKER
    CGPoint translation = [sender translationInView:self.view];
    //sender.view.center = CGPointMake(sender.view.center.x + translation.x,
    //                                     sender.view.center.y + translation.y);
    panningOffset = translation.x;
    NSLog(@"Panned With Offset %3.2f", translation.x);
    [self RefreshLightAndActivityTickerWithZoom:zoomingFactor AndPan:panningOffset ];
    if (sender.state == UIGestureRecognizerStateEnded)
    {
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
#endif
    
 
}
@end

