//
//  ViewControllerConfirm.h
// 
//
//  Created by Rajeev Bhalla on 4/30/14.
//  Copyright (c) 2014 Rajeev Bhalla. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewControllerConfirm;

@protocol ViewControllerConfirmDelegate <NSObject>
- (void)addItemViewController:(ViewControllerConfirm *)controller didFinishConfirmSelection:(bool )confirm;
@end


@interface ViewControllerConfirm : UIViewController
@property (strong, nonatomic) NSString* caption;
@property (strong, nonatomic) IBOutlet UIButton *UIButtonConfirmYes;
@property (strong, nonatomic) IBOutlet UIButton *UIButtonConfirmNo;
@property  bool confirmExit;

- (IBAction)UIButtonConfirmYesClose:(id)sender;
- (IBAction)UIButtonConfirmNoClose:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UILabelCaption;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewLogo;

@property (nonatomic, weak) id <ViewControllerConfirmDelegate> delegate;

@end
