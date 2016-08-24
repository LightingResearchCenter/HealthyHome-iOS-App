#import "ViewControllerDaysiMotionActivity.h"
#import "CustomCategories.h"
#include "CoreDataManager.h"
#include "GlobalConfig.h"
#include "UserSettings.h"

@interface ViewControllerDaysiMotionActivity ()


@end

@implementation ViewControllerDaysiMotionActivity
@synthesize pDaysiMotion;
int myDaysiMotionSecondsElapsedCount;
NSDate *oldestSyncTimeForDaysiMotion;
-(void)viewDidAppear:(BOOL)animated
{
    [self.UIProgressBarTimer setProgress:0];
    myDaysiMotionSecondsElapsedCount = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    oldestSyncTimeForDaysiMotion = [CoreDataManager GetOldestSyncTimeForDaysiMotionId:1];
    
    if (oldestSyncTimeForDaysiMotion != nil)
    {
        self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeBetweenTwoDates:oldestSyncTimeForDaysiMotion NewDate:[NSDate date] ThresholdSeconds:60], [CoreDataManager GetMotionReadingCount]];
        
    }
    else
    {
        self.UILabelDataLogged.text = [NSString stringWithFormat:@"No Data Available"];
        
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

-(void) RefreshUIViewControllerDaysiMotionActivity
{
    //Don't Bother refreshing if we are not visible
    if (self.isViewLoaded && self.view.window) {
        
        if (myDaysiMotionSecondsElapsedCount >= k_DAYSI_LIGHT_SYNC_INTERVAL)
        {
            myDaysiMotionSecondsElapsedCount = 0;
        }
        else{
            myDaysiMotionSecondsElapsedCount++;
        }
        
        //NSLog(@"RefreshUI MotionActivity %d",myDaysiMotionSecondsElapsedCount);
        
        [self.UIProgressBarTimer setProgress:(float)myDaysiMotionSecondsElapsedCount/(k_DAYSI_MOTION_SYNC_INTERVAL*1.2f)];
        if ([UserSettings GetDaysiMotionId] == nil || [[UserSettings GetDaysiMotionId]  isEqual: @"0000"])
        {
            self.UILabelDataLogged.text = @"Pairing Required";
            self.UILabelLastSeen.text = @"";
            [self.UIImageViewBatteryStatus setHidden:true];
            self.UILabelBatteryVoltage.text = @"";
            self.UILabelData.text = @"";
            [self.UIProgressBarTimer setHidden:true];
            
        }
        else
        {
            
            NSDate *oldestSyncTime = [CoreDataManager GetOldestSyncTimeForDaysiMotionId:0];
            //NSDate *latestSyncTime = [CoreDataManager GetLatestSyncTimeForDaysiMotionId:0];
            NSDate *lastSyncTime = pDaysiMotion.lastSeen;
            if (lastSyncTime != nil)
            {
                NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:pDaysiMotion.lastSeen NewDate:[NSDate date] ThresholdSeconds:60];
                self.UILabelLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];
                
                
                // [self.UIProgressViewTimer setProgress:value];
            }
            else
            {
                lastSyncTime = [CoreDataManager GetLatestSyncTimeForDaysiMotionId:0];
                if (lastSyncTime != nil)
                {
                    NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:lastSyncTime NewDate:[NSDate date] ThresholdSeconds:60];
                    self.UILabelLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];
                }
                else
                {
                    self.UILabelDataLogged.text = [NSString stringWithFormat:@"No Data Available"];
                }
                
            }
            
            if (oldestSyncTime != nil)
            {
                self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeBetweenTwoDates:oldestSyncTime NewDate:lastSyncTime ThresholdSeconds:60], [CoreDataManager GetMotionReadingCount]];
            
            }
            
            
        }
    }
}

-(void) UpdateDaysiActivity:(DaysiMotion *)pMotion
{
    
    pDaysiMotion = pMotion;
    
    [self.UILabelBatteryVoltage setHidden:false];
    [self.UIImageViewBatteryStatus  setHidden:false];
    [self.UILabelData setHidden:false];
    myDaysiMotionSecondsElapsedCount = 0;
    
    self.UILabelData.text = [pMotion GetDebugShortString];
    self.UILabelBatteryVoltage.text = [NSString stringWithFormat:@"%3.2fV",(float) [pMotion GetBatteryVoltageInMilliVolts]/1000];
    //self.UILabelDataLogged.text = [NSString stringWithFormat:@"%ld", [CoreDataManager GetReadingCount] ];
    
    
    NSString *localPath = [[NSBundle mainBundle]bundlePath];
    NSString *imageName;
    
    if ([pMotion GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-full.png"]];
        
    }
    
    else if ([pMotion GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_HIGH_MILLIVOLTS && [pMotion GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-high.png"]];
        
    }
    
    else if ([pMotion GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_MEDIUM_MILLIVOLTS && [pMotion GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_HIGH_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-medium.png"]];
        
    }
    else if ([pMotion GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_LOW_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-low.png"]];
    }
    
    [self.UIImageViewBatteryStatus setImage:[UIImage imageWithContentsOfFile:imageName]];
    
    
}
@end
