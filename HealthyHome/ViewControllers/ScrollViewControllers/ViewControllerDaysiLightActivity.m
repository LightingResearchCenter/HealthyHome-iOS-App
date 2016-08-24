
#import "ViewControllerDaysiLightActivity.h"
#import "CustomCategories.h"
#include "CoreDataManager.h"
#include "GlobalConfig.h"
#include "UserSettings.h"

@interface ViewControllerDaysiLightActivity ()

@end

@implementation ViewControllerDaysiLightActivity
@synthesize myDaysiLight;
int myDaysiLightSecondsElapsedCount;

NSDate *oldestSyncTimeForDaysiLight;
NSDate *latestSyncTimeForDaysiLight;
-(void)viewDidAppear:(BOOL)animated
{
   [self.UIProgressViewTimer setProgress:0];
    myDaysiLightSecondsElapsedCount = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    oldestSyncTimeForDaysiLight = [CoreDataManager GetOldestSyncTimeForDaysiLightId:1];
    latestSyncTimeForDaysiLight = [CoreDataManager GetLatestSyncTimeForDaysiLightId:1];
    
    
    if (oldestSyncTimeForDaysiLight != nil)
    {
    
        NSTimeInterval myTimeINterval = [latestSyncTimeForDaysiLight timeIntervalSinceDate: oldestSyncTimeForDaysiLight];
  
        self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeBetweenTwoDates:oldestSyncTimeForDaysiLight NewDate: [NSDate date] ThresholdSeconds:60], [CoreDataManager GetLightReadingCount]];
        
    }
    [self.UILabelBatteryVoltage setHidden:true];
    [self.UIImageViewBatteryStatus  setHidden:true];
    [self.UILabelData setHidden:true];
    [self RefreshUIViewControllerDaysiLightActivity];

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


-(void) RefreshUIViewControllerDaysiLightActivity
{
    //Don't Bother refreshing if we are not visible
    if (self.isViewLoaded && self.view.window) {
        
        if (myDaysiLightSecondsElapsedCount  >= k_DAYSI_LIGHT_SYNC_INTERVAL)
        {
            myDaysiLightSecondsElapsedCount = 0;
        }
        else
        {
            myDaysiLightSecondsElapsedCount++;
        }
        
        //NSLog(@"RefreshUI LightActivity %d",myDaysiLightSecondsElapsedCount);
        
        [self.UIProgressViewTimer setProgress:(float)myDaysiLightSecondsElapsedCount/(k_DAYSI_LIGHT_SYNC_INTERVAL*1.2f)];

        if ([UserSettings GetDaysiLightId ] == nil || [[UserSettings GetDaysiLightId]  isEqual: @"0000"])
        {
            self.UILabelDataLogged.text = @"Pairing Required";
            self.UILabelLastSeen.text = @"";
            [self.UIImageViewBatteryStatus setHidden:true];
            self.UILabelBatteryVoltage.text = @"";
            self.UILabelData.text = @"";
            [self.UIProgressViewTimer setHidden:true];
            
        }
        else
        {
            
            NSDate *oldestSyncTime = [CoreDataManager GetOldestSyncTimeForDaysiLightId:0];
            //NSDate *lastSyncTimeCoreData = [CoreDataManager GetLatestSyncTimeForDaysiLightId:0];
            NSDate *lastSyncTime = myDaysiLight.lastSeen;
            if (lastSyncTime != nil)
            {
                NSString *friendlyDate = [NSDate FriendlyTimeBetweenTwoDates:myDaysiLight.lastSeen NewDate:[NSDate date] ThresholdSeconds:60];
                self.UILabelLastSeen.text = [NSString stringWithFormat:@"Last Sync: %@ ago", friendlyDate];

                
               // [self.UIProgressViewTimer setProgress:value];
            }
            else
            {
                lastSyncTime = [CoreDataManager GetLatestSyncTimeForDaysiLightId:0];
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
                NSTimeInterval interval = [lastSyncTime timeIntervalSinceDate:oldestSyncTime];
                //NSLog(@"Interval is %f", (interval/3600/24));
                self.UILabelDataLogged.text = [NSString stringWithFormat:@"%@ of data avlbl. %ld Recs.",[NSDate FriendlyTimeBetweenTwoDates:oldestSyncTime NewDate:lastSyncTime ThresholdSeconds:60], [CoreDataManager GetLightReadingCount]];
                
            }
            

        }
    }
}

-(void) UpdateDaysiActivity:(DaysiLight   *)pDaysiLight
{
    
    myDaysiLight = pDaysiLight;
    
    [self.UILabelBatteryVoltage setHidden:false];
    [self.UIImageViewBatteryStatus  setHidden:false];
    [self.UILabelData setHidden:false];
   
    myDaysiLightSecondsElapsedCount = 0;
    
    self.UILabelData.text = [myDaysiLight GetDebugShortString];
    self.UILabelBatteryVoltage.text = [NSString stringWithFormat:@"%3.2fV",(float) [myDaysiLight GetBatteryVoltageInMilliVolts]/1000];
    //self.UILabelDataLogged.text = [NSString stringWithFormat:@"%ld", [CoreDataManager GetReadingCount] ];
    
    
    NSString *localPath = [[NSBundle mainBundle]bundlePath];
    NSString *imageName;

    if ([myDaysiLight GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-full.png"]];
        
    }
    
    else if ([myDaysiLight GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_HIGH_MILLIVOLTS && [myDaysiLight GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_FULL_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-high.png"]];
        
    }
    
    else if ([myDaysiLight GetBatteryVoltageInMilliVolts] > BATTERY_THRESOLD_MEDIUM_MILLIVOLTS && [myDaysiLight GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_HIGH_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-medium.png"]];
        
    }
    else if ([myDaysiLight GetBatteryVoltageInMilliVolts] < BATTERY_THRESOLD_LOW_MILLIVOLTS)
    {
        imageName = [localPath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"battery-low.png"]];
    }
    
    [self.UIImageViewBatteryStatus setImage:[UIImage imageWithContentsOfFile:imageName]];
}

@end
