//
//  ViewControllerMain.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/10/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerMain.h"
#import "ViewControllerDevices.h"
#include "ViewControllerProfile.h"
#include "ViewControllerGoals.h"
#include "ViewControllerTreatments.h"
#include "ViewControllerSelectDaysimeter.h"
#include "ViewControllerInformation.h"
#include "ViewControllerSettings.h"
#include "ViewControllerDebug.h"

#include "MBHUDView.h"
#include "JSCustomBadge.h"
#include "CustomCategories.h"
#include "ViewControllerConfirm.h"
#include "UserSettings.h"
//#include "Battery.h"

#include "RscMgr.h"
#include "DaysiUtilities.h"
#import  "EntityReading.h"
#include "AppDelegate.h"
#include "DaysiLight.h"
#import "CoreDataManager.h"

#include "CircadianModelManager.h"


@interface ViewControllerMain ()

@end

@implementation ViewControllerMain

#pragma mark PRIVATE_MEMBERS

#define PULSESCALE 1.1
#define PULSEDURATION 0.2




//View Controllers managed by ViewControllerMain
ViewControllerDevices *myViewControllerDevices;
ViewControllerProfile *myViewControllerProfile;
ViewControllerTreatments *myViewControllerTreatments;
ViewControllerGoals *myViewControllerGoals;
ViewControllerInformation *myViewControllerInformation;
ViewControllerSettings *myViewControllerSettings;
ViewControllerDebug *myViewControllerDebug;
ViewControllerConfirm *myViewControllerConfirm;

// Timers
NSTimer *timerConnectionTimeout;          // Timer for establishing a connection with a selected peripheral
NSTimer *timerScanForPeripherals;         // Timer for scanning looking for peripherals
NSTimer *timerAuthenticateWithSyringe;    // Timer to Authenticate the iPad with the Daysi Watch
NSTimer *timerAuthenticateWithGoggle;     // Timer to Authenticate the Daysi Goggles
NSTimer *timerCircadianModelCompute;      // Timer used to Compute the circadian Model

//Animations
CABasicAnimation *myPulseAnimation;       // Simple Animation to create a pulse effect


//GUID's

NSString * const pUUIDDaysiMotionService =        @"00001523-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionDataChar =         @"00001524-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionCommandChar =      @"00001525-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiMotionBatteryChar =      @"00001526-1212-efde-1523-785feabcd123";


NSString * const pUUIDDaysiLightService =       @"00001623-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightDataChar =       @"00001624-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightCommandChar =    @"00001625-1212-efde-1523-785feabcd123";
NSString const *pUUIDDaysiLightBatteryChar =    @"00001626-1212-efde-1523-785feabcd123";

NSString const *pUUID_DAYSI_GLASS_DIS =                @"180a";
NSString const *pUUID_DAYSI_GLASS_BATTERY=             @"180f";

NSString const *pUUIDRaptorDIS_ModelNumber =                      @"2a24";
NSString const *pUUIDRaptorDIS_SerialNumber =                     @"2a25";
NSString const *pUUIDRaptorDIS_FirmwareRevision =                 @"2a26";
NSString const *pUUIDRaptorDIS_HardwareRevision =                 @"2a27";
NSString const *pUUIDRaptorDIS_ManufacturerName =                 @"2a29";
NSString const *strSyringInitiate = @"657657656579775634533";


// Names of different BLE periherals that we are interested in.  These match the strings that are
// advertised by the peripherals - Do not change unless you change the peripheral

NSString *const pDaysiMotionDeviceName = @"Daysi*Motion";
NSString *const pDaysiLightDeviceName = @"Daysi*Light";

NSString const *pUUID_HeartRateMonitor_HRS=          @"180d";
NSString const *pUUID_HeartRateMonitor_HRM_Value =   @"2a37";


//Business Objects
DaysiMotion *myDaysiMotionDevice;           //Member variable that stores the DaysiMotion data
DaysiLight *myDaysiLightDevice;             //Member variable that stores the DaysiLight data

//Animations
CABasicAnimation *myPulseAnimation;       // Simple Animation to create a pulse effect

