//
//  ViewControllerDaysiwatchActivity.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/21/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaysiWatch.h"

@interface ViewControllerDaysiwatchActivity : UIViewController
@property DaysiWatch *pDaysiWatch;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewBatteryStatus;
@property (weak, nonatomic) IBOutlet UILabel *UILabelLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDataLogged;
@property (weak, nonatomic) IBOutlet UILabel *UILabelData;
@property (weak, nonatomic) IBOutlet UILabel *UILabelBatteryVoltage;

-(void) UpdateDaysiActivity:(DaysiWatch *)pWatch;
-(void) RefreshUI;

@end
