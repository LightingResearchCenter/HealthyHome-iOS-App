//
//  ViewControllerSettings.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/29/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerSettings : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;
- (IBAction)UIButtonCloseClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UISegmentControlTreatmentIntensity;
- (IBAction)UISliderMinTreatmentTimeChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *UISliderMaxTreatmentTimeChanged;

@end
