
#import "DaysiLight.h"
#import "crc16.h"
#import "GlobalConfig.h"
#import "CustomCategories.h"


@implementation DaysiLight
@synthesize blePeripheral;
@synthesize myCBCharacteristic_DaysiLightCommand;
@synthesize myCBCharacteristic_DaysiLightBattery;
@synthesize myCBCharacteristic_DaysiLightData;

@synthesize myCBCharacteristic_DIS_FirmwareVersion;
@synthesize myCBCharacteristic_DIS_SerialNumber;
@synthesize myCBCharacteristic_DIS_HardwareVersion;
@synthesize myCBCharacteristic_DIS_ModelNumber;


DAYSI_LIGHT_DATA_T m_DaysiLightData;
DAYSI_LIGHT_CALIBRATION_DATA_T m_DaysiCalibrationData;

DAYSI_LIGHT_COMMAND_T m_PhoneToDaysiLightCommand;

//static const int kTIME_STAMP_LOG_BUFFER_SIZE = 4;               // Size of buffer that holds the time stamp data



NSMutableArray *timeStampFromDaysiLightArray;

-(id)init
{
    if (timeStampFromDaysiLightArray == nil)
    {
        timeStampFromDaysiLightArray = [[NSMutableArray alloc]init];
    }
    
    self.isDevicePresent = 0;
    self.blePeripheral = nil;
    
    return self;
}


-(NSString *)GetDeviceVersionString
{
    NSString *myString;
    
    NSLog(@"Serial Numer: %@", myCBCharacteristic_DIS_SerialNumber.value);
    if (self.isDevicePresent == false)
    {
        myString = @"DaysiLight: Disconnected \r\n";
        
    }
    else
    {
        NSString *serialNumber =[[NSString alloc] initWithData:myCBCharacteristic_DIS_SerialNumber.value
                                                      encoding:NSUTF8StringEncoding] ;
        
        NSString *firmwareVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_FirmwareVersion.value
                                                         encoding:NSUTF8StringEncoding];
        
        NSString *hardwareVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_HardwareVersion.value
                                                         encoding:NSUTF8StringEncoding];
        
        NSString *modelVersion =[[NSString alloc] initWithData:myCBCharacteristic_DIS_ModelNumber.value
                                                      encoding:NSUTF8StringEncoding];
        
        
        
        myString = [NSString stringWithFormat:
                    @"DaysiLight:\r\n"
                    " F/W Version: %@\r\n"
                    " Serial Number: %@\r\n "
                    " H/W Version: %@\r\n "
                    " Model Version: %@\r\n ", firmwareVersion, serialNumber, hardwareVersion, modelVersion];
        
        
        
    }
    
    return myString;
}

- (NSString *)  GetCommandValueAsString
{
    return [NSString stringWithFormat:@"%d",  m_DaysiLightData.command];
}

- (NSString *)  GetDebugString
{
    return @"Daysi  Debug";
}

- (NSString *)  GetDebugShortString
{
    
    return [NSString stringWithFormat:@"BC:%02X CNT:%d R:%04X G:%04X B:%04X C:%04X",  m_DaysiLightData.bootCount, m_DaysiLightData.address, m_DaysiLightData.redValue, m_DaysiLightData.greenValue, m_DaysiLightData.blueValue, m_DaysiLightData.clearValue];
}

- (DAYSI_LIGHT_DATA_T *)GetDaysiLightData
{
    return &m_DaysiLightData;
}

- (DAYSI_LIGHT_CALIBRATION_DATA_T *)GetDaysiCalibrationData
{
    return &m_DaysiCalibrationData;
}

- (int)GetBatteryVoltageInMilliVolts
{
    
    return (m_DaysiLightData.batteryVoltageAsPercentage * 3000)/100;
}

- (float)calRed
{
    
    return m_DaysiCalibrationData.calRed;
}

- (float)calGreen
{
    
    return m_DaysiCalibrationData.calGreen;
}

- (float)calBlue
{
    
    return m_DaysiCalibrationData.calBlue;
}
- (float)calClear
{
    
    return m_DaysiCalibrationData.calClear;
}

