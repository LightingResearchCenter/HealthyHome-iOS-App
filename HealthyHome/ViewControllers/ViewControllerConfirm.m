//
//  ViewControllerConfirm.m
//  
//
//  Created by Rajeev Bhalla on 4/30/14.
//  Copyright (c) 2014 Rajeev Bhalla. All rights reserved.
//

#import "ViewControllerConfirm.h"
#include "DaysiUtilities.h"
#include "CustomCategories.h"

@interface ViewControllerConfirm ()

@end

@implementation ViewControllerConfirm

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
    [DaysiUtilities SetLayerToGlow:self.UIButtonConfirmYes.layer WithColor:[UIColor CustomOrangeColor]];
    [DaysiUtilities SetLayerToGlow:self.UIButtonConfirmNo.layer WithColor:[UIColor CustomOrangeColor]];
   // [DaysiUtilities rotateAndFadeView:self.UIImageViewLogo ForDurationInSecs:10];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UIButtonConfirmYesClose:(id)sender {
    
    self.confirmExit = true;
    [self.delegate addItemViewController:self didFinishConfirmSelection:true];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)UIButtonConfirmNoClose:(id)sender
{
    self.confirmExit = false;
    [self.delegate addItemViewController:self didFinishConfirmSelection:false];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