#define PULSESCALE 1.1
#define PULSEDURATION 0.2
#define DISPLAY_TICKS_NOT_PRESSURE (1)

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
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
    // Scale the ViewRaptorGauge using a transform.  This scales all of its children as well
    //self.myMeritGauge.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    
    // Clear out the list of all peripherals - we will start fresh
    [myListOfPeripherals removeAllObjects];
    
    

    // myMailComposer = [[MFMailComposeViewController alloc] init];
    
    
    [self SetToGlow:self.UIImageViewGoals WithColor:[UIColor orangeColor]];
    [self SetToGlow:self.UIImageViewProfile WithColor:[UIColor orangeColor]];
    [self SetToGlow:self.UIImageViewTreatments WithColor:[UIColor orangeColor]];
    [self SetButtonToGlow:self.UIButtonInfo WithColor:[UIColor orangeColor]];
    
    [DaysiUtilities SetLayerToGlow:self.UILabelDevices.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UILabelProfile.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UILabelTreatments.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UILabelGoals.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIButtonSettings.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiLight.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiMotion.layer WithColor:[UIColor orangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIImageViewHeartRate.layer WithColor:[UIColor orangeColor]];
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // Create a timer - when this timer times out we are done scanning for peripherals
    timerScanForPeripherals  = [NSTimer scheduledTimerWithTimeInterval:(k_SCAN_ATTEMPT_DELAY_INTERVAL_SECONDS)
                                                                    target:self
                                                                  selector:@selector(timerScanForPeripheralsTimeoutCallback)
                                                                  userInfo:nil
                                                                   repeats:NO];

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
    //Instantiate the Circadian Manager that manages the Circadian Treatments
    myCircadianManager = [[CircadianModelManager alloc]init];
    [self ReCompute];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) proximityChanged
{
    NSLog (@"Proxmity Changed");
    
}

