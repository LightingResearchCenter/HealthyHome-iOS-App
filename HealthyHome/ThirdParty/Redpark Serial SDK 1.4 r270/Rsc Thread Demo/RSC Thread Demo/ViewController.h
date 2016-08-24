//
//  ViewController.h
//  RSC Thread Demo
//
//  Created by Jeremy Bramson on 8/20/12.
//  Copyright © 2012 Redpark  All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "RscMgr.h"

#define START_STR @"Start"
#define STOP_STR  @"Stop"
#define CONNECTED_STR @"Connected"
#define NOT_CONNECTED_STR @"Not Connected"

#define TEST_DATA_LEN 256

@interface ViewController : UIViewController <RscMgrDelegate>
{
    NSThread *commThread;
    RscMgr *rscMgr;
    
    IBOutlet UILabel *cableStateLabel;
    IBOutlet UILabel *baudRateLabel;
    IBOutlet UILabel *txLabel;
    IBOutlet UILabel *rxLabel;
    IBOutlet UILabel *errLabel;
    IBOutlet UIButton *startButton;
    BOOL cableConnected;
    int rxCount;
    int txCount;
    int errCount;
    UInt8 seqNum;
    UInt8 testData[TEST_DATA_LEN];
    UInt8 rxBuffer[TEST_DATA_LEN];
    BOOL testRunning;
}
- (IBAction)clickedStart:(id)sender;

- (void) startCommThread:(id)object;
- (void) updateStatus:(id)object;
- (void) resetCounters;
- (void) startTest;
- (void) stopTest;

@end
