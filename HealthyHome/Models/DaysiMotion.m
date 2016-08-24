
#import "DaysiMotion.h"
#include "crc16.h"
#import "GlobalConfig.h"
#import "CustomCategories.h"
#include "ActivityMetricScaling.h"


@implementation DaysiMotion
@synthesize blePeripheral;
@synthesize myCBCharacteristic_DaysiMotionCommand;
@synthesize myCBCharacteristic_DaysiMotionBattery;
@synthesize myCBCharacteristic_DaysiMotionData;

@synthesize myCBCharacteristic_DIS_FirmwareVersion;
@synthesize myCBCharacteristic_DIS_SerialNumber;
@synthesize myCBCharacteristic_DIS_HardwareVersion;
@synthesize myCBCharacteristic_DIS_ModelNumber;

DAYSI_MOTION_DATA_T m_DaysiMotionData;
DAYSI_MOTION_STATUS_T m_DaysiStatus;

const int kTIME_STAMP_LOG_BUFFER_SIZE = 4;               // Size of buffer that holds the time stamp data
float activityIndexFloat, activityCountFloat;

NSMutableArray *timeStampFromDaysiMotionArray;

-(id)init
{
    if (timeStampFromDaysiMotionArray == nil)
    {
        timeStampFromDaysiMotionArray = [[NSMutableArray alloc]init];
    }

    self.isDevicePresent = 0;
    self.blePeripheral = nil;
    
    return self;
}

- (NSString *)  GetCommandValueAsString
{
    return [NSString stringWithFormat:@"%d",  m_DaysiMotionData.command];
}

- (NSString *)  GetDebugString
{

    
    return [NSString stringWithFormat:@"BC: %d Command: %02X Tail: %d Head: %d AI(Raw): %d ActivityIndex: %3.2f ActivityCount: %3.2f Battery: %d DeviceStatusCode %d", m_DaysiMotionData.bootCount, m_DaysiMotionData.command, m_DaysiMotionData.remainingCount, m_DaysiMotionData.deviceStatusCode, m_DaysiMotionData.activityIndex, activityIndexFloat, activityCountFloat, m_DaysiMotionData.batteryVoltageAsPercentage ];
}

- (NSString *)  GetDebugShortString
{
    
  //  return [NSString stringWithFormat:@"AI:%3.2f AC:%3.2f X:%04X Y:%04X Z:%04X",    activityIndexFloat, activityCountFloat, m_DaysiMotionData.accX, m_DaysiMotionData.accY, m_DaysiMotionData.accZ];
    
        return [NSString stringWithFormat:@"BC:%02X CNT:%0d  AI:%2.3f AC:%2.3f ", m_DaysiMotionData.bootCount,  m_DaysiMotionData.remainingCount,  activityIndexFloat, activityCountFloat];
}

- (DAYSI_MOTION_DATA_T *)GetDaysiData
{
    return &m_DaysiMotionData;
}



- (int)GetBatteryVoltageInMilliVolts
{
    return (m_DaysiMotionData.batteryVoltageAsPercentage * 3000)/100;
}

- (void) UpdateStatusFromCommand_Dep:(DAYSI_MOTION_DATA_T *)commandData
{
    
    m_DaysiStatus.preambleLo = 0x55;
    m_DaysiStatus.preambleHi = 0xaa;

    m_DaysiStatus.command = kDEVICE_TO_PHONE_MOTION_DATA;
    
    
    m_DaysiStatus.eepromAddress = commandData->remainingCount;
    
    m_DaysiStatus.controlFlags = 0xCC;
    
    m_DaysiStatus.logIntervalInSeconds = 78;
    
    m_DaysiStatus.length = 6;
    
    // Get a timeStamp
    time_t  unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    m_DaysiStatus.time = (uint32_t)unixTime;
    
    m_DaysiStatus.crc = 0xa7;
    
}

-(void)  RescaleActivityMetrics
{
    
    //Rescale the Activity Index & Counts
    Accelerometer_MetricScaling(m_DaysiMotionData.activityIndex, m_DaysiMotionData.activityCount, &activityIndexFloat, &activityCountFloat);

}

