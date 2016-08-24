

#import <UIKit/UIKit.h>
#import "DaysiMotion.h"

@interface ViewControllerDaysiMotionActivity : UIViewController
@property DaysiMotion *pDaysiMotion;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewBatteryStatus;
@property (weak, nonatomic) IBOutlet UILabel *UILabelLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDataLogged;
@property (weak, nonatomic) IBOutlet UILabel *UILabelData;
@property (weak, nonatomic) IBOutlet UILabel *UILabelBatteryVoltage;

-(void) UpdateDaysiActivity:(DaysiMotion *)pWatch;
-(void) RefreshUIViewControllerDaysiMotionActivity;
@property (weak, nonatomic) IBOutlet UIProgressView *UIProgressBarTimer;

@end
