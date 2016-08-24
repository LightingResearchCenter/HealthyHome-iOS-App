//
//  ViewControllerDaysiwatchActivity.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/21/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerDaysiwatchActivity.h"
#import "CustomCategories.h"
#include "CoreDataManager.h"
#include "GlobalConfig.h"

@interface ViewControllerDaysiwatchActivity ()


@end

@implementation ViewControllerDaysiwatchActivity
@synthesize pDaysiWatch;
NSDate *oldestSyncTimeForDaysiWatch;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    oldestSyncTimeForDaysiWatch = [CoreDataManager GetOldestSyncTimeForWatchId:1];
    if (oldestSyncTimeForDaysiWatch != nil)
    {
        self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeSinceDate:oldestSyncTimeForDaysiWatch ThresholdSeconds:60], [CoreDataManager GetReadingCount]];
        
    }
    [self.UILabelBatteryVoltage setHidden:true];
    [self.UIImageViewBatteryStatus  setHidden:true];
    [self.UILabelData setHidden:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) RefreshUI
{
    
    NSDate *lastSeen = [CoreDataManager GetLatestSyncTimeForWatchId:0];
    if (lastSeen != nil)
    {
        self.UILabelLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", [NSDate FriendlyTimeSinceDate:lastSeen ThresholdSeconds:60]];
    }
    
    if (oldestSyncTimeForDaysiWatch != nil)
    {
        self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeSinceDate:oldestSyncTimeForDaysiWatch ThresholdSeconds:60], [CoreDataManager GetReadingCount]];
        
    }
}

-(void) UpdateDaysiActivity:(DaysiWatch *)pWatch
{
    
    pDaysiWatch = pWatch;
    
    [self.UILabelBatteryVoltage setHidden:false];
    [self.UIImageViewBatteryStatus  setHidden:false];
    [self.UILabelData setHidden:false];
    
    
    self.UILabelData.Text = [pWatch GetDebugShortString];
    self.UILabelBatteryVoltage.text = [NSString stringWithFormat:@"%3.2fV",(float) [pWatch GetBatteryVoltageInMilliVolts]/1000];
    //self.UILabelDataLogged.text = [NSString stringWithFormat:@"%ld", [CoreDataManager GetReadingCount] ];
    
    
    NSString *localPath = [[NSBundle mainBundle]bundlePath];
    NSString *imageName;
    
    if ([pWatch GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-full.png"]];
        
    }
    
    else if ([pWatch GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_HIGH_MILLIVOLTS && [pWatch GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-high.png"]];
        
    }
    
    else if ([pWatch GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_MEDIUM_MILLIVOLTS && [pWatch GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_HIGH_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-medium.png"]];
        
    }
    else if ([pWatch GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_LOW_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-low.png"]];
    }
    
    [self.UIImageViewBatteryStatus setImage:[UIImage imageWithContentsOfFile:imageName]];
    
    
}
@end