-(uint8_t) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    //Given a pointer to octets - parse and fill up the Motion data.
    uint8_t command = pBytes[2];
    
    if (command == kDEVICE_TO_PHONE_MOTION_DATA)
    {
        
#ifdef DEBUG_VERBOSE
        NSLog(@"Motion Data Received");
#endif
        m_DaysiMotionData.preambleLo = pBytes[0];
        m_DaysiMotionData.preambleHi = pBytes[1];
        m_DaysiMotionData.command = pBytes[2];
        m_DaysiMotionData.version = pBytes[3];
        
                
        m_DaysiMotionData.remainingCount  =  (pBytes[4] << 0);
        m_DaysiMotionData.remainingCount |= (pBytes[5] << 8);
        
        m_DaysiMotionData.activityIndex   =  (pBytes[6] << 0);
        m_DaysiMotionData.activityIndex |= (pBytes[7] << 8);
        
        m_DaysiMotionData.activityCount   =  (pBytes[8] << 0);
        m_DaysiMotionData.activityCount |= (pBytes[9] << 8);
        
        [self RescaleActivityMetrics];
        switch (m_DaysiMotionData.version)
        {
            case (0):
                m_DaysiMotionData.batteryVoltageAsPercentage  =  (pBytes[16]);
                m_DaysiMotionData.bootCount  =  (pBytes[18]);
                break;
                
            case (1):
                m_DaysiMotionData.batteryVoltageAsPercentage  =  (pBytes[16]);
                m_DaysiMotionData.bootCount  =  (pBytes[17]);
                
                m_DaysiMotionData.deviceStatusCode =  (pBytes[18] << 0);
                m_DaysiMotionData.deviceStatusCode |=  (pBytes[19] << 8);
                
                break;
                
                
        };
        
        

        
    }
    else
    {
        NSLog(@"Invalid DaysiMotion Command %02x", command);
        //[NSException raise:@"Invalid Comamd for DaysiWatch" format:@"Command %02x is invalid", m_DaysiData.command];
        
    }
    
    return command;
    
    
}




-(void) Reset
{
    m_DaysiMotionData.command  = 0;

    
}


- (float)GetActivityIndex
{
    
    return activityIndexFloat;
}

- (float)GetActivityCount
{
    
    return activityCountFloat;
}

-(void) WriteInitializeCommand
{
    DAYSI_MOTION_COMMAND_T myCommand;
    myCommand.preambleLo = 0x55;
    myCommand.preambleHi = 0xaa;
    myCommand.command = kPHONE_TO_DAYSIMOTION_INITIALIZE;
    myCommand.version = 0;
    
    NSData *data = [NSData dataWithBytes: (void *)&myCommand length: sizeof(DAYSI_MOTION_COMMAND_T)];
    
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiMotionCommand UUID] representativeString]);
    NSLog(@"Initialize Data Written %@ length %ld", [data hexadecimalString], sizeof(DAYSI_MOTION_COMMAND_T));
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiMotionCommand type:CBCharacteristicWriteWithResponse];
}


-(void) WriteResetErrorData:(time_t)time
{
    
    
    DAYSI_MOTION_COMMAND_T myTimeCommand;
    myTimeCommand.preambleLo = 0x55;
    myTimeCommand.preambleHi = 0xaa;
    
    myTimeCommand.command = kPHONE_TO_DAYSIMOTION_RESET_ERROR;
    
    myTimeCommand.version = 0;
    NSData *data = [NSData dataWithBytes: (void *)&myTimeCommand  length: sizeof(DAYSI_MOTION_COMMAND_T)];
    NSLog(@"Writing Light Reset Error to characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiMotionCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %lu", [data hexadecimalString], sizeof(DAYSI_MOTION_COMMAND_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiMotionCommand type:CBCharacteristicWriteWithResponse];
    
    
}



-(int) GetBootCount
{
    
    return m_DaysiMotionData.bootCount;
}
-(int) GetQueueCount
{
    
    return m_DaysiMotionData.remainingCount;
}

@end