-(uint8_t) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    //Given a pointer to octets - parse and fill up the  data.

    //Todo - Verify that the header is correct
    
    uint8_t command = pBytes[2];
    
    if (command == kDEVICE_TO_PHONE_LIGHT_DATA)
    {
        
        NSLog(@"Light Data Received");
        m_DaysiLightData.preambleLo = pBytes[0];
        m_DaysiLightData.preambleHi = pBytes[1];
        m_DaysiLightData.command = pBytes[2];
        m_DaysiLightData.version = pBytes[3];
        
        switch (m_DaysiLightData.version)
        {
            case (0):
                break;
                
            case (1):
                break;
                
                
        };
        m_DaysiLightData.address  =  (pBytes[4] << 0);
        m_DaysiLightData.address |= (pBytes[5] << 8);
        
        m_DaysiLightData.redValue  =  (pBytes[6] << 0);
        m_DaysiLightData.redValue |= (pBytes[7] << 8);
        
        m_DaysiLightData.greenValue  =  (pBytes[8] << 0);
        m_DaysiLightData.greenValue |= (pBytes[9] << 8);
        
        m_DaysiLightData.blueValue   =  (pBytes[10] << 0);
        m_DaysiLightData.blueValue |= (pBytes[11] << 8);
        
        m_DaysiLightData.clearValue   =  (pBytes[12] << 0);
        m_DaysiLightData.clearValue |= (pBytes[13] << 8);
        
        m_DaysiLightData.temperature   =  (pBytes[14] << 0);
        m_DaysiLightData.temperature |= (pBytes[15] << 8);
        
        switch (m_DaysiLightData.version)
        {
            case (0):
                m_DaysiLightData.batteryVoltageAsPercentage  =  (pBytes[16]);
                m_DaysiLightData.bootCount  =  (pBytes[18]);
                break;
                
            case (1):
                m_DaysiLightData.batteryVoltageAsPercentage  =  (pBytes[16]);
                m_DaysiLightData.bootCount  =  (pBytes[17]);
                
                m_DaysiLightData.deviceStatusCode =  (pBytes[18] << 0);
                m_DaysiLightData.deviceStatusCode =  (pBytes[19] << 8);
                
                break;
                
                
        };

        

        
        NSLog(@"Light Data Received.  BootCount:%d, Count:%d Red:%d  Green:%d  Blue:%d  Clear:%d",m_DaysiLightData.bootCount, m_DaysiLightData.address, m_DaysiLightData.redValue, m_DaysiLightData.greenValue, m_DaysiLightData.blueValue, m_DaysiLightData.clearValue );

        
    }
    
    else if (command == kDEVICE_TO_PHONE_CALIBRATION_DATA)
    {

        //Todo - Verify that the header is correct
        m_DaysiCalibrationData.preambleLo = pBytes[0];
        m_DaysiCalibrationData.preambleHi = pBytes[1];
        m_DaysiCalibrationData.command = pBytes[2];
        m_DaysiCalibrationData.version = pBytes[3];
        
        int offset = 0;
        memcpy((void *)&m_DaysiCalibrationData.calRed, &pBytes[4]+offset, sizeof(m_DaysiCalibrationData.calRed));
        offset+= sizeof(m_DaysiCalibrationData.calRed);
        
        memcpy((void *)&m_DaysiCalibrationData.calGreen, &pBytes[4]+offset, sizeof(m_DaysiCalibrationData.calGreen));
        offset+= sizeof(m_DaysiCalibrationData.calGreen);
        
        memcpy((void *)&m_DaysiCalibrationData.calBlue, &pBytes[4]+offset, sizeof(m_DaysiCalibrationData.calBlue));
        offset+= sizeof(m_DaysiCalibrationData.calBlue);
        
        memcpy((void*)&m_DaysiCalibrationData.calClear, &pBytes[4]+offset, sizeof(m_DaysiCalibrationData.calClear));
        offset+= sizeof(m_DaysiCalibrationData.calClear);
        NSLog(@"Calibration Data Received.  Red:%3.3f  Green:%3.3f  Blue:%3.3f  Clear:%3.3f",m_DaysiCalibrationData.calRed, m_DaysiCalibrationData.calGreen, m_DaysiCalibrationData.calBlue, m_DaysiCalibrationData.calClear );
        
    }
    
    else
    {
        NSLog(@"Invalid Command");
        //[NSException raise:@"Invalid Comamd for DaysiWatch" format:@"Command %02x is invalid", m_DaysiData.command];
        
    }
    
    return command;
    
    
}




-(void) Reset
{
    m_DaysiLightData.command  = 0;
    
    
}

-(void) StartCalibration
{
    DAYSI_LIGHT_CALIBRATION_DATA_T myCalCommand;
    
    myCalCommand.preambleLo = 0x55;
    myCalCommand.preambleHi = 0xaa;
    
    myCalCommand.command = kPHONE_TO_DAYSILIGHT_SET_CALIBRATION;
    
    myCalCommand.version = 1;
    
    myCalCommand.calRed = 1;
    myCalCommand.calGreen = 1;
    myCalCommand.calBlue = 1;
    myCalCommand.calClear= 1;
    
    
    NSData *data = [NSData dataWithBytes: (void *)&myCalCommand  length: sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T)];
    NSLog(@"Writing Calibration Start Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %ld", [data hexadecimalString], sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];

}

