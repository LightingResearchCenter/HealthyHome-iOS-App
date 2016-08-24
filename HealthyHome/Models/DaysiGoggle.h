

#import <Foundation/Foundation.h>
#include <CoreBluetooth/CoreBluetooth.h>

// Note - This typedef must match the Raptor Syringe Firmware
// Note - Keep the data packed on a byte boundary

#pragma pack (1)
typedef struct DAYSI_GOGGLE_DATA
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
} DAYSI_GOGGLE_DATA_T;
#pragma pack (8)


#pragma pack (1)
typedef struct DAYSI_GOGGLE_COMMAND
{
    // -- Header Stuff
    uint8_t     preambleLo;
    uint8_t     preambleHi;
    uint8_t     command;
    uint8_t     version;
    uint8_t     length;
    
    // -- Actual Data Payload
    uint8_t     lightState;
    uint8_t     shutterState;
    uint16_t    lightTimeInSecs;
    uint16_t    shutterTimeInSecs;
    
    uint8_t unused1;
    uint8_t unused2;
    uint8_t unused3;
    uint8_t unused4;
    uint8_t unused5;
    uint8_t unused6;
    uint8_t unused7;
    uint8_t unused8;

    
    uint8_t     crc;
} DAYSI_GOGGLE_COMMAND_T;


#pragma pack (8)
typedef enum
{
    E_Goggle_No_Error,
    E_Gogggle_CRC_Failure
    
} E_GOGGLE_ERROR_T;

@interface DaysiGoggle : NSObject
@property  (readonly ) E_GOGGLE_ERROR_T myErrorCode;

@property NSString *deviceId;
@property bool isDevicePresent;
@property NSDate *lastSeen;

@property CBPeripheral *blePeripheral;
@property CBCharacteristic *myCBCharacteristic_DaysiGoggleData;
@property CBCharacteristic *myCBCharacteristic_DaysiGoggleBattery;
@property CBCharacteristic *myCBCharacteristic_DaysiGoggleCommand;

-(E_GOGGLE_ERROR_T) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;

-(NSString *)  GetDebugString;
-(NSString *)  GetDebugShortString;
-(DAYSI_GOGGLE_DATA_T *) GetDaysiGoggleData;
-(DAYSI_GOGGLE_COMMAND_T *)GetDaysiGoggleStatus;

-(void) SetGoggleState:(bool)state;

- (int)GetBatteryVoltageInMilliVolts;

-(void) WriteCommand;

@end
