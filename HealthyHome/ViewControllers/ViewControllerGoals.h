//
//  ViewControllerGoals.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewControllerGoals;

@protocol ViewControllerGoalsDelegate <NSObject>
- (void)OnDismissGoals:(ViewControllerGoals *)controller Confirm:(bool )confirm;
@end


@interface ViewControllerGoals : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *UIButttonClose;

@property (weak, nonatomic) IBOutlet UISlider *UISliderDesiredWakeUpTime;
@property (weak, nonatomic) IBOutlet UISlider *UISliderDesiredSleepTime;
@property (weak, nonatomic) IBOutlet UISlider *UISliderNumberOfDays;

@property (weak, nonatomic) IBOutlet UILabel *UILabelTargetWakeupTime;
@property (weak, nonatomic) IBOutlet UILabel *UILabelTargetSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *UILabelNumberOfDays;

- (IBAction)UISliderNormalWakeupTimeChanged:(id)sender;
- (IBAction)UISliderNormalSleepTimeChanged:(id)sender;
- (IBAction)UISliderNumberOfDaysChanged:(id)sender;

- (IBAction)UIButtonHomeClicked:(id)sender;

@property (nonatomic, weak) id <ViewControllerGoalsDelegate> delegate;
@end
