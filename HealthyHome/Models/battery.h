//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Battery

#import <Foundation/Foundation.h>


typedef struct BATTERY_DATA
{
    uint8_t  version;                     // Note: Update this value by one any time the structure changes
    uint16_t batteryInMilliVolts;
    int8_t   lifeLeftAsPercentage;
    uint8_t  batteryFlags;
    uint16_t packetCRC;
    
} BATTERY_DATA_T;

@interface Battery : NSObject

@property  BATTERY_DATA_T batteryValue;

-(NSString *) GetBatteryValueAsString;
-(NSString *)  GetDebugString;
-(int8_t) GetLifeLeftAsPercentage;

-(bool) IsLow;
-(bool) IsCriticallyLow;
-(void) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;



@end
