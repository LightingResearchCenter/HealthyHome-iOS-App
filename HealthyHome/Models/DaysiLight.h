

#import <Foundation/Foundation.h>
#include <CoreBluetooth/CoreBluetooth.h>

// Note - This typedef must match the  Firmware
// Note - Keep the data packed on a byte boundary

#pragma pack (1)
static const uint8_t kDEVICE_TO_PHONE_LIGHT_DATA = 0x8a;

static const uint8_t kDEVICE_TO_PHONE_CALIBRATION_DATA = 0x8c;


static const char kPHONE_TO_DAYSILIGHT_INITIALIZE = 0x90;
static const char kPHONE_TO_DAYSILIGHT_SET_CALIBRATION = 0x9c;
static const char kPHONE_TO_DAYSILIGHT_SET_TIME = 0x9d;
static const char kPHONE_TO_DAYSILIGHT_RESET_ERROR = 0x9e;

#pragma pack (1)
typedef struct DAYSI_LIGHT_COMMAND
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    
    // -- Actual Data Payload
    char buffer[16];
    
} DAYSI_LIGHT_COMMAND_T;

#pragma pack (8)
typedef struct DAYSI_LIGHT_DATA
{
    uint8_t  preambleLo;
    uint8_t  preambleHi;
    uint8_t     command;
    uint8_t     version;
    
    uint16_t    address;
    uint16_t    redValue;
    uint16_t    greenValue;
    uint16_t    blueValue;
    uint16_t    clearValue;
    uint16_t    temperature;
    
    uint8_t    batteryVoltageAsPercentage;

    uint8_t     bootCount;
    uint16_t    deviceStatusCode;
    
} DAYSI_LIGHT_DATA_T;
#pragma pack (8)





#pragma pack (1)
typedef struct DAYSI_LIGHT_CALIBRATION_COMMAND
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    
    // -- Actual Data Payload
    float calRed;
    float calGreen;
    float calBlue;
    float calClear;
} DAYSI_LIGHT_CALIBRATION_DATA_T;
#pragma pack (8)

#pragma pack (1)
typedef struct DAYSI_LIGHT_TIME_COMMAND
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    
    // -- Actual Data Payload
    time_t unixTime;

} DAYSI_LIGHT_TIME_DATA_T;
#pragma pack (8)



typedef enum
{
    E_DaysiLight_No_Error,
    E_Gogggle_CRC_Failure
    
} E_DAYSILIGHT_ERROR_T;

@interface DaysiLight : NSObject
@property  (readonly ) E_DAYSILIGHT_ERROR_T myErrorCode;

@property NSString *deviceId;
@property bool isDevicePresent;
@property NSDate *lastSeen;
@property NSString *strFWVersion;
@property BOOL forceTimeSync;

@property CBPeripheral *blePeripheral;
@property CBCharacteristic *myCBCharacteristic_DaysiLightData;
@property CBCharacteristic *myCBCharacteristic_DaysiLightBattery;
@property CBCharacteristic *myCBCharacteristic_DaysiLightCommand;

@property CBCharacteristic *myCBCharacteristic_DIS_FirmwareVersion;
@property CBCharacteristic *myCBCharacteristic_DIS_SerialNumber;
@property CBCharacteristic *myCBCharacteristic_DIS_HardwareVersion;
@property CBCharacteristic *myCBCharacteristic_DIS_ModelNumber;



-(uint8_t) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;

-(NSString *)  GetDebugString;
-(NSString *)  GetDebugShortString;
-(DAYSI_LIGHT_DATA_T *) GetDaysiLightData;
-(DAYSI_LIGHT_CALIBRATION_DATA_T *)GetDaysiCalibrationData;



- (int)GetBatteryVoltageInMilliVolts;

-(void) WriteInitializeCommand;
-(void) WriteCalibrationDataRed:(float)RedValue
                          Green:(float)greenValue
                           Blue:(float)blueValue
                          Clear:(float)clearValue;

-(void) StopCalibration;
-(void) StartCalibration;
-(bool) IsPaired;
-(int) GetBootCount;
-(int) GetQueueCount;

- (float)calRed;
- (float)calGreen;
- (float)calBlue;
- (float)calClear;


@end
