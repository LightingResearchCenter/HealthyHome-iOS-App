//
//  ViewControllerHomePage.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 4/22/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewControllerDevices.h"
#include "ViewControllerProfile.h"
#include "ViewControllerGoals.h"
#include "ViewControllerSelectDaysimeter.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralCell.h"
#include "GlobalConfig.h"
#import "ViewControllerSelectDaysimeter.h"

#include "ViewControllerInformation.h"
#include "ViewControllerSettings.h"
#include "ViewControllerDebug.h"

#import "UIViewGlow.h"
#import "ViewControllerGoals.h"
#import "DVSwitch.h"
#include "F3PlotStrip.h"

@interface ViewControllerHomePage : UIViewController <ViewControllerGoalsDelegate, ViewControllerDebugDelegate, ViewControllerDevicesDelegate>
{
    CBCentralManager * myCBManager;
    CBPeripheral * myConnectedPeripheral;
    PeripheralCell *myConnectedPeripheralCell;
    
    
    CBCharacteristic *myCBCharacteristic_DIS_ManufacturerName;
    CBCharacteristic *myCBCharacteristic_DIS_SerialNumber;
    CBCharacteristic *myCBCharacteristic_DIS_FirmwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_HardwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_ModelNumber;

    NSMutableArray   *myListOfPeripherals;
    NSMutableArray   *myListOfPeripheralsCache;

    int m_guard;
    NSDictionary * myDictionaryOfServices;
}
@property (weak, nonatomic) IBOutlet UIView *UIViewMenu;


- (IBAction)TapGestureDevicesTapped:(id)sender;
- (IBAction)TapGestureTreatmentsTapped:(id)sender;
- (IBAction)TapGestureProfileTapped:(id)sender;
- (IBAction)TapGestureGoalsTapped:(id)sender;
- (IBAction)UIButtonAppInfo:(id)sender;
- (IBAction)UIButtonConnect:(id)sender;
- (IBAction)UIButtonWrite:(id)sender;
-(void) RefreshLightAndActivityTicker:(float)scalingFactor;
-(void)ReCompute;
- (IBAction)UIButtonClearPaceMakerData:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UILabelMenu;
@property (weak, nonatomic) IBOutlet UILabel *UILabelNegativeSign;
@property (weak, nonatomic) IBOutlet UILabel *UILabelGaugeLowerLimit;
@property (weak, nonatomic) IBOutlet UILabel *UILabelGaugeUpperLimit;

@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewSync;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonDebug;
@property (weak, nonatomic) IBOutlet UILabel *UILabelTreatmentCount;
@property (weak, nonatomic) IBOutlet UIViewGlow *UIViewGlowProfile;
@property (weak, nonatomic) IBOutlet UIView *UIViewBadge;
@property (weak, nonatomic) IBOutlet UILabel *UILabelManagerState;
@property (weak, nonatomic) IBOutlet UILabel *UILabelSerialNUmber;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonConnect;
@property (weak, nonatomic) IBOutlet UILabel *UILabelAppTitle;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewGoals;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewTreatments;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiLight;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiMotion_dep;
@property (weak, nonatomic) IBOutlet UILabel *UILabelOffsetValue;
- (IBAction)UIButtonRecomputeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *UISlider;
- (IBAction)UISliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UILabelGaugeUnits;

@property (weak, nonatomic) IBOutlet F3PlotStrip *F3PlotStripLight;
@property (weak, nonatomic) IBOutlet F3PlotStrip *F3PlotStripMotion;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewTick;
@property (weak, nonatomic) IBOutlet UILabel *UILabelLightLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *UILabelActivityLastSeen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UIActivityIndicatorBusy;

@property (weak, nonatomic) IBOutlet UILabel *UILabelAppName;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonInfo;
- (IBAction)UIButtonSettingsClicked:(id)sender;
- (IBAction)UIButtonDebugClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UILabelLightGraph;
@property (weak, nonatomic) IBOutlet UILabel *UILabelActivityGraph;
@property (weak, nonatomic) IBOutlet UILabel *UILabelInfo;
@property (weak, nonatomic) IBOutlet UILabel *UILabelPlotStripHeadline;
@property (weak, nonatomic) IBOutlet DVSwitch *DVSwitchGoggles;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiLightLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiWatchLastSeen;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewGoggle;
- (IBAction)UIPinchLightPinched:(id)sender;

- (IBAction)UIPanGesturePanned:(UIPanGestureRecognizer *)sender;

@end
