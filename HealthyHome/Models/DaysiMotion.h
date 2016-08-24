

#import <Foundation/Foundation.h>
#include <CoreBluetooth/CoreBluetooth.h>

// Note - This typedef must match the DaysiMotion Firmware
// Note - Keep the data packed on a byte boundary

#pragma pack (1)
static const uint8_t kDEVICE_TO_PHONE_MOTION_DATA = 0x8b;
static const char kPHONE_TO_DAYSIMOTION_INITIALIZE = 0x90;
static const char kPHONE_TO_DAYSIMOTION_RESET_ERROR = 0x9e;

#pragma pack (1)

typedef struct DAYSI_MOTION_COMMAND
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    
    // -- Actual Data Payload
    char buffer[16];
    
} DAYSI_MOTION_COMMAND_T;

#pragma pack (8)
typedef struct DAYSI_MOTION_DATA
{
    uint8_t  preambleLo;
    uint8_t  preambleHi;
    uint8_t     command;
    uint8_t     version;


    uint16_t    remainingCount;
    uint16_t    accX;
    uint16_t    accY;
    uint16_t    accZ;
    uint16_t    activityIndex;
    uint16_t    activityCount;
    
    uint8_t    batteryVoltageAsPercentage;
    uint8_t    bootCount;
    uint16_t   deviceStatusCode;
    
} DAYSI_MOTION_DATA_T;
#pragma pack (8)


#pragma pack (1)
typedef struct DAYSI_MOTION_STATUS
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
} DAYSI_MOTION_STATUS_T;


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

@interface DaysiMotion : NSObject
@property  (readonly ) E_ERROR_T myErrorCode;

@property NSString *deviceId;
@property bool isDevicePresent;
@property NSDate *lastSeen;
@property NSString *strFWVersion;
@property BOOL forceTimeSync;

@property CBPeripheral *blePeripheral;
@property CBCharacteristic *myCBCharacteristic_DaysiMotionData;
@property CBCharacteristic *myCBCharacteristic_DaysiMotionBattery;
@property CBCharacteristic *myCBCharacteristic_DaysiMotionCommand;

@property CBCharacteristic *myCBCharacteristic_DIS_FirmwareVersion;
@property CBCharacteristic *myCBCharacteristic_DIS_SerialNumber;
@property CBCharacteristic *myCBCharacteristic_DIS_HardwareVersion;
@property CBCharacteristic *myCBCharacteristic_DIS_ModelNumber;


-(uint8_t) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;

-(NSString *)  GetDebugString;
-(NSString *)  GetDebugShortString;
-(DAYSI_MOTION_DATA_T *) GetDaysiData;

- (int)GetBatteryVoltageInMilliVolts;
- (float)GetActivityIndex;
- (float)GetActivityCount;
-(void)  RescaleActivityMetrics;
-(void) WriteInitializeCommand;

-(int) GetBootCount;
-(int) GetQueueCount;

@end
