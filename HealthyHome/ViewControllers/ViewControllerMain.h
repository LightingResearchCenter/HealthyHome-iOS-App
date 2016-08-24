//
//  ViewControllerMain.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/10/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralCell.h"
#include "GlobalConfig.h"
#import "ViewControllerSelectDaysimeter.h"
#import "UIViewGlow.h"
#import "ViewControllerGoals.h"
#import "ViewControllerTreatments.h"

@interface ViewControllerMain : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIApplicationDelegate, ViewControllerGoalsDelegate, ViewControllerTreatmentsDelegate>
{
    // Core Bluetooth Related Variables
    CBCentralManager * myCBManager;
    CBPeripheral * myConnectedPeripheral;
    PeripheralCell *myConnectedPeripheralCell;
    
    CBCharacteristic *myCBCharacteristic_DaysiMotionData;
    CBCharacteristic *myCBCharacteristic_DaysiMotionBattery;
    CBCharacteristic *myCBCharacteristic_DaysiMotionCommand;
    
    CBCharacteristic *myCBCharacteristic_DaysiLightData;
    CBCharacteristic *myCBCharacteristic_DaysiLightBattery;
    CBCharacteristic *myCBCharacteristic_DaysiLightCommand;
    
    CBCharacteristic *myCBCharacteristic_DIS_ManufacturerName;
    CBCharacteristic *myCBCharacteristic_DIS_SerialNumber;
    CBCharacteristic *myCBCharacteristic_DIS_FirmwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_HardwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_ModelNumber;
    
    CBCharacteristic *myCBCharacteristic_HRM_value;
    
    
    // Mutable array of all of the BLE peripherals found as a result of scanning
    NSMutableArray   *myListOfPeripherals;
    NSMutableArray   *myListOfPeripheralsCache;
    
    uint16_t mSyringeVersion;
    uint16_t mSyringeCount;
    
    int m_guard;
    
    NSDictionary * myDictionaryOfServices;
    
    
}


- (IBAction)TapGestureDevicesTapped:(id)sender;
- (IBAction)TapGestureTreatmentsTapped:(id)sender;
- (IBAction)TapGestureProfileTapped:(id)sender;
- (IBAction)TapGestureGoalsTapped:(id)sender;
- (IBAction)UIButtonAppInfo:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewSync;

- (IBAction)UIButtonConnect:(id)sender;
- (IBAction)UIButtonWrite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonDebug;
@property (weak, nonatomic) IBOutlet UILabel *UILabelTreatmentCount;

@property (weak, nonatomic) IBOutlet UIViewGlow *UIViewGlowProfile;
@property (weak, nonatomic) IBOutlet UIView *UIViewBadge;

@property (weak, nonatomic) IBOutlet UILabel *UILabelManagerState;
@property (weak, nonatomic) IBOutlet UILabel *UILabelSerialNUmber;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonConnect;
@property (weak, nonatomic) IBOutlet UILabel *UILabelSyringeCount;
@property (weak, nonatomic) IBOutlet UILabel *UILabelAppTitle;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewGoals;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewTreatments;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiLight;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiMotion;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewHeartRate;

@property (weak, nonatomic) IBOutlet UILabel *UILabelProfile;
@property (weak, nonatomic) IBOutlet UILabel *UILabelTreatments;
@property (weak, nonatomic) IBOutlet UILabel *UILabelGoals;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDevices;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonSettings;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonWrite;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonInfo;
- (IBAction)UIButtonSettingsClicked:(id)sender;
- (IBAction)UIButtonDebugClicked:(id)sender;


@end
