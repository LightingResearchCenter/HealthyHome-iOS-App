//
//  ViewControllerDevices.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerDevices.h"
#include "DaysiUtilities.h"
#include "GlobalConfig.h"
#import   "CoreDataManager.h"
#import "CustomCategories.h"
#include "CSNetAddressKeyboard.h"
#include "UserSettings.h"

#import "ViewControllerDaysiMotionActivity.h"
#import "ViewControllerDaysiDevicePair.h"
#import "ViewControllerDaysiLightActivity.h"
#import "ViewControllerConfirm.h"

#define MAXLENGTH_HUB_ID 9
@interface ViewControllerDevices ()

@end

@implementation ViewControllerDevices

NSTimer    *pulseTimer;
NSTimer    *refreshTimer;
NSDate     *oldestSyncTimeForDaysiMotion;
NSDate     *oldestSyncTimeForDaysiLight;

@synthesize myDaysiLightData;
@synthesize myDaysiMotionData;


bool deviceMotionIdChanged;
bool deviceLightIdChanged;

// Scroll View Sub View Controllers
ViewControllerDaysiMotionActivity *myDaysiMotionActivitySubViewController;
ViewControllerDaysiDevicePair *myDaysiMotionPairSubViewController;
ViewControllerDaysiLightActivity *myDaysiLightActivitySubViewController;
ViewControllerDaysiDevicePair *myDaysiLightPairSubViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)updateTimerRefreshUI
{
    //NSLog(@"Update Timer ViewControllerDevices");
    [self RefreshUIViewControllerDevices];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"DisAppear");
    if (refreshTimer)
    {
        [refreshTimer invalidate];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Appear");
    if (refreshTimer)
    {
        [refreshTimer invalidate];
    }
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(updateTimerRefreshUI)
                                                  userInfo:nil
                                                   repeats:YES];
 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButtonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    NSLog(@" ViewControllerDevices Load");
    
    

    //Grab the oldest Sync time that the DaysiWatch has ever sent
    // We use this to figure out how many days of data has been logged
    oldestSyncTimeForDaysiMotion = [CoreDataManager GetOldestSyncTimeForDaysiLightId:1];
    [self.UIImageViewDaysiMotionSync setHidden:true];
    [self.UIImageViewDaysiLightSync setHidden:true];
    
