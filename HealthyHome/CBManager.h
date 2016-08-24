//
//  CBManager.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/13/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CBManager : NSObject
{
    // Core Bluetooth Related Variables
    CBCentralManager * myCBManager;
    CBPeripheral * myConnectedPeripheral;
    PeripheralCell *myConnectedPeripheralCell;
    
    
    CBCharacteristic *myCBCharacteristic_SysPressure;
    CBCharacteristic *myCBCharacteristic_SysBattery;
    
    CBCharacteristic *myCBCharacteristic_SysWriteCommand;
    
    CBCharacteristic *myCBCharacteristic_DIS_ManufacturerName;
    CBCharacteristic *myCBCharacteristic_DIS_SerialNumber;
    CBCharacteristic *myCBCharacteristic_DIS_FirmwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_HardwareVersion;
    CBCharacteristic *myCBCharacteristic_DIS_ModelNumber;
    
    // Mutable array of all of the BLE peripherals found as a result of scanning
    NSMutableArray   *myListOfPeripherals;
    NSMutableArray   *myListOfPeripheralsCache;
    
    uint16_t mSyringeVersion;
    uint16_t mSyringeCount;
    
    int m_guard;
    
    NSDictionary * myDictionaryOfServices;
    

}
@end