#pragma mark - CB Manager Services
-(void) CBManager_StartScanningForPeripherals
{
    // Start a scan - we will stop scanning when a timer expires
    [myCBManager scanForPeripheralsWithServices:nil
                                        options: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                             forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
    
}

-(void) CBManager_StopScanningForPeripherals
{
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
            myString = @"Bluetooth on this device is currently powered off.";
            faultState = true;
            break;
        case CBCentralManagerStateResetting:
            myString = @"The BLE Manager is resetting; a state update is pending.";
            break;
        case CBCentralManagerStatePoweredOn:
            myString = [NSString stringWithFormat:NSLocalizedString(@"lsScanOrPressConnect", nil)];
            break;
        case CBCentralManagerStateUnknown:
            myString = @"The state of the BLE Manager is unknown.";
            break;
        default:
            myString = @"The state of the BLE Manager is unknown.";
            
    }
    
    if (faultState)
    {
        [MBHUDView hudWithBody:myString type:MBAlertViewHUDTypeExclamationMark hidesAfter:k_POPUP_DISPLAY_TIME_SECONDS show:YES];
        
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

    
    
    if (peripheral == myDaysiMotionDevice.blePeripheral)
    {
        [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiMotion.layer WithColor:[DaysiUtilities GetDeviceConnectedGlowColor]];
        [self.UIImageViewDaysiMotion.layer addAnimation:myPulseAnimation forKey:@"Pulse"];
     }
    
    
    if (peripheral == myDaysiLightDevice.blePeripheral)
    {
        [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiLight.layer WithColor:[DaysiUtilities GetDeviceConnectedGlowColor]];
        [self.UIImageViewDaysiLight.layer addAnimation:myPulseAnimation forKey:@"Pulse"];
    }
    
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
    
    
    //Figure out who disconnected
    
    if (peripheral == myDaysiMotionDevice.blePeripheral)
    {
        myDaysiMotionDevice.isDevicePresent = false;
        //[MBHUDView hudWithBody:@"Daysi Disconnected" type:MBAlertViewHUDTypeCheckmark hidesAfter:2 show:YES];
        NSLog([NSString stringWithFormat:@"Error: %@", error]);

        [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiMotion.layer WithColor:[UIColor orangeColor]];
        [self.UIImageViewDaysiMotion.layer removeAllAnimations];
        if (myViewControllerDevices)
        {
            //[myViewControllerDevices Update:myHeartBeatData];
            
        }
    }
    
    if (peripheral == myDaysiLightDevice.blePeripheral)
    {
        myDaysiLightDevice.isDevicePresent = false;
        //[MBHUDView hudWithBody:@"Daysi Disconnected" type:MBAlertViewHUDTypeCheckmark hidesAfter:2 show:YES];
        [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiLight.layer WithColor:[UIColor orangeColor]];
        [self.UIImageViewDaysiLight.layer removeAllAnimations];
        if (myViewControllerDevices)
        {
            //[myViewControllerDevices Update:myHeartBeatData];
            
        }
    }
    
    NSString *myFormattedString = [NSString stringWithFormat:@"Disconnected"];
    
//    [MBHUDView hudWithBody:myFormattedString type:MBAlertViewHUDTypeExclamationMark hidesAfter:2 show:YES];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, myFormattedString);
    
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
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error

{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [error debugDescription]);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"%s %lu Services Found", __PRETTY_FUNCTION__, (unsigned long)peripheral.services.count);
    
    
    bool foundMeritPressureDevice = false;
    CBService* ser;
    for (int i=0; i< peripheral.services.count; i++)
    {
        ser =[peripheral.services objectAtIndex:i];
        NSLog(@"Service %d: %@", i, [ser.UUID representativeString]);
        
        if([[ser.UUID representativeString]  isEqual:pUUID_DAYSI_GLASS_DIS])
        {
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUID_DAYSI_GLASS_BATTERY])
        {
            foundMeritPressureDevice = true;
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUIDDaysiMotionService])
        {
            foundMeritPressureDevice = true;
            NSLog(@"Found the DaysiMotion Service");
            [self connectService:ser];
        }
        
        if([[ser.UUID representativeString] isEqual:pUUIDDaysiLightService])
        {
            foundMeritPressureDevice = true;
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
    NSLog(@"Found %lu peripheral as a result of scanning", (unsigned long)myListOfPeripherals.count);
    
    
    // Get the manufacturer data from the advertisement packet. The manufacturer data contains the MACId of the peripheral
    NSData *pManufacturerData = [advertisementData valueForKey:@"kCBAdvDataManufacturerData"];
    NSLog (@"Manufacturer Data %@", [pManufacturerData hexadecimalString] );
    NSData *pMACIdData = [pManufacturerData subdataWithRange:NSMakeRange(2, [pManufacturerData length]-2) ];
    NSLog (@"MacId Data %@", [pMACIdData hexadecimalString] );
    NSLog(@"MAC Id Data Is %@", pMACIdData);
    NSLog (@"UUID is  %@", peripheral.UUID);
    NSLog (@"UUID is  %@", peripheral.identifier);
    
    
    NSLog(@"Found Peripheral with Name: %@ RSSI data:%@ AdvData: %@", peripheral.name, peripheral.RSSI, advertisementData);
    
    NSString *localName;
    
    //Check if the DaysiMotion Device Exists -
    localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (myDaysiMotionDevice.isDevicePresent == false)
    {
        if ([localName isEqualToString:pDaysiMotionDeviceName])
        {
            myDaysiMotionDevice.isDevicePresent = true;
            myDaysiMotionDevice.blePeripheral = peripheral;
            myDaysiMotionDevice.deviceId = [pMACIdData hexadecimalString];
            [myCBManager connectPeripheral:peripheral options:nil];
         
        }
    }
    
    //Check if the DaysiLight Device Exists -
    localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (myDaysiLightDevice.isDevicePresent == false)
    {
        if ([localName isEqualToString:pDaysiLightDeviceName])
        {
            myDaysiLightDevice.isDevicePresent = true;
            myDaysiLightDevice.blePeripheral = peripheral;
            myDaysiLightDevice.deviceId = [pMACIdData hexadecimalString];
            [myCBManager connectPeripheral:peripheral options:nil];
          
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
    myCBCharacteristic_DaysiMotionData = nil;
    myCBCharacteristic_DaysiMotionBattery = nil;
    
    [myConnectedPeripheral setDelegate:self];
    [myConnectedPeripheral discoverCharacteristics:nil forService:service];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if(error)
    {
        //handle error
        myCBCharacteristic_DaysiMotionData=nil;
        myCBCharacteristic_DaysiMotionBattery=nil;
        
        NSLog(@"%@ %@", [characteristic.UUID representativeString], error.debugDescription);
    }
    
    else
    {
        
    }
}


//Server has updated the value for a characteristic
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if(error != nil)
    {
        NSLog(@"Error in %s",  __PRETTY_FUNCTION__);
        return;
    }
    
    // Characteristic data array is the raw bucket of bytes received from the peripheral
    const uint8_t *characteristicDataArray = [characteristic.value bytes];
    
    CBUUID *pUUID = characteristic.UUID;
    
    
#if DEBUG
    // Used for dumping the data to a NSLog as a Hex String
    // #ifdef for Release
    int dataLength = [characteristic.value length];
    NSUInteger capacity =  dataLength* 2;
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *dataBuffer = [characteristic.value bytes];
    NSInteger i;
    for (i=0; i<[characteristic.value length]; ++i) {
        [stringBuffer appendFormat:@"%02X", (NSUInteger)dataBuffer[i]];
    }
    
    NSLog(@"\r\n\r\nBytes Received %d Data Received for UDID %@ is %@",dataLength, [pUUID representativeString], stringBuffer);
#endif
    
    // DaysiMotion data  Received
    // -------------------------
    if ([[pUUID representativeString] isEqual:pUUIDDaysiMotionDataChar])
    {
        NSLog(@"DaysiMotion Data Received");
        
        [self SetAppState:E_Measuring];
        
        m_guard = 1;
        
        // Parse the data recieved from the DaysiMotion ....
        [myDaysiMotionDevice ParseFromByteArray:characteristicDataArray];
        
        [CoreDataManager LogDaysiMotionRecord:myDaysiMotionDevice.deviceId
                                         RedValue: [myDaysiMotionDevice GetDaysiData]->redValue
                                        BlueValue: [myDaysiMotionDevice GetDaysiData]->blueValue
                                       GreenValue: [myDaysiMotionDevice GetDaysiData]->greenValue
                                    AvtivityValue: [myDaysiMotionDevice GetDaysiData]->activityValue
                                   BatteryVoltage: [myDaysiMotionDevice GetBatteryVoltageInMilliVolts]
                                         DateTime: [NSDate date]];
        
        myDaysiMotionDevice.lastSeen = [NSDate date];
        [self StartRotateAnimation:1];
        [self WriteCommandToDaysiMotion];
        
        
        //If the debug ViewController is present - update it!
        if (myViewControllerDebug)
        {
            [myViewControllerDebug UpdateDaysiMotionData:myDaysiMotionDevice];
                
        }
        
        //If the devices ViewController is present - update it!
        if (myViewControllerDevices)
        {
            [myViewControllerDevices UpdateDaysiMotionData:myDaysiMotionDevice];
            
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
        
        
        NSLog(@"%@", [myDaysiMotionDevice GetDebugString]);
        
     }
    
    // DaysiLight Data Received
    // --------------------------
    if ([[pUUID representativeString] isEqual:pUUIDDaysiLightDataChar])
    {
        NSLog(@"Daysi Goggle Data Received");
        
        
        // Parse the data recieved from the DaysiMotion ....
        [myDaysiLightDevice ParseFromByteArray:characteristicDataArray];
         myDaysiLightDevice.lastSeen = [NSDate date];
        [myDaysiLightDevice WriteCommand];
        
        //If the debug ViewController is present - update it!
        if (myViewControllerDebug)
        {
            [myViewControllerDebug UpdateDaysiLightData:myDaysiLightDevice];
            
        }
        
        //If the debug ViewController is present - update it!
        if (myViewControllerDevices)
        {
            [myViewControllerDevices UpdateDaysiLightData:myDaysiLightDevice];
            
        }
        
        
        m_guard = 0;
        
        
        NSLog(@"%@", [myDaysiLightDevice GetDebugString]);
        
    }
    
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
            myCBCharacteristic_DaysiMotionData = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myCBCharacteristic_DaysiMotionData];
        }
        
        if ( [myString isEqual: pUUIDDaysiMotionBatteryChar])
        {
            myCBCharacteristic_DaysiMotionBattery = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myCBCharacteristic_DaysiMotionBattery];
        }
        
        if ( [myString isEqual: pUUIDDaysiMotionCommandChar])
        {
            myCBCharacteristic_DaysiMotionCommand = myCharacteristic;
            [peripheral setNotifyValue:YES forCharacteristic: myCBCharacteristic_DaysiMotionCommand];
            
            // Authenticate yourself with the DaysiMotion by writing to the Characteristic shortly
            timerAuthenticateWithSyringe =   [NSTimer scheduledTimerWithTimeInterval:(1)
                                                                              target:self
                                                                            selector:@selector(WriteCommandToDaysiMotion)
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
                                                                            selector:@selector(WriteCommandToDaysiLight)
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
            myCBCharacteristic_DIS_FirmwareVersion = myCharacteristic;
            [myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_FirmwareVersion];
            [peripheral setNotifyValue:YES forCharacteristic: myCharacteristic];
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
        
        if ( [myString isEqual: pUUID_HeartRateMonitor_HRM_Value])
        {
            myCBCharacteristic_HRM_value = myCharacteristic;
            //[myConnectedPeripheral readValueForCharacteristic: myCBCharacteristic_DIS_ModelNumber];
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
    //Run the Circadian Manager as the user may have changed the goals
    //Todo - Optimize and only run if the goals
    int errorCode = [myCircadianManager Recompute];
    
    if (errorCode == 0)
    {
        self.UILabelTreatmentCount.text = [NSString stringWithFormat:@"%d",[myCircadianManager GetTreatments]->count];
        [myTreatmentCountBadge  autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",[myCircadianManager GetTreatments]->count]];
        NSLog(@"Treatment %d",[myCircadianManager GetTreatments]->count);
        [self setApplicationBadgeNumber:[myCircadianManager GetTreatments]->count];
        
    }
    else
    {
        self.UILabelTreatmentCount.text = [NSString stringWithFormat:@"!"];
        [myTreatmentCountBadge  autoBadgeSizeWithString:@"!"];
        [self setApplicationBadgeNumber:0];
        
        NSLog(@"Error %x",errorCode);
    }
    
    
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

#pragma mark - Call Backs from Other ViewControllers
-(void) OnDismissGoals:(ViewControllerGoals *)controller Confirm:(bool)confirm
{
  
    [self ReCompute];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    self.view.layer.zPosition = 100;
//    CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    [animation setToValue:[NSValue valueWithCATransform3D:transform]];
//    [animation setDuration:1.5];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    [animation setFillMode:kCAFillModeForwards];
//    [animation setRemovedOnCompletion:YES];
//    [animation setDelegate:self];
//    
//    [self.UIViewBadge.layer addAnimation:animation forKey:@"test"];
    
    
}

-(void) OnDismissTreatments:(ViewControllerTreatments *)controller Confirm:(bool)confirm
{
   
}

//--------------------------------------------------------------------------------
#pragma mark - Manage the View Controller Main

-(void) SetAppState:(E_AppState_T)state
{
    m_AppState = state;
    [self RefreshUI:state];
    
}
-(void) RefreshUI :(E_AppState_T)newState
{
    
    static E_AppState_T oldAppState = E_AppState_Count;
    
    if (newState == oldAppState)
    {
        //return;
    }
    
    
    switch (newState) {
        case E_Disconnected:
            
            
            
            
            break;
            
            
        case E_ScanningForPeripherals:
            
            
            
            [self.UILabelManagerState setHidden:TRUE];
            [self.UIButtonWrite setHidden:TRUE];
            [self.UILabelSyringeCount setHidden:true];
            [self.UILabelSerialNUmber setHidden:true];
            self.UILabelManagerState.Text = [NSString stringWithFormat:NSLocalizedString(@"lsPullTab", nil)];
            [self.UIButtonConnect setHidden:true];
            break;
            
        case E_ReadyToConnect:
            // We have found a Device and are ready to Connect
            
            
            [self.UILabelManagerState setHidden:false];
            self.UILabelManagerState.Text = [NSString stringWithFormat:NSLocalizedString(@"lsScanOrPressConnect", nil)];
            
            [self.UIButtonConnect setHidden:false];
            
            
            self.UIButtonConnect.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"lsConnect", nil)];
            //NSString *myStr = [NSString stringWithFormat:NSLocalizedString(@"strConnect", nil)];
            NSLog(@"%@", self.UIButtonConnect.titleLabel.text);
            
            
            
            
            
            
            break;
            
        case E_CannotConnect:
            
            [self.UILabelManagerState setHidden:false];
            self.UILabelManagerState.Text = @"Pull Tab";//[NSString stringWithFormat:NSLocalizedString(@"lsPullTab", nil)];
            
            
            self.UIButtonConnect.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"lsConnect", nil)];
            
            
            [self.UILabelManagerState setHidden:false];
            
            
            
            break;
            
            
            
        case E_StabalizingReading:
            
            
            
            
            
            
            break;
            
            
            
        case E_AttemptingToConnect:
            // Peripheral has been Discovered - We are now attempting to connect
            
            
            
            [self.UILabelManagerState setHidden:true];
            
            
            self.UIButtonConnect.titleLabel.text = @"Disconnect";
            
            
            [[self.UIButtonConnect layer] removeAnimationForKey:@"scale"];
            
            
            break;
            
        case E_Measuring:
            // We are finally measuring and getting data from the peripheral
            if (m_guard == 0)
            {
                
            }
            else
            {
                NSLog(@"Atomic Access");
            }
            
            break;
        default:
            break;
    }
    
    oldAppState = newState;
    
}


