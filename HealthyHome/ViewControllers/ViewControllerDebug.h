//
//  ViewControllerDebug.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/30/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DaysiMotion.h"
#import "DaysiLight.h"
#import "ViewControllerConfirm.h"

@class ViewControllerDebug;

@protocol ViewControllerDebugDelegate <NSObject>
- (void)OnDismissDebug:(ViewControllerDebug *)controller Confirm:(bool )confirm;
@end

@interface ViewControllerDebug : UIViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate, ViewControllerConfirmDelegate, UIActionSheetDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonEmailLogFile;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonEmailASCII;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonSyncDaysiMotionTime;
- (IBAction)UIButtonSyncDaysiMotionTimeClicked:(id)sender;


@property (weak, atomic) DaysiMotion *pDaysiMotionDevice;
@property (weak, atomic) DaysiLight *pDaysiLightDevice;

@property (weak, nonatomic) IBOutlet UILabel *UILabelRGB;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
- (IBAction)UIButtonCalibrateClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonCalibrate;
- (IBAction)UIButtonCalibrateReadClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *UIScrollViewDebug;
@property (weak, nonatomic) IBOutlet UIPageControl *UIPageControlDebug;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonReset;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonClearPaceMaker;
- (IBAction)UIButtonClearPaceMakerClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonSyncDaysliLightTime;
- (IBAction)UIButtonSyncDaysiLightTimeClicked:(id)sender;

- (IBAction)UIButtonClose:(id)sender;
- (IBAction)UIButtonEmailLogFileClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UISegmentControlCalibrate;
- (IBAction)UISegmentControlCalibrateChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UIActivityIndicatorBusy;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *UIActivityIndicatorEmail;

-(void) UpdateDaysiMotionData:(DaysiMotion *)pMotionDevice;
-(void) UpdateDaysiLightData:(DaysiLight *)pLightDevice;

@property (weak, nonatomic) IBOutlet UITextField *UITextFieldCalRed;
@property (weak, nonatomic) IBOutlet UITextField *UITextFieldCalGreen;
@property (weak, nonatomic) IBOutlet UITextField *UITextFieldCalBlue;
@property (weak, nonatomic) IBOutlet UITextField *UITextFieldCalClear;

- (IBAction)UIButtonReset:(id)sender;
- (IBAction)UIButtonPostArchiveDataClicked:(id)sender;
@property (nonatomic, weak) id <ViewControllerDebugDelegate> delegate;
-(void) PostFileToServer :(NSString *)fileNameWithFullPath :(NSString *)urlString;
-(void) RefreshUI;

@end
