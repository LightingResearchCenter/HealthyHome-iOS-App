//
//  ViewControllerGoals.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerGoals.h"
#include "DaysiUtilities.h"
#import "UserSettings.h"

@interface ViewControllerGoals ()

@end

@implementation ViewControllerGoals
bool goalsChanged = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButttonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    self.UISliderDesiredSleepTime.value = [UserSettings GetProfileNormalSleepAt];
    self.UISliderDesiredWakeUpTime.value = [UserSettings GetProfileNormalWakeAt];
    self.UISliderNumberOfDays.value = [UserSettings GetProfileTargetDays];
    
    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    goalsChanged = false;
    [self RefreshUI];
    
    
}

-(void)RefreshUI
{
    self.UILabelTargetSleepTime.text = [NSString stringWithFormat:@"Desired Sleep Time %@",[DaysiUtilities GetTimeFromFloatValue:self.UISliderDesiredSleepTime.value]];
    self.UILabelTargetWakeupTime.text = [NSString stringWithFormat:@"Desired Wake Time @ %@",[DaysiUtilities GetTimeFromFloatValue:self.UISliderDesiredWakeUpTime.value]];
    self.UILabelNumberOfDays.text = [NSString stringWithFormat:@"Number Of Days %d",[UserSettings GetProfileTargetDays]];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UISliderNormalWakeupTimeChanged:(id)sender {
    [UserSettings SetProfileNormalWakeAt:self.UISliderDesiredWakeUpTime.value];
    goalsChanged  = true;
    [self RefreshUI];
    
}

- (IBAction)UISliderNormalSleepTimeChanged:(id)sender {
    [UserSettings SetProfileNormalSleepAt:self.UISliderDesiredSleepTime.value];
     goalsChanged  = true;
    [self RefreshUI];
}

- (IBAction)UISliderNumberOfDaysChanged:(id)sender {
    [UserSettings SetProfileTargetDays:(int)self.UISliderNumberOfDays.value];
     goalsChanged  = true;
    [self RefreshUI];
}

- (IBAction)UIButtonHomeClicked:(id)sender
{
    
    [self.delegate OnDismissGoals:self Confirm:goalsChanged];

    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
