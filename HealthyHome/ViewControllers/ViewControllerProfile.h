//
//  ViewControllerProfile.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDatePicker.h"

#define INIT_BASE_VC NSString* form =  NSStringFromClass(self.class); \
if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad))\
{\
self = [super initWithNibName:[NSString stringWithFormat:@"%@",form] bundle:nil];\
}\
else\
{\
self = [super initWithNibName:[NSString stringWithFormat:@"%@",form] bundle:nil];\
} \
return self;
@interface ViewControllerProfile : UIViewController

@property (weak, nonatomic) IBOutlet CustomDatePicker *customDatePicker;
- (IBAction)UIButtonHomeClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;
@property (weak, nonatomic) IBOutlet UILabel *UILabelAgeValue;
@property (weak, nonatomic) IBOutlet UILabel *UILabelSleepAtValue;
@property (weak, nonatomic) IBOutlet UILabel *UILabelWakeAtValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UISegmentControlWorkLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UISegmentControlGender;
- (IBAction)UISegmentControlGenderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *UITextFieldDateOfBirth;
- (IBAction)UITextFieldDateOfBirthValueChanged:(id)sender;
- (IBAction)UITextFieldTouchUpInside:(id)sender;


- (IBAction)UISliderAgeChanged:(id)sender;
- (IBAction)UISliderSleepAtChanged:(id)sender;
- (IBAction)UISliderWakeAtChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *UISliderAge;
@property (weak, nonatomic) IBOutlet UISlider *UISliderSleepAt;
@property (weak, nonatomic) IBOutlet UISlider *UISliderWakeAt;
- (IBAction)UISegmentWorkLocationChanged:(id)sender;

@end