#pragma SCROLL_VIEW_SETUP
    
    //Set Up Scroll View controller for DaysiMotion
    self.UIScrollViewDaysiMotion.pagingEnabled = YES;
    self.UIScrollViewDaysiMotion.delegate = self;
    NSMutableArray *myDaysiMotionScrollViewArray = [[NSMutableArray alloc] init];
    
    //just adding two controllers
    if (myDaysiMotionActivitySubViewController == nil)
    {
        myDaysiMotionActivitySubViewController = [[ViewControllerDaysiMotionActivity alloc] init];
        myDaysiMotionActivitySubViewController.pDaysiMotion = myDaysiMotionData;
    }
    
    if (myDaysiMotionPairSubViewController == nil)
    {
        myDaysiMotionPairSubViewController = [[ViewControllerDaysiDevicePair alloc] init];
        myDaysiMotionPairSubViewController.delegate = self;
        myDaysiMotionPairSubViewController.UILabelEnterID.text = @"Enter DaysMotion Id";
        myDaysiMotionPairSubViewController.strDeviceId = [UserSettings GetDaysiMotionId];
    }

    

    [myDaysiMotionScrollViewArray addObject:myDaysiMotionActivitySubViewController.view];
    [myDaysiMotionScrollViewArray addObject:myDaysiMotionPairSubViewController.view];
    
    
    CGFloat w = myDaysiMotionActivitySubViewController.view.frame.size.width;
    CGFloat h = myDaysiMotionPairSubViewController.view.frame.size.height;
    
    
    
    self.UIScrollViewDaysiMotion.contentSize = CGSizeMake(w* myDaysiMotionScrollViewArray.count, h-20);
    for (int i = 0; i < myDaysiMotionScrollViewArray.count; i++)
    {
        CGFloat xOrigin = i * w;
        UIView *myView = myDaysiMotionScrollViewArray[i];
        
        //change the x location w/o adjusting the rest of the properties
        [myView setFrame:CGRectMake(xOrigin, 0, myView.frame.size.width, myView.frame.size.height)];
        
        //myView.backgroundColor = [UIColor colorWithRed:0.3/i green:0.5 blue:0.5 alpha:1];
        [self.UIScrollViewDaysiMotion addSubview:myView];
        
    }
    
    self.UIScrollViewDaysiMotion.layer.cornerRadius=8.0f;
    self.UIScrollViewDaysiMotion.layer.masksToBounds=YES;
    self.UIScrollViewDaysiMotion.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.UIScrollViewDaysiMotion.layer.borderWidth= 1.0f;
    
    //page control
    self.UIPageControlDaysiMotion.currentPage=0;
    self.UIPageControlDaysiMotion.numberOfPages=myDaysiMotionScrollViewArray.count;
    lastPage=0;
    
    
    // Set up the Scroll View Controller for the Daysi Goggle
    self.UIScrollViewDaysiLight.pagingEnabled = YES;
    self.UIScrollViewDaysiLight.delegate = self;
    
    //just adding two controllers
    if (myDaysiLightActivitySubViewController == nil)
    {
        myDaysiLightActivitySubViewController = [[ViewControllerDaysiLightActivity alloc] init];
        myDaysiLightActivitySubViewController.myDaysiLight = myDaysiLightData;
        
    }
    
    if (myDaysiLightPairSubViewController == nil)
    {
        myDaysiLightPairSubViewController = [[ViewControllerDaysiDevicePair alloc] init];
        myDaysiLightPairSubViewController.delegate = self;
        myDaysiLightPairSubViewController.UILabelEnterID.text = @"Enter DaysiLight Id";
        myDaysiLightPairSubViewController.strDeviceId= [UserSettings GetDaysiLightId];
        
    }
    
    
    NSMutableArray *myDaysiLightScrollViewArray = [[NSMutableArray alloc] init];
    
    [myDaysiLightScrollViewArray addObject:myDaysiLightActivitySubViewController.view];
    [myDaysiLightScrollViewArray addObject:myDaysiLightPairSubViewController.view];
    
     w = myDaysiLightActivitySubViewController.view.frame.size.width;
     h = myDaysiLightActivitySubViewController.view.frame.size.height;
    
 
    
    self.UIScrollViewDaysiLight.contentSize = CGSizeMake(w* myDaysiLightScrollViewArray.count, h-20);
    for (int i = 0; i < myDaysiLightScrollViewArray.count; i++)
    {
        CGFloat xOrigin = i * w;
        UIView *myView = myDaysiLightScrollViewArray[i];
        
        //change the x location w/o adjusting the rest of the properties
        [myView setFrame:CGRectMake(xOrigin, 0, myView.frame.size.width, myView.frame.size.height)];
        
        //myView.backgroundColor = [UIColor colorWithRed:0.3/i green:0.5 blue:0.5 alpha:1];
        [self.UIScrollViewDaysiLight addSubview:myView];
        
    }
    
    self.UIScrollViewDaysiLight.layer.cornerRadius=8.0f;
    self.UIScrollViewDaysiLight.layer.masksToBounds=YES;
    self.UIScrollViewDaysiLight.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.UIScrollViewDaysiLight.layer.borderWidth= 1.0f;
    
    //page control
    self.UIPageControlDaysiLight.currentPage=0;
    self.UIPageControlDaysiLight.numberOfPages=myDaysiLightScrollViewArray.count;
    lastPage=0;
    
    // Draw a thin border around the Pairing Buttons
    [[self.UIButtonDaysiMotionPair layer] setBorderWidth:1.0f];
    [[self.UIButtonDaysiMotionPair layer] setBorderColor:[UIColor whiteColor].CGColor];

    [[self.UIButtonDaysiLightPair layer] setBorderWidth:1.0f];
    [[self.UIButtonDaysiLightPair layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    //self.UITextFieldControlHubId.inputView = [[CSNetAddressKeyboard alloc]
    //                                                initWithTextField:self.UITextFieldControlHubId keyboardLayout:CSNetAddressKeyboardIPv6];
    self.UITextFieldControlHubId.delegate = self;
    self.UITextFieldControlHubId.text = [UserSettings GetControlHubId];
    
    self.UILabelDaysiLightId.text = [UserSettings GetDaysiLightId];
    self.UILabelDaysiMotionId.text = [UserSettings GetDaysiMotionId];
    
  //  [self UpdateDaysiLightData];
  //  [self UpdateDaysiMotionData];
    
    
}



-(void) resignKeyboard
{
    if (self.UITextFieldControlHubId.text.length == 0)
    {
        self.UITextFieldControlHubId.text = @"3a5k-1554";
    }
    
    else if (self.UITextFieldControlHubId.text.length < MAXLENGTH_HUB_ID)
    {
        
        int length = (int)MAXLENGTH_HUB_ID - (int)self.UITextFieldControlHubId.text.length;
        NSString *preStr = [DaysiUtilities ZerosWithLength:length];
        
        self.UITextFieldControlHubId.text  = [preStr stringByAppendingString:self.UITextFieldControlHubId.text];
    }
    
    [UserSettings SetControlHubId:self.UITextFieldControlHubId.text];
    [self.UITextFieldControlHubId resignFirstResponder];
    
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleBlack;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                //   [[UIBarButtonItem alloc]initWithTitle:@"A" style:UIBarButtonItemStyleBordered target:self action:@selector(addToField:)],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    
    textField.inputAccessoryView = keyboardToolBar;
    return 1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    long length = [textField.text length] ;
    if (length >= MAXLENGTH_HUB_ID && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:MAXLENGTH_HUB_ID];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UIButtonHomeClicked:(id)sender {
    bool disconnectMotion = false;
    bool disconnectLight = false;
    
    //Disconnect if the user wishes to unpair or has changed the DeviceId
    if ([[UserSettings GetDaysiMotionId] isEqual:@"0000"] || deviceMotionIdChanged == 1)
    {
        disconnectMotion = true;
    }
    
    if ([[UserSettings GetDaysiLightId] isEqual:@"0000"] || deviceLightIdChanged == 1)
    {
        disconnectLight = true;
    }
    
    
    
    [self.delegate OnDismissDevices:self DisconnectMotion:disconnectMotion DisconnectLight:disconnectLight];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)RefreshUIViewControllerDevices
{
    
    //Update DaysiMotion Data
    
    [DaysiUtilities SetLayerToGlow:self.UILabelDaysiMotion.layer WithColor:myDaysiMotionData.isDevicePresent?[DaysiUtilities GetDeviceConnectedGlowColor]:[UIColor redColor]];
    

    
    //Update DaysiLightData Data
    [DaysiUtilities SetLayerToGlow:self.UIImageViewDaysiLight.layer WithColor:myDaysiLightData.isDevicePresent?[DaysiUtilities GetDeviceConnectedGlowColor]:[UIColor clearColor]];
    [DaysiUtilities SetLayerToGlow:self.UILabelDaysiLight.layer WithColor:myDaysiLightData.isDevicePresent?[DaysiUtilities GetDeviceConnectedGlowColor]:[UIColor redColor]];
    
    
    [myDaysiMotionActivitySubViewController RefreshUIViewControllerDaysiMotionActivity];
    [myDaysiLightActivitySubViewController RefreshUIViewControllerDaysiLightActivity ];
    
    
}

-(void) UpdateDaysiLightData
{

    [myDaysiLightActivitySubViewController UpdateDaysiActivity:myDaysiLightData];

    // Start an animations that shows Sync in Progress
    [self.UIImageViewDaysiLightSync setHidden:false];
    [DaysiUtilities rotateAndFadeView:self.UIImageViewDaysiLightSync ForDurationInSecs:8];
}

-(void) UpdateDaysiMotionData
{
    
    [myDaysiMotionActivitySubViewController UpdateDaysiActivity:myDaysiMotionData];
    
    // Start an animations that shows Sync in Progress
    [self.UIImageViewDaysiMotionSync setHidden:false];
    [DaysiUtilities rotateAndFadeView:self.UIImageViewDaysiMotionSync ForDurationInSecs:8];


}



-(void) addToField: (UITextField *) field
{
    field.text = @"a";
}



#pragma mark SCROLL VIEW RELATED STUFF
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.UIScrollViewDaysiMotion)
    {
        
        NSLog(@"Scrolling  DaysiMotion Scroll View");
        // Load the pages that are now on screen
        CGFloat pageWidth = self.UIScrollViewDaysiMotion.frame.size.width;
        NSInteger page = (NSInteger)floor((self.UIScrollViewDaysiMotion.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
        self.UIPageControlDaysiMotion.currentPage=page;
        [self.UIButtonDaysiMotionPair setTitle:(page == 0?@"Pair":@"Done") forState:UIControlStateNormal];

        if(page!=lastPage)
        {
            lastPage=page;
            NSLog(@"pageControl: now on page %ld",(long)page);
        }
    }
    
    if (scrollView == self.UIScrollViewDaysiLight)
    {
        
        NSLog(@"Scrolling  DaysiLight Scroll View");
        // Load the pages that are now on screen
        CGFloat pageWidth = self.UIScrollViewDaysiLight.frame.size.width;
        NSInteger page = (NSInteger)floor((self.UIScrollViewDaysiLight.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
        self.UIPageControlDaysiLight.currentPage=page;
        [self.UIButtonDaysiLightPair setTitle:(page == 0?@"Pair":@"Done") forState:UIControlStateNormal];
        if(page!=lastPage)
        {
            lastPage=page;
            NSLog(@"pageControl: now on page %ld",(long)page);
        }
    }
    
    
}
- (IBAction)UIButtonDaysiMotionClicked:(id)sender
{
    int currentPage = self.UIScrollViewDaysiMotion.contentOffset.x / self.UIScrollViewDaysiMotion.frame.size.width;
    
    
    int nextPage = currentPage == 1?0:1;
    
    //Calculate the frame to scroll it to.
    CGRect frame = self.UIScrollViewDaysiMotion.frame;
    frame.origin.x = frame.size.width * nextPage;
    frame.origin.y = 0;
    [self.UIScrollViewDaysiMotion scrollRectToVisible:frame animated:YES];
    
    //self.UIPageControlDaysiMotion.currentPage = currentPage;
}

- (IBAction)UIButtonDaysiLightClicked:(id)sender
{
    int currentPage = self.UIScrollViewDaysiLight.contentOffset.x / self.UIScrollViewDaysiLight.frame.size.width;
    int nextPage = currentPage == 1?0:1;
    
    CGRect frame = self.UIScrollViewDaysiLight.frame;
    frame.origin.x = frame.size.width * nextPage;
    frame.origin.y = 0;
    [self.UIScrollViewDaysiLight scrollRectToVisible:frame animated:YES];
    //self.UIPageControlDaysiLight.currentPage = currentPage;
}

-(void) ConfirmActionCompleted
{
    
    
}

#pragma mark DELEGATES
-(void) OnUpdateDevicePairId:(ViewControllerDaysiDevicePair *)controller PairingId:(NSString *)strId
{

    long recordCount;
    NSString *strOldId;
    
    if (controller == myDaysiMotionPairSubViewController)
    {
        strOldId = [UserSettings GetDaysiMotionId];
        deviceMotionIdChanged = ![strOldId isEqualToString:strId];
        recordCount = [CoreDataManager GetMotionReadingCount];
        
        if (recordCount != 0 && deviceMotionIdChanged == true)
        {
            ViewControllerConfirm *myViewControllerConfirm = [[ViewControllerConfirm alloc]init];
            myViewControllerConfirm.delegate = self;
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
           [self presentViewController:myViewControllerConfirm animated:YES completion: ^{[self ConfirmActionCompleted];}];
            myViewControllerConfirm.UILabelCaption.text = @"Reset All Data \r\n And pair with new DaysiMotion?";
            
        }
        else
        {
            [UserSettings SetDaysiMotionId:strId];
            self.UILabelDaysiMotionId.text = strId;
            [self.UIButtonDaysiMotionPair setHidden: false];
        }
        
    }
    else if (controller == myDaysiLightPairSubViewController)
    {
        strOldId = [UserSettings GetDaysiLightId];
        deviceLightIdChanged = ![strOldId isEqualToString:strId];
        recordCount = [CoreDataManager GetLightReadingCount];
        
        if (recordCount != 0 && deviceLightIdChanged == true)
        {
            ViewControllerConfirm *myViewControllerConfirm = [[ViewControllerConfirm alloc]init];
            myViewControllerConfirm.delegate = self;
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:myViewControllerConfirm animated:YES completion: ^{[self ConfirmActionCompleted];}];
            myViewControllerConfirm.UILabelCaption.text = @"Reset All Data \r\n And pair with new DaysiLight?";
        }
        else
        {
            [UserSettings SetDaysiLightId:strId];
            self.UILabelDaysiLightId.text = strId;
            [self.UIButtonDaysiLightPair setHidden: false];
        }
        
    }
}

-(void) OnEditingPairId:(ViewControllerDaysiDevicePair *)controller
{
    if (controller == myDaysiMotionPairSubViewController)
    {
        [self.UIButtonDaysiMotionPair setHidden:true];
        
    }
    else if (controller == myDaysiLightPairSubViewController)
    {
        [self.UIButtonDaysiLightPair setHidden:true];
        
    }
}


- (void)addItemViewController:(ViewControllerConfirm *)controller didFinishConfirmSelection:(bool)confirmExit
{
 
    if (confirmExit)
    {
        [CoreDataManager DeleteAllLightRecords];
        [CoreDataManager DeleteAllMotionRecords];
        
        NSString *strDaysiLightId = myDaysiLightPairSubViewController.UITextFieldDaysiDeviceAddress.text;
        [UserSettings SetDaysiLightId:strDaysiLightId];
        
        self.UILabelDaysiLightId.text = strDaysiLightId;
        [self.UIButtonDaysiLightPair setHidden: false];
        
        NSString *strDaysiMotionId = myDaysiMotionPairSubViewController.UITextFieldDaysiDeviceAddress.text;
        [UserSettings SetDaysiMotionId:strDaysiMotionId];
        
        self.UILabelDaysiMotionId.text = strDaysiMotionId;
        [self.UIButtonDaysiMotionPair setHidden: false];
        
        
        //Todo - Disconnect the devices
        
        
    }
    else
    {
        self.UILabelDaysiLightId.text = [UserSettings GetDaysiLightId];
        self.UILabelDaysiMotionId.text = [UserSettings GetDaysiMotionId];
        myDaysiLightPairSubViewController.UITextFieldDaysiDeviceAddress.text = [UserSettings GetDaysiLightId];
         myDaysiMotionPairSubViewController.UITextFieldDaysiDeviceAddress.text = [UserSettings GetDaysiMotionId];
        [self.UIButtonDaysiMotionPair setHidden: false];
        [self.UIButtonDaysiLightPair setHidden: false];
    }
    
    
}

@end
