//
//  ViewControllerSelectDaysimeter.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/13/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewControllerSelectDaysimeter;

//Declare a delegate which is used when the use finishes selecting an item.
@protocol ViewControllerSelectDaysimeterDelegate <NSObject>
- (void)addItemViewController:(ViewControllerSelectDaysimeter *)controller didFinishEnteringItem:(int)selectedItem;
@end
@interface ViewControllerSelectDaysimeter : UIViewController <UIPickerViewDelegate>
- (IBAction)UIButtonCloseAction:(id)sender;
- (IBAction)UIButtonCancelAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *UIButtonSelect;
@property (strong, nonatomic) IBOutlet UIButton *UIButtonCancel;
@property (strong, nonatomic) IBOutlet UILabel *UILabelTitle;
@property (strong, nonatomic) NSMutableArray *myList;
@property (nonatomic, weak) id <ViewControllerSelectDaysimeterDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *UIPickerViewDaysimeter;
@end
