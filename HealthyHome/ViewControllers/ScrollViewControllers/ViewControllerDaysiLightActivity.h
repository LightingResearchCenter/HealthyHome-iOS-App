//
//  ViewControllerDaysiLightActivity.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/25/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"DaysiLight.h"

@interface ViewControllerDaysiLightActivity : UIViewController


@property DaysiLight *myDaysiLight;
@property (weak, nonatomic) IBOutlet UILabel *UILabelLastSeen;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDataLogged;
@property (weak, nonatomic) IBOutlet UILabel *UILabelData;
@property (weak, nonatomic) IBOutlet UILabel *UILabelBatteryVoltage;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewBatteryStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *UIProgressViewTimer;

-(void) UpdateDaysiActivity:(DaysiLight *)pDaysiLight;
-(void) RefreshUIViewControllerDaysiLightActivity;
@end
