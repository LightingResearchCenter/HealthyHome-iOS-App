//
//  ViewControllerInformation.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/29/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaysiLight.h"
#import "DaysiMotion.h"


@interface ViewControllerInformation : UIViewController
- (IBAction)UIButtonClose:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;
@property (weak, nonatomic) IBOutlet UILabel *UILabelAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiMotionFirmwareVersion;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiLightFirmwareVersion;
@property (weak, atomic) DaysiMotion* myDaysiMotion;
@property (weak, atomic) DaysiLight* myDaysiLight;

@end