#pragma mark -  Read/Write To DaysiMeter
- (IBAction)Read:(id)sender
{
    
    
}

-(void) WriteCommandToDaysiMotion
{
    
    //Todo - Authenticate using a signature that is a hash of the MACID
    NSData *data = [NSData dataWithBytes: (void *)[myDaysiMotionDevice GetDaysiStatus]  length: sizeof(DAYSI_STATUS_T)];
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiMotionCommand UUID] representativeString]);
    
    NSLog(@"Data Written %@", [data hexadecimalString]);
    
    [myDaysiMotionDevice.blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiMotionCommand type:CBCharacteristicWriteWithResponse];
    
}

-(void) WriteCommandToDaysiLight
{
    [myDaysiLightDevice WriteCommand];
}



-(void) WriteStatusCommandToDaysiMotion
{
    //Todo - Authenticate using a signature that is a hash of the MACID
    NSData *data = [NSData dataWithBytes: (void *)[myDaysiMotionDevice GetDaysiData]  length: sizeof(DAYSI_DATA_T)];
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiMotionCommand UUID] representativeString]);
    [myDaysiMotionDevice.blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiMotionCommand type:CBCharacteristicWriteWithResponse];
    
}


-(NSString *)GetSyringeVersionString
{
    NSString *myString;
    
    NSLog(@"Serial Numer: %@", myCBCharacteristic_DIS_SerialNumber.value);
    if (m_AppState != E_Measuring)
    {
        myString = @"Syringe Info: Disconnected \r\n";
        
    }
    else
    {
        NSString *serialNumber =[[NSString alloc] initWithData:myCBCharacteristic_DIS_SerialNumber.value
                                                      encoding:NSUTF8StringEncoding] ;
        
        NSString *firmwareVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_FirmwareVersion.value
                                                         encoding:NSUTF8StringEncoding];
        
        NSString *hardwareVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_HardwareVersion.value
                                                         encoding:NSUTF8StringEncoding];
        
        NSString *modelVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_ModelNumber.value
                                                      encoding:NSUTF8StringEncoding];
        
        
        
        myString = [NSString stringWithFormat:
                    @"Syringe:\r\n"
                    " F/W Version: %@\r\n"
                    " Serial Number: %@\r\n "
                    " H/W Version: %@\r\n "
                    " Model Version: %@\r\n ", firmwareVersion, serialNumber, hardwareVersion, modelVersion];
        
        
        
    }
    
    return myString;
}


