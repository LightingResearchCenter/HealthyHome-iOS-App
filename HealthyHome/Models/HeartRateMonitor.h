#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef struct HEARTBEAT_DATA
{
    uint8_t  version;                     // Note: Update this value by one any time the structure changes
    uint16_t value;
    uint8_t  flags;
    uint16_t packetCRC;
    
} HEARTBEAT_DATA_T;

@interface HeartRateMonitor : NSObject

@property  HEARTBEAT_DATA_T heartbeatData;
@property  bool isDevicePresent;
@property  CBPeripheral* blePeripheral;

-(NSString *) GetHeartBeatValueAsString;
-(NSString *)  GetDebugString;


-(void) ParseFromByteArray:(const uint8_t *)pBytes;
-(void) Reset;



@end
