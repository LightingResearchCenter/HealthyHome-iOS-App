//
//  CBManager.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/13/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "CBManager.h"

@implementation CBManager
//--------------------------------------------------------------------------------
#pragma mark - CORE BLUETOOTH CALLBACKS

- (void)StartDiscoveringServices:(CBPeripheral *)per
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    myConnectedPeripheral = per;
    //Todo - Remove the Keys here - no longer needed
    NSArray *keys = [NSArray arrayWithObjects:
                     [CBUUID UUIDWithString:@"0bd51666-e7cb-469b-8e4d-2742f1ba77cc"],
                     [CBUUID UUIDWithString:@"23d1bcea-5f78-2315-deef-121200000000"],
                     [CBUUID UUIDWithString:@"180D"],
                     [CBUUID UUIDWithString:@"1523"],
                     nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"Bluegiga Cable Replacement",
                        @"Nordic",
                        @"Bluegiga Cable Replacement",
                        @"Nordic",
                        
                        nil];
    
    myDictionaryOfServices = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
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
    //  ServiceViewController * hr= [self.storyboard instantiateViewControllerWithIdentifier:@"services"];
    if (timerConnectionTimeout != nil)
    {
        [timerConnectionTimeout invalidate];
    }
    myConnectedPeripheral = peripheral;
    NSLog(@"Connected to peripheral ");
    
    
    // Start discovering Services
    [self StartDiscoveringServices:peripheral];
    [self CBManager_StopScanningForPeripherals];
    [self SetAppState:E_StabalizingReading];
    
    [self.StopWatchPressure Start];
    [self.myMeritGauge.UIViewStopWatch Start];
    
    self.UIlabelSerialNumber.text = [[myConnectedPeripheralCell.peripheralMacId hexadecimalString] uppercaseString];
    
}

/*
 connected to peripheral
 Show service search view
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    
    NSString *myFormattedString = [NSString stringWithFormat:@"Syringe Disconnected"];
    
    [MBHUDView hudWithBody:myFormattedString type:MBAlertViewHUDTypeExclamationMark hidesAfter:2 show:YES];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, myFormattedString);
    
    [self CBManager_StartScanningForPeripherals];
    
    [self SetAppState:E_ScanningForPeripherals];
    
    [self.StopWatchPressure Stop];
    
    // Close if we were on the Confirm to Exit Screen
    if (myViewControllerConfirm.isViewLoaded && myViewControllerConfirm.view.window)
    {
        [myViewControllerConfirm dismissViewControllerAnimated:YES completion:nil];
        //Restore the background Color since the ViewControllerConfirm had changed it
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey_light.png"]];
    }
    
    //Generate Email if the user has Auto Email Generate option turned on and there is an email address configured.
    
    NSArray *myListOfEmailAddresses = [UserSettings ReadArrayForKey:kUserSettingEmailAddressList];
    
    if ([UserSettings GetAutoEmailSetting] == true && ([myListOfEmailAddresses count] > 0))
    {
        
        // Check that there is at least inflation data for this syringe
        NSArray *myArray = [ViewControllerLog GetRecordsForSerialNumber:[[myConnectedPeripheralCell peripheralMacId] hexadecimalString]];
        if ([myArray count] > 0)
        {
            //[self ComposeEmail];
        }
        
    }
    
    //Manage the local objects that kept track of BLE Peripherals
    [myListOfPeripherals removeAllObjects];
    myConnectedPeripheral = nil;
    myConnectedPeripheralCell = nil;
    
}


@end