- (IBAction)UIButtonWrite:(id)sender {
    [self WriteCommandToDaysiMotion];
}

- (IBAction)UIButtonConnect:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if(m_AppState == E_ReadyToConnect)
    {
        NSLog(@"Connecting");
        [self.UIButtonConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
        
        
        if (k_FEATURE_SCAN_CONTINOUSALLY == 0)
        {
            
            // Clear out the list of all peripherals - we will start fresh
            [myListOfPeripherals removeAllObjects];
            
            
            // Create a list of services that you want to scan for.  Setting services to nil forces the BLE Central to scan for all services.
            NSArray * services=[NSArray arrayWithObjects:
                                [CBUUID UUIDWithString:pUUIDDaysiMotionService],
                                [CBUUID UUIDWithString:pUUIDDaysiLightService],
                                
                                nil
                                ];
            
            
            // Create a timer - when this timer times out we are done scanning for peripherals
            timerScanForPeripherals  = [NSTimer scheduledTimerWithTimeInterval:(k_SCAN_ATTEMPT_INTERVAL_SECONDS)
                                                                        target:self
                                                                      selector:@selector(timerScanForPeripheralsTimeoutCallback)
                                                                      userInfo:nil
                                                                       repeats:NO];
            
            // Start a scan - we will stop scanning when a timer expires
            [myCBManager scanForPeripheralsWithServices:services
                                                options: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                                     forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
        }
        else
        {
            
            // Check how many peripherals we found.
            // If we find no peripherals - there is a problem - inform the user
            // If multiple peripherals were found  - present a UI to the user to select from a list of peripherals
            
            if (myListOfPeripherals.count == 0)
            {
                // Show error message that no devices were found as a result of the scan
                [MBHUDView hudWithBody:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Syringe Not Found", @"Localizable.strings", nil)] type:MBAlertViewHUDTypeExclamationMark hidesAfter:k_POPUP_DISPLAY_TIME_SECONDS show:YES];
                [self SetAppState:E_Disconnected];
                
            }
            
            else if (k_FEATURE_AUTOCONNECT_IF_ONE_SYRINGE &&  myListOfPeripherals.count == 1)
            {
                // Just connect to the Syringe since this is the only peripheral we found as a result of scanning for all peripherals
                PeripheralCell *myPeripheralCell = [myListOfPeripherals objectAtIndex:0];
                NSLog(@"Connecting to MAC ID: %@", [myPeripheralCell.peripheralMacId hexadecimalString]);
                
                [myCBManager connectPeripheral:myPeripheralCell.peripheral options:nil];
                
                //Fire off a timer - if we timeout and are not connected - there is a problem!
                timerConnectionTimeout = [NSTimer scheduledTimerWithTimeInterval:(k_PERIPHERAL_CONNECT_INTERVAL_SECONDS)
                                                                          target:self
                                                                        selector:@selector(timerPeripheralConnectTimeoutCallback)
                                                                        userInfo:nil
                                                                         repeats:NO];
                [self SetAppState:E_AttemptingToConnect];
            }
            
            else
            {
                // Present a View Controller that lets the user choose from a list of peripherals
                ViewControllerSelectDaysimeter * vc = [[ViewControllerSelectDaysimeter alloc] init];
                vc.myList = myListOfPeripherals;
                vc.delegate = self;
                
                self.view.backgroundColor = [UIColor clearColor];
                self.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:vc animated:YES completion: ^{[self SyringeSelectCompleted];}];
                
                
            }
            
            
            
            
        }
        if (m_AppState == E_Disconnected)
        {
            [self SetAppState:E_ReadyToConnect];
        }
        
    }
    else  // If already connected - Disconnect after prompting the user
    {
        
        NSLog(@"Disconnecting");
        if (myConnectedPeripheral.isConnected)
        {
            [myCBManager cancelPeripheralConnection:myConnectedPeripheral];
        }
        [self SetAppState:E_ReadyToConnect];
        
        //          myViewControllerConfirm = [[ViewControllerConfirm alloc] init];
        //         self.view.backgroundColor = [UIColor clearColor];
        //         self.modalPresentationStyle = UIModalPresentationCurrentContext;
        //         myViewControllerConfirm.delegate = self;
        //        [self presentViewController:myViewControllerConfirm animated:YES completion: ^{[self ConfirmActionCompleted];}];
        
    }
}




//--------------------------------------------------------------------------------
#pragma mark - APP TIMEOUT HANDLERS

- (void) timerScanForPeripheralsTimeoutCallback
{
    [self CBManager_StartScanningForPeripherals];
    return;
}

//This callback is called when the App fails to connect with the Peripheral
-(void) timerPeripheralConnectTimeoutCallback
{
    [MBHUDView hudWithBody:@"Failed To Connect !" type:MBAlertViewHUDTypeExclamationMark hidesAfter:5 show:YES];
    [self SetAppState:E_Disconnected];
}


-(void) SyringeSelectCompleted
{
    
    
}


-(void) timerCircadianModelCompute
{
    // CircadianModelCompute();
    //Fill up the Treatment from the algorithm.
    
}

#pragma mark - GESTURE AND BUTTON HANDLERS
- (IBAction)UIButtonAppInfo:(id)sender {
    
    myViewControllerInformation = [[ViewControllerInformation alloc] init];
    //self.view.backgroundColor = [UIColor clearColor];
     
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:myViewControllerInformation animated:YES completion: ^{[self ConfirmActionCompleted];}];
}

