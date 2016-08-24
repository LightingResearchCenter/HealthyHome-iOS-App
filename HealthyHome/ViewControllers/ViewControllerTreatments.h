//
//  ViewControllerTreatments.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewControllerTreatments;
#import "CircadianModelManager.h"
@protocol ViewControllerTreatmentsDelegate <NSObject>
- (void)OnDismissTreatments:(ViewControllerTreatments *)controller Confirm:(bool )confirm;
@end

@interface ViewControllerTreatments : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *UIButtonHome;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;
@property (weak, nonatomic) IBOutlet UITableView *UITableViewTreatments;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewTableFrame;

@property (weak, nonatomic) IBOutlet UIImageView *UIImageVieMortalPestle;
@property (weak, nonatomic) IBOutlet UILabel *UILabelErrorCode;

- (IBAction)ButtonHomeClicked:(id)sender;
@property (nonatomic, weak) id <ViewControllerTreatmentsDelegate> delegate;
@property (weak, atomic) CircadianModelManager * ciracdianManager;
@end
