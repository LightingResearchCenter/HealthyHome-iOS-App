//
//  ViewControllerProfile.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerProfile.h"
#import "DaysiUtilities.h"
#import "UserSettings.h"

@interface ViewControllerProfile ()

@property   CustomDatePicker *datePicker;
@property UIDatePicker *myDatePicker;
@end

@implementation ViewControllerProfile
-(id)init
{
    NSString* form =  NSStringFromClass(self.class);
    self = [super initWithNibName:[NSString stringWithFormat:@"%@",form] bundle:nil];
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //self.datePicker = [[CustomDatePicker alloc]initWithFrame:CGRectMake(20,20,200, 80) ];
       // [self.view addSubview:self.datePicker];
       // [self.datePicker setHidden:false];
    }
    return self;
}

- (void) dateUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    self.UITextFieldDateOfBirth.text = [formatter stringFromDate:datePicker.date];
}


- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
    [UserSettings SetProfileDateOfBirth:self.UITextFieldDateOfBirth.text];
}

-(void)RefreshUI
{
    self.UILabelAgeValue.Text =   [NSString stringWithFormat:@"%d", (int)self.UISliderAge.value];
    
    self.UISliderSleepAt.Value = [UserSettings GetProfileNormalSleepAt];
    self.UILabelSleepAtValue.text = [NSString stringWithFormat:@"I Sleep @  %@",[DaysiUtilities GetTimeFromFloatValue: self.UISliderSleepAt.value]];
    
    self.UISliderWakeAt.Value = [UserSettings GetProfileNormalWakeAt];
    self.UILabelWakeAtValue.text = [NSString stringWithFormat:@"I Wake up @ %@",[DaysiUtilities GetTimeFromFloatValue:self.UISliderWakeAt.value]];

    for (int i=0; i< self.UISegmentControlGender.numberOfSegments; i++)
    {
        if ([[self.UISegmentControlGender titleForSegmentAtIndex:i] isEqualToString:[UserSettings GetProfileGender]])
        {
            self.UISegmentControlGender.selectedSegmentIndex = i;
        }
    }
    
    
    
    self.UISegmentControlWorkLocation.selectedSegmentIndex = [UserSettings GetProfileNormallyWorkAt];
    
    self.UITextFieldDateOfBirth.text = [UserSettings GetProfileDateOfBirth];
    [self.UITextFieldDateOfBirth setReturnKeyType:UIReturnKeyDone];
    
    _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _myDatePicker.datePickerMode = UIDatePickerModeDate;
    _myDatePicker.minuteInterval = 5;
    _myDatePicker.backgroundColor = [UIColor whiteColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *anyDate = [formatter dateFromString:[UserSettings GetProfileDateOfBirth]];
    [_myDatePicker setDate:anyDate];
    
    [_myDatePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    self.UITextFieldDateOfBirth.inputView = _myDatePicker;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];

    self.UITextFieldDateOfBirth.inputAccessoryView = keyboardDoneButtonView;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButtonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    self.datePicker.delegate = self;
    [self RefreshUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)UIButtonHomeClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)UISegmentControlGenderChanged:(id)sender
{
    //Update the User Settings with the Selected text
    NSString *selectedText = [self.UISegmentControlGender titleForSegmentAtIndex:self.UISegmentControlGender.selectedSegmentIndex];
    
    [UserSettings SetProfileGender:selectedText];
}
- (IBAction)UITextFieldDateOfBirthValueChanged:(id)sender
{

    [UserSettings SetProfileDateOfBirth:self.UITextFieldDateOfBirth.text];

}

- (IBAction)UITextFieldTouchUpInside:(id)sender
{
  
}

- (IBAction)UISliderAgeChanged:(id)sender {
    

    
}



- (IBAction)UISliderSleepAtChanged:(id)sender {
 

    
    self.UILabelSleepAtValue.text = [NSString stringWithFormat:@"I Sleep @  %@",[DaysiUtilities GetTimeFromFloatValue:self.UISliderSleepAt.value]];
    [UserSettings SetProfileNormalSleepAt:self.UISliderSleepAt.value];
    

}

- (IBAction)UISliderWakeAtChanged:(id)sender {

    self.UILabelWakeAtValue.text = [NSString stringWithFormat:@"I Wake up @ %@",[DaysiUtilities GetTimeFromFloatValue:self.UISliderWakeAt.value]];
    [UserSettings SetProfileNormalWakeAt:self.UISliderWakeAt.value];

 
}
- (IBAction)UISegmentWorkLocationChanged:(id)sender {
    
    [UserSettings SetProfileNormallyWorkAt:self.UISegmentControlWorkLocation.selectedSegmentIndex];
}
@end
