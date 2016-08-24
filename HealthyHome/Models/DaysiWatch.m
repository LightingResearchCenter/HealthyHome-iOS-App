//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Pressure


#import "DaysiWatch.h"
#include "crc16.h"
#import "GlobalConfig.h"


@implementation DaysiWatch

DAYSI_DATA_T m_DaysiData;
DAYSI_STATUS_T m_DaysiStatus;

//const int kTIME_STAMP_LOG_BUFFER_SIZE = 4;               // Size of buffer that holds the time stamp data
//const int kTIME_SUCCESSIVE_READINGS_TOO_LONG_MS = 200;
//const int kTOO_MANY_SUCCESSIVE_DELAYED_READINGS = 100;
//const int kTIME_STAMP_LONG_INTERMITTENT_MS = 1000;
//const int kTIME_STAMP_TOO_LONG_MS = 2000;
//const int kSYRINGE_TIMESTAMP_SCALER = 32768;         // Syringe Counter ticks at 32.768 KHz
//const int kTIME_STAMP_SYRINGE_MAX = 16777215;        // Syringe implements a 24 Bit counter

const char kCOMMAND_WATCH_TO_PHONE_LIGHT_DATA = 0x8a;
const char kCOMMAND_PHONE_TO_WATCH_STATUS = 0x8b;

bool oldPressureTimerStatusBit;
bool PressureTimerStatusBit;




NSMutableArray *timeStampFromSyringeArray;

-(id)init
{
    if (timeStampFromSyringeArray == nil)
    {
        timeStampFromSyringeArray = [[NSMutableArray alloc]init];
    }
    oldPressureTimerStatusBit = 0;
    self.isDevicePresent = 0;
    self.blePeripheral = nil;
    
    return self;
}

- (NSString *)  GetCommandValueAsString
{
    return [NSString stringWithFormat:@"%d",  m_DaysiData.command];
}

- (NSString *)  GetDebugString
{
    
    return [NSString stringWithFormat:@"Version: %d Command: %02X  EEpromAddress: %02x Red: %02X Green: %02X Blue: %02X Activity: %02X Battery: %d", m_DaysiData.version, m_DaysiData.command, m_DaysiData.eepromAddress, m_DaysiData.redValue, m_DaysiData.greenValue, m_DaysiData.blueValue, m_DaysiData.activityValue, m_DaysiData.batteryVoltage];
}

- (NSString *)  GetDebugShortString
{
    
    return [NSString stringWithFormat:@"R:%04X G:%04X B:%04X A:%04X",    m_DaysiData.redValue, m_DaysiData.greenValue, m_DaysiData.blueValue, m_DaysiData.activityValue];
}

- (DAYSI_DATA_T *)GetDaysiData
{
    return &m_DaysiData;
}

- (DAYSI_STATUS_T *)GetDaysiStatus
{
    return &m_DaysiStatus;
}

- (int)GetBatteryVoltageInMilliVolts
{
    return m_DaysiData.batteryVoltage;
}

- (void) UpdateStatusFromCommand:(DAYSI_DATA_T *)commandData
{
    
    m_DaysiStatus.preambleLo = 0x55;
    m_DaysiStatus.preambleHi = 0xaa;

    m_DaysiStatus.command = kCOMMAND_PHONE_TO_WATCH_STATUS;
    
    
    m_DaysiStatus.eepromAddress = commandData->eepromAddress;
    
    m_DaysiStatus.controlFlags = 0xCC;
    
    m_DaysiStatus.logIntervalInSeconds = 78;
    
    m_DaysiStatus.length = 6;
    
    // Get a timeStamp
    time_t  unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    m_DaysiStatus.time = (uint32_t)unixTime;
    
    m_DaysiStatus.crc = 0xa7;
    
}

-(E_ERROR_T) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    //Given a pointer to octets - parse and fill up the pressure data.
    //For compatibilty the pressure packet has a version field.
    E_ERROR_T errorCode = 0;
    m_DaysiData.preambleLo = pBytes[0];
    m_DaysiData.preambleHi = pBytes[1];
    m_DaysiData.command = pBytes[2];
    m_DaysiData.version = pBytes[3];
    m_DaysiData.length = pBytes[4];
    
    
    
    if (m_DaysiData.command == 0x8A)
    {
        
        switch (m_DaysiData.version)
        {
                
            case 0:
                m_DaysiData.eepromAddress  =  (pBytes[5]);
                m_DaysiData.eepromAddress |= (pBytes[6] << 8);
                m_DaysiData.eepromAddress |= (pBytes[7] << 16 );
                m_DaysiData.eepromAddress |= (pBytes[8] << 24);
                
                
                m_DaysiData.redValue  =  (pBytes[9] << 8);
                m_DaysiData.redValue |= (pBytes[10] << 0);
                
                m_DaysiData.greenValue  =  (pBytes[11] << 8);
                m_DaysiData.greenValue |= (pBytes[12] << 0);
                
                m_DaysiData.blueValue   =  (pBytes[13] << 8);
                m_DaysiData.blueValue |= (pBytes[14] << 0);
                
                m_DaysiData.activityValue   =  (pBytes[15] << 8);
                m_DaysiData.activityValue |= (pBytes[16] << 0);
                
                m_DaysiData.batteryVoltage  =  (pBytes[18] << 8);
                m_DaysiData.batteryVoltage |= (pBytes[17] << 0);
                
                //Prepare a status packet for the DaysiWatch
                [self UpdateStatusFromCommand:&m_DaysiData];
                
                break;
                

            default:
              //  [NSException raise:@"Invalid Version for DaysiData" format:@"Version %d is invalid", m_DaysiData.version];
                break;
                
        }
        
    }
    else
    {
        NSLog(@"Invalid Command");
        //[NSException raise:@"Invalid Comamd for DaysiWatch" format:@"Command %02x is invalid", m_DaysiData.command];
        
    }
    
    return E_No_Error;
    
    
}




-(void) Reset
{
    m_DaysiData.command  = 0;

    
}








@end
