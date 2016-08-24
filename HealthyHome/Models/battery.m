//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Battery


#import "battery.h"


@implementation Battery

@synthesize batteryValue;

- (NSString *)  GetBatteryValueAsString
{
    return [NSString stringWithFormat:@"%d",  batteryValue.batteryInMilliVolts];
}

- (NSString *)  GetDebugString
{
    
    return [NSString stringWithFormat:@"Version: %d Battery(mV): %d  Timestamp: ", batteryValue.version, batteryValue.batteryInMilliVolts];
}


-(void) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    batteryValue.version = pBytes[0];

    switch (batteryValue.version)
    {
        case 0:
            batteryValue.batteryInMilliVolts = (pBytes[1]) | (pBytes[2] << 8);

            break;
            
            
        case 1:
            batteryValue.batteryInMilliVolts = (pBytes[1]) | (pBytes[2] << 8);
            batteryValue.lifeLeftAsPercentage = (pBytes[3]);
            batteryValue.batteryFlags = pBytes[4];
            batteryValue.packetCRC  =(pBytes[5]) | (pBytes[6] << 8);
            
            break;
            
        default:
            [NSException raise:@"Invalid Version for Battery" format:@"Version %d is invalid", batteryValue.version];
            break;
            
            
    };
}


-(void) Reset
{
    batteryValue.batteryInMilliVolts = 0;
}

-(int8_t) GetLifeLeftAsPercentage
{
    return self.batteryValue.lifeLeftAsPercentage;
}

-(bool) IsLow
{
    return batteryValue.batteryFlags & 0x01;
}

-(bool) IsCriticallyLow
{
    return ((batteryValue.batteryFlags & 0x02) >> 1);
    
}

@end
