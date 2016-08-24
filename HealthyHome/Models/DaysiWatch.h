//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Pressure

#import <Foundation/Foundation.h>
#include <CoreBluetooth/CoreBluetooth.h>

// Note - This typedef must match the Raptor Syringe Firmware
// Note - Keep the data packed on a byte boundary

#pragma pack (1)
typedef struct DAYSI_DATA
{
    uint8_t  preambleLo;
    uint8_t  preambleHi;
    uint8_t     command;
    uint8_t     version;
    uint8_t     length;
    
    uint32_t    eepromAddress;
    uint16_t    redValue;
    uint16_t    greenValue;
    uint16_t    blueValue;
    uint16_t    activityValue;
    uint16_t    batteryVoltage;

    uint8_t     crc;
} DAYSI_DATA_T;
#pragma pack (8)


#pragma pack (1)
typedef struct DAYSI_STATUS
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    uint8_t     length;
    
    // -- Actual Data Payload
    uint32_t    eepromAddress;
    uint8_t     controlFlags;
    uint16_t    logIntervalInSeconds;
    uint32_t    time;
    
    uint8_t unused1;
    uint8_t unused2;
    uint8_t unused3;
    
    uint8_t     crc;
} DAYSI_STATUS_T;


#pragma pack (8)
typedef enum
{
    E_No_Error,
    E_LatencyOver_2000,
    E_LatencyOver_1000,
    E_LatencyOver_200,
    E_Latency_Successive_200,
    E_Latency_TooManySuccessiveOver_200,
    E_CRC_Failure
    
} E_ERROR_T;

@interface DaysiWatch : NSObject
@property  (readonly ) E_ERROR_T myErrorCode;
@property CBPeripheral *blePeripheral;
@property NSString *deviceId;
@property bool isDevicePresent;
@property NSDate *lastSeen;

-(E_ERROR_T) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;

-(NSString *)  GetDebugString;
-(NSString *)  GetDebugShortString;
-(DAYSI_DATA_T *) GetDaysiData;
-(DAYSI_STATUS_T *)GetDaysiStatus;
- (int)GetBatteryVoltageInMilliVolts;



@end