-(void) StopCalibration
{
    DAYSI_LIGHT_CALIBRATION_DATA_T myCalCommand;
    
    myCalCommand.preambleLo = 0x55;
    myCalCommand.preambleHi = 0xaa;
    
    myCalCommand.command = kPHONE_TO_DAYSILIGHT_SET_CALIBRATION;
    
    myCalCommand.version = 0;
    
    myCalCommand.calRed = 1;
    myCalCommand.calGreen = 1;
    myCalCommand.calBlue = 1;
    myCalCommand.calClear= 1;
    
    
    NSData *data = [NSData dataWithBytes: (void *)&myCalCommand  length: sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T)];
    NSLog(@"Writing Calibration Stop Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %ld", [data hexadecimalString], sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];
    
}

-(void) WriteCalibrationDataRed:(float)RedValue
                          Green:(float)greenValue
                           Blue:(float)blueValue
                          Clear:(float)clearValue
{
    
    DAYSI_LIGHT_CALIBRATION_DATA_T myCalCommand;
    
    myCalCommand.preambleLo = 0x55;
    myCalCommand.preambleHi = 0xaa;
    
    myCalCommand.command = kPHONE_TO_DAYSILIGHT_SET_CALIBRATION;
    
    myCalCommand.version = 2;
    
    myCalCommand.calRed = RedValue;
    myCalCommand.calGreen = greenValue;
    myCalCommand.calBlue = blueValue;
    myCalCommand.calClear= clearValue;
    
    
    NSData *data = [NSData dataWithBytes: (void *)&myCalCommand  length: sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T)];
    NSLog(@"Writing Calibration Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %ld", [data hexadecimalString], sizeof(DAYSI_LIGHT_CALIBRATION_DATA_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];
    
    
}


-(void) WriteTimeData:(time_t)time
{
    

    DAYSI_LIGHT_TIME_DATA_T myTimeCommand;
    myTimeCommand.preambleLo = 0x55;
    myTimeCommand.preambleHi = 0xaa;
    
    myTimeCommand.command = kPHONE_TO_DAYSILIGHT_SET_TIME;
    
    myTimeCommand.version = 0;
    
    myTimeCommand.unixTime = 0;
    
    
    
    NSData *data = [NSData dataWithBytes: (void *)&myTimeCommand  length: sizeof(DAYSI_LIGHT_TIME_DATA_T)];
    NSLog(@"Writing Time Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %lu", [data hexadecimalString], sizeof(DAYSI_LIGHT_TIME_DATA_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];
    
    
}

-(void) WriteResetErrorData:(time_t)time
{
    
    
    DAYSI_LIGHT_TIME_DATA_T myTimeCommand;
    myTimeCommand.preambleLo = 0x55;
    myTimeCommand.preambleHi = 0xaa;
    
    myTimeCommand.command = kPHONE_TO_DAYSILIGHT_RESET_ERROR;
    
    myTimeCommand.version = 0;
    
    myTimeCommand.unixTime = 0;
    
    
    
    NSData *data = [NSData dataWithBytes: (void *)&myTimeCommand  length: sizeof(DAYSI_LIGHT_TIME_DATA_T)];
    NSLog(@"Writing Light Reset Error to characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Data Written %@ length %lu", [data hexadecimalString], sizeof(DAYSI_LIGHT_TIME_DATA_T));
    
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];
    
    
}



-(void) WriteInitializeCommand
{
    DAYSI_LIGHT_COMMAND_T myCommand;
    myCommand.preambleLo = 0x55;
    myCommand.preambleHi = 0xaa;
    myCommand.command = kPHONE_TO_DAYSILIGHT_INITIALIZE;
    myCommand.version = 0;
    
    NSData *data = [NSData dataWithBytes: (void *)&myCommand length: sizeof(DAYSI_LIGHT_COMMAND_T)];
    NSLog(@"Writing to Command characteristics that has a UUID of %@", [[myCBCharacteristic_DaysiLightCommand UUID] representativeString]);
    NSLog(@"Initialize Data Written %@ length %lu", [data hexadecimalString], sizeof(DAYSI_LIGHT_COMMAND_T));
    [blePeripheral writeValue:data forCharacteristic:myCBCharacteristic_DaysiLightCommand type:CBCharacteristicWriteWithResponse];
}

-(bool) IsPaired
{

    if  ((_deviceId == nil) || [_deviceId  isEqual: @"0000"])
    {
        return false;
    }
    else
    {
        return true;
    }
}

-(int) GetBootCount
{
    
    return m_DaysiLightData.bootCount;
}
-(int) GetQueueCount
{
    
    return m_DaysiLightData.address;
}

@end
