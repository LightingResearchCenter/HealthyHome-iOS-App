
#import "DaysiGoggle.h"
#import "crc16.h"
#import "GlobalConfig.h"
#import "CustomCategories.h"


@implementation DaysiGoggle
@synthesize blePeripheral;
@synthesize myCBCharacteristic_DaysiGoggleCommand;
@synthesize myCBCharacteristic_DaysiGoggleBattery;
@synthesize myCBCharacteristic_DaysiGoggleData;

DAYSI_GOGGLE_DATA_T m_DaysiGoggleData;
DAYSI_GOGGLE_COMMAND_T m_PhoneToGoggleCommand;

const int kTIME_STAMP_LOG_BUFFER_SIZE = 4;               // Size of buffer that holds the time stamp data
//const int kTIME_SUCCESSIVE_READINGS_TOO_LONG_MS = 200;
//const int kTOO_MANY_SUCCESSIVE_DELAYED_READINGS = 100;
//const int kTIME_STAMP_LONG_INTERMITTENT_MS = 1000;
//const int kTIME_STAMP_TOO_LONG_MS = 2000;
//const int kSYRINGE_TIMESTAMP_SCALER = 32768;         // Syringe Counter ticks at 32.768 KHz
//const int kTIME_STAMP_SYRINGE_MAX = 16777215;        // Syringe implements a 24 Bit counter

const char kCOMMAND_GOGGLE_TO_PHONE_DATA = 0x9a;
const char kCOMMAND_PHONE_TO_GOGGLE = 0x9b;

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
    return [NSString stringWithFormat:@"%d",  m_DaysiGoggleData.command];
}

- (NSString *)  GetDebugString
{
    return @"Daysi Goggle Debug";
}

- (NSString *)  GetDebugShortString
{
    
    return [NSString stringWithFormat:@"R:%04X G:%04X B:%04X A:%04X",    m_DaysiGoggleData.redValue, m_DaysiGoggleData.greenValue, m_DaysiGoggleData.blueValue, m_DaysiGoggleData.activityValue];
}

- (DAYSI_GOGGLE_DATA_T *)GetDaysiGoggleData
{
    return &m_DaysiGoggleData;
}

- (DAYSI_GOGGLE_COMMAND_T *)GetDaysiGoggleStatus
{
    return &m_PhoneToGoggleCommand;
}

- (int)GetBatteryVoltageInMilliVolts
{
    return m_DaysiGoggleData.batteryVoltage;
}

- (void) UpdateStatusFromCommand:(DAYSI_GOGGLE_DATA_T *)commandData
{
    
    m_PhoneToGoggleCommand.preambleLo = 0x55;
    m_PhoneToGoggleCommand.preambleHi = 0xaa;

    m_PhoneToGoggleCommand.command = kCOMMAND_PHONE_TO_GOGGLE;
    

    
    m_PhoneToGoggleCommand.crc = 0xa7;
    
}

-(E_GOGGLE_ERROR_T) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    //Given a pointer to octets - parse and fill up the pressure data.
    //For compatibilty the pressure packet has a version field.
    E_GOGGLE_ERROR_T errorCode = 0;
    
    m_DaysiGoggleData.preambleLo = pBytes[0];
    m_DaysiGoggleData.preambleHi = pBytes[1];
    m_DaysiGoggleData.command = pBytes[2];
    m_DaysiGoggleData.version = pBytes[3];
    m_DaysiGoggleData.length = pBytes[4];
    
    
    
    if (m_DaysiGoggleData.command == 0x8A)
    {
        
        switch (m_DaysiGoggleData.version)
        {
                
            case 0:
                m_DaysiGoggleData.eepromAddress  =  (pBytes[5]);
                m_DaysiGoggleData.eepromAddress |= (pBytes[6] << 8);
                m_DaysiGoggleData.eepromAddress |= (pBytes[7] << 16 );
                m_DaysiGoggleData.eepromAddress |= (pBytes[8] << 24);
                
                
                m_DaysiGoggleData.redValue  =  (pBytes[9] << 8);
                m_DaysiGoggleData.redValue |= (pBytes[10] << 0);
                
                m_DaysiGoggleData.greenValue  =  (pBytes[11] << 8);
                m_DaysiGoggleData.greenValue |= (pBytes[12] << 0);
                
                m_DaysiGoggleData.blueValue   =  (pBytes[13] << 8);
                m_DaysiGoggleData.blueValue |= (pBytes[14] << 0);
                
                m_DaysiGoggleData.activityValue   =  (pBytes[15] << 8);
                m_DaysiGoggleData.activityValue |= (pBytes[16] << 0);
                
                m_DaysiGoggleData.batteryVoltage  =  (pBytes[18] << 8);
                m_DaysiGoggleData.batteryVoltage |= (pBytes[17] << 0);
                

                
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
    
    return E_Goggle_No_Error;
    
    
}




-(void) Reset
{
    m_DaysiGoggleData.command  = 0;

    
}

-(void) WriteCommand
{
    
    //Todo - Authenticate using a signature that is a hash of the MACID
    //Create a Command Packet
    
    NSData *data = [NSData dataWithBytes: (void *)[self GetDaysiGoggleStatus]  length: sizeof(DAYSI_GOGGLE_COMMAND_T)];
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiGoggleCommand UUID] representativeString]);
    
    NSLog(@"Data Written %@", [data hexadecimalString]);
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiGoggleCommand type:CBCharacteristicWriteWithResponse];
    
}

-(void) SetGoggleState:(bool)state
{
    
    m_PhoneToGoggleCommand.preambleLo = 0x55;
    m_PhoneToGoggleCommand.preambleHi = 0xaa;
    
    m_PhoneToGoggleCommand.command = kCOMMAND_PHONE_TO_GOGGLE;
    
    
    m_PhoneToGoggleCommand.lightState = state;
    m_PhoneToGoggleCommand.shutterState = state;
    
    m_PhoneToGoggleCommand.length = 6;
    m_PhoneToGoggleCommand.crc = 0xa7;
    
    NSData *data = [NSData dataWithBytes: (void *)[self GetDaysiGoggleStatus]  length: sizeof(DAYSI_GOGGLE_COMMAND_T)];
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiGoggleCommand UUID] representativeString]);
    
    NSLog(@"Data Written %@", [data hexadecimalString]);
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiGoggleCommand type:CBCharacteristicWriteWithResponse];
}




@end