- (IBAction)UIButtonSettingsClicked:(id)sender {
    myViewControllerSettings = [[ViewControllerSettings alloc] init];
    //self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:myViewControllerSettings animated:YES completion: ^{[self ConfirmActionCompleted];}];
    
}

- (IBAction)UIButtonDebugClicked:(id)sender {
    
    
    myViewControllerDebug = [[ViewControllerDebug alloc] init];

    self.modalPresentationStyle = UIModalPresentationCurrentContext;

    //myViewControllerDevices.delegate = self;
    [self presentViewController:myViewControllerDebug animated:YES completion: ^{[self ConfirmActionCompleted];}];

}
- (IBAction)TapGestureDevicesTapped:(id)sender {
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //myViewControllerDevices.delegate = self;
    [self presentViewController:myViewControllerDevices animated:YES completion: ^{[self ConfirmActionCompleted];}];
    
}

- (IBAction)TapGestureTreatmentsTapped:(id)sender
{
    
    // Recompute the treatments based on any new data that meay be availiable.
    [self ReCompute];
    
    myViewControllerTreatments = [[ViewControllerTreatments alloc] init];
    myViewControllerTreatments.delegate = self;
    myViewControllerTreatments.ciracdianManager = myCircadianManager;
 
    //self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    myViewControllerTreatments.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //myViewControllerDevices.delegate = self;
    [self presentViewController:myViewControllerTreatments animated:YES completion: ^{[self ConfirmActionCompleted];}];
}




- (IBAction)TapGestureProfileTapped:(id)sender {
    
    myViewControllerProfile = [[ViewControllerProfile alloc] init];
    //self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //myViewControllerDevices.delegate = self;
    [self presentViewController:myViewControllerProfile animated:YES completion: ^{[self ConfirmActionCompleted];}];
}

- (IBAction)TapGestureGoalsTapped:(id)sender {
    myViewControllerGoals = [[ViewControllerGoals alloc] init];
    myViewControllerGoals.delegate = self;
    //self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //myViewControllerDevices.delegate = self;
    [self presentViewController:myViewControllerGoals animated:YES completion: ^{[self ConfirmActionCompleted];}];
}



-(void) ConfirmActionCompleted
{
    
    
}

-(void) StartRotateAnimation: (int)animationTimeSeconds
{
    [self.UIImageViewSync setHidden:false];
     [DaysiUtilities rotateAndFadeView:self.UIImageViewSync ForDurationInSecs:5];

}




@end

