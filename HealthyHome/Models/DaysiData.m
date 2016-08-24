//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Pressure


#import "DaysiData.h"
#include "crc16.h"
#include "GlobalConfig.h"


@implementation DaysiData

@synthesize m_DaysiData;

const int kTIME_STAMP_LOG_BUFFER_SIZE = 4;               // Size of buffer that holds the time stamp data
const int kTIME_SUCCESSIVE_READINGS_TOO_LONG_MS = 200;
const int kTOO_MANY_SUCCESSIVE_DELAYED_READINGS = 100;
const int kTIME_STAMP_LONG_INTERMITTENT_MS = 1000;
const int kTIME_STAMP_TOO_LONG_MS = 2000;
const int kSYRINGE_TIMESTAMP_SCALER = 32768;         // Syringe Counter ticks at 32.768 KHz
const int kTIME_STAMP_SYRINGE_MAX = 16777215;        // Syringe implements a 24 Bit counter

bool oldPressureTimerStatusBit;
bool PressureTimerStatusBit;


int32_t timeStampLog[kTIME_STAMP_LOG_BUFFER_SIZE];
int pressureTimeStampFirstValue = 0;

NSMutableArray *timeStampFromSyringeArray;

-(id)init
{
    if (timeStampFromSyringeArray == nil)
    {
        timeStampFromSyringeArray = [[NSMutableArray alloc]init];
    }
    oldPressureTimerStatusBit = 0;
    return self;
}

- (NSString *)  GetCommandValueAsString
{
    return [NSString stringWithFormat:@"%d",  m_DaysiData.command];
}

- (NSString *)  GetDebugString
{
    
    return [NSString stringWithFormat:@"Version: %d Command: %d  EEpromAddress: %d Red: %02X Green: %02X Blue: %02X Activity: %02X", m_DaysiData.version, m_DaysiData.command, m_DaysiData.eepromAddress, m_DaysiData.redValue, m_DaysiData.greenValue, m_DaysiData.blueValue, m_DaysiData.activityValue];
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
                
                break;
                

            default:
                [NSException raise:@"Invalid Version for DaysiData" format:@"Version %d is invalid", m_DaysiData.version];
                break;
                
        }
        
    };
    
    
    //Todo -  Verify that the timestamp does not exceed the performance thershold
    if (k_FEATURE_DISPLAY_FAULTS && errorCode != E_No_Error)
    {
        errorCode = E_No_Error;
        _myErrorCode = errorCode;
    }
    
    return errorCode;
    
    
}




-(E_ERROR_T) LogSyringeTimeStamp :(uint32_t)currentPressureTimeStamp
{
    
    // Calculate delta for pressure timeStamp
    E_ERROR_T errorCode = E_No_Error;
    
    int pressureTimestampDelta = 0;
    
    static uint32_t pressureLastTimeStamp;

    if (pressureTimeStampFirstValue == 0)
    {
        pressureLastTimeStamp = currentPressureTimeStamp;
        pressureTimeStampFirstValue = 1;
    }
    else
    {
        
        
        if ( currentPressureTimeStamp > pressureLastTimeStamp)
        {
            pressureTimestampDelta = (currentPressureTimeStamp - pressureLastTimeStamp);
        }
        else if (pressureLastTimeStamp > currentPressureTimeStamp)
        {
            // Rollover has occured - compute the delta due to the rollover effect
            pressureTimestampDelta = ((kTIME_STAMP_SYRINGE_MAX -  pressureLastTimeStamp) + currentPressureTimeStamp);
        }
        
        
        // Convert timestamp data from Ticks sent by Syringe to milliseconds
        float pressureTimeDeltaMilliseconds  = (float)pressureTimestampDelta / kSYRINGE_TIMESTAMP_SCALER;
        pressureTimeDeltaMilliseconds *= 1000;
        _latency   = (int) pressureTimeDeltaMilliseconds;
        if (_latency < _latencyMin)
        {
            _latencyMin = _latency;
        }
        
        if(_latency > _latencyMax)
        {
            _latencyMax = _latency;
        }
        
        //Log the timestamp in milliseconds to a buffer
        if ([timeStampFromSyringeArray count] == kTIME_STAMP_LOG_BUFFER_SIZE )
        {
            [timeStampFromSyringeArray removeObjectAtIndex:0];
        }
        [timeStampFromSyringeArray addObject:[NSNumber numberWithInt:(int32_t) pressureTimeDeltaMilliseconds]];
        NSLog(@"TimeDelta: %d CurrentTS: %d LastTimeStamp: %d" , (int32_t)pressureTimeDeltaMilliseconds, currentPressureTimeStamp, pressureLastTimeStamp);
        pressureLastTimeStamp = currentPressureTimeStamp;
        
        
        //Check if the timeStamp violates the latency requirements
        if (pressureTimeDeltaMilliseconds > kTIME_STAMP_TOO_LONG_MS)
        {
            errorCode =  E_LatencyOver_2000;
        }
        else if (pressureTimeDeltaMilliseconds > kTIME_STAMP_LONG_INTERMITTENT_MS)
        {
            errorCode = E_LatencyOver_1000;
        }
        else if (pressureTimeDeltaMilliseconds > kTIME_SUCCESSIVE_READINGS_TOO_LONG_MS)
        {
            _latencyCount ++;
            if (_latencyCount > 100)
            {
                
                errorCode = E_Latency_Successive_200;
            }
        }
        else if ([timeStampFromSyringeArray count] == kTIME_STAMP_LOG_BUFFER_SIZE)
        {
            bool flagInViolation = 1;
            for (int i=0; i<kTIME_STAMP_LOG_BUFFER_SIZE; i++)
            {
                int timeStamp = [[timeStampFromSyringeArray objectAtIndex:i] intValue];
                if (timeStamp < kTIME_SUCCESSIVE_READINGS_TOO_LONG_MS)
                {
                    flagInViolation &= 0;
                }
            }
            if (flagInViolation)
            {
                errorCode = E_Latency_Successive_200;
                _latencyCount ++;
            }
            
        }
        
    }
    
    return errorCode;
    
}

-(void) ResetLatency
{
    _latencyCount = 0;
    _myErrorCode = E_No_Error;
    _latencyMax = _latencyMin = 0;
    pressureTimeStampFirstValue = 0;
    
}

-(void) Reset
{
    m_DaysiData.command  = 0;
    _peakPressure_PSI = 0;
    [self ResetLatency];
    
}






-(BOOL)GetPressureTimerStatus
{
    return (true);
    
}

@end
