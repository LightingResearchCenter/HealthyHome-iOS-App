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
    uint16_t    unused;

    uint8_t     crc;
} DAYSI_DATA_T;
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

@interface DaysiData : NSObject

@property  DAYSI_DATA_T m_DaysiData;
@property  int16_t peakPressure_PSI;

@property  bool measureLatency;
@property  (readonly)  int latencyCount;
@property  (readonly ) E_ERROR_T myErrorCode;
@property  (readonly) int latency;
@property  (readonly) int latencyMin;
@property  (readonly) int latencyMax;


@property   bool thresholdTrippedHi;
@property   bool thresholdTrippedLo;
@property   bool isPressurized;

-(NSString *) GetPressureValueAsString;
-(NSString *)  GetDebugString;

-(E_ERROR_T) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;
-(void) ResetLatency;


-(BOOL) GetPressureTimerStatus;



@end
