//
//  ViewController.m
//  RSC Thread Demo
//
//  Created by Jeremy Bramson on 8/20/12.
//  Copyright © 2012 Redpark  All Rights Reserved
//

#import "ViewController.h"
#include "/usr/include/libkern/OSAtomic.h"

// NOTE - you must install the XCode "Command Line Tools" from preferences to have access to the OSAtomic header.

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    // load test buffer
    int i;
    for (i = 0; i < TEST_DATA_LEN; i++)
    {
        testData[i] = i;
    }
    
    
    // Create and start the comm thread.  We'll use this thread to manage the rscMgr so
    // we don't tie up the UI thread.
    if (commThread == nil)
    {
        commThread = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(startCommThread:)
                                             object:nil];
        [commThread start];  // Actually create the thread
    }
}

- (void)viewDidUnload
{
    [cableStateLabel release];
    cableStateLabel = nil;
    [txLabel release];
    txLabel = nil;
    [rxLabel release];
    rxLabel = nil;
    [errLabel release];
    errLabel = nil;
    [startButton release];
    startButton = nil;
    [baudRateLabel release];
    baudRateLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (IBAction)clickedStart:(id)sender
{
    if (testRunning == NO)
    {
        [startButton setTitle:STOP_STR forState:UIControlStateNormal];
        [self performSelector:@selector(startTest) onThread:commThread withObject:nil waitUntilDone:YES];
    }
    else
    {
        [startButton setTitle:START_STR forState:UIControlStateNormal];
        [self performSelector:@selector(stopTest) onThread:commThread withObject:nil waitUntilDone:YES];
    }
}

- (void) resetCounters
{
    txCount = rxCount = errCount = 0;
    seqNum = 0;
    testRunning = FALSE;
}

- (void) updateStatus:(id)object
{
    cableStateLabel.text = (cableConnected == YES) ? CONNECTED_STR : NOT_CONNECTED_STR;
    
    rxLabel.text = [NSString stringWithFormat:@"%d", rxCount];
    txLabel.text = [NSString stringWithFormat:@"%d", txCount];
    errLabel.text = [NSString stringWithFormat:@"%d", errCount];
    
    if (cableConnected)
    {
        NSString *str = [NSString stringWithFormat:@"%d",
                         [rscMgr getBaud]];
        
        baudRateLabel.text = str;
    }
    else
    {
        baudRateLabel.text = @"?";
    }

}

- (void) startCommThread:(id)object
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // initialize RscMgr on this thread
    // so it schedules delegate callbacks for this thread
    rscMgr = [[RscMgr alloc] init];
    
    [rscMgr setDelegate:self];

    // run the run loop
    [[NSRunLoop currentRunLoop] run];
    
    [pool release];
}

- (void) startTest
{
    testRunning = YES;
    seqNum = 0;

    [rscMgr write:testData length:TEST_DATA_LEN];
    
    OSAtomicAdd32(TEST_DATA_LEN, &txCount);
    
    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:nil waitUntilDone:NO];

}

- (void) stopTest
{
    testRunning = NO;
}


// Redpark Serial Cable has been connected and/or application moved to foreground.
// protocol is the string which matched from the protocol list passed to initWithProtocol:
- (void) cableConnected:(NSString *)protocol
{
    cableConnected = YES;
    if ([rscMgr supportsExtendedBaudRates] == YES)
    {
        [rscMgr setBaud:115200];
    }
    else
    {
        [rscMgr setBaud:38400];
    }
    
    serialPortConfig portCfg;
	[rscMgr getPortConfig:&portCfg];
    portCfg.txAckSetting = 1;
    [rscMgr setPortConfig:&portCfg requestStatus: NO];

    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:nil waitUntilDone:NO];
    
}

// Redpark Serial Cable was disconnected and/or application moved to background
- (void) cableDisconnected
{
    cableConnected = NO;
    [self stopTest];
    [self resetCounters];
    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:nil waitUntilDone:NO];
}

// serial port status has changed
// user can call getModemStatus or getPortStatus to get current state
- (void) portStatusChanged;
{
    static serialPortStatus portStat;
    
    [rscMgr getPortStatus:&portStat];
    
    if(testRunning == YES && portStat.txAck)
    {
        // tx fifo has been drained in cable so
        // write some more
        [rscMgr write:testData length:TEST_DATA_LEN];
        
        OSAtomicAdd32(TEST_DATA_LEN, &txCount);
        
        [self performSelectorOnMainThread:@selector(updateStatus:) withObject:nil waitUntilDone:NO];
    }

}

// bytes are available to be read (user calls read:)
- (void) readBytesAvailable:(UInt32)length
{
    int len;
    
    while (length)
    {
        len = [rscMgr read:rxBuffer length:TEST_DATA_LEN];

        int i;
        for (i = 0; i < len; i++)
        {
            if (rxBuffer[i] != seqNum)
            {
                OSAtomicIncrement32(&errCount);
                seqNum = rxBuffer[i];
            }
            seqNum++;
        }
    
        OSAtomicAdd32(len, &rxCount);
    
        length -= len;
    }
    [self performSelectorOnMainThread:@selector(updateStatus:) withObject:nil waitUntilDone:NO];
    
}


- (void)dealloc {
    [cableStateLabel release];
    [txLabel release];
    [rxLabel release];
    [errLabel release];
    [startButton release];
    [baudRateLabel release];
    [super dealloc];
}
@end
