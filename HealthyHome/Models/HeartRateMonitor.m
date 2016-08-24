//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing Battery


#import "HeartRateMonitor.h"


@implementation HeartRateMonitor

@synthesize heartbeatData;

- (NSString *)  GetValueAsString
{
    return [NSString stringWithFormat:@"%d",  heartbeatData.value];
}

- (NSString *)  GetDebugString
{
    
    return [NSString stringWithFormat:@"Version: %d Heartbeat: %d ", heartbeatData.version, heartbeatData.value];
}

- (NSString *)  GetHeartBeatValueAsString
{
    
    return [NSString stringWithFormat:@"%d ", heartbeatData.value];
}

-(void) ParseFromByteArray:(const uint8_t *)pBytes
{
    
    
    heartbeatData.version = 0;
    
    switch (heartbeatData.version)
    {
        case 0:
            
            if ((pBytes[0] & 0x01) == 0) {          // 2
                // Retrieve the BPM value for the Heart Rate Monitor
                heartbeatData.value = pBytes[1];
            }
            else {
                heartbeatData.value = CFSwapInt16LittleToHost(*(uint16_t *)(&pBytes[1]));  // 3
            }

            break;
            
        default:
            [NSException raise:@"Invalid Version for HeartBeat" format:@"Version %d is invalid", heartbeatData.version];
            break;
            
            
    };
}


-(void) Reset
{
    heartbeatData.value = 0;
}




@end
