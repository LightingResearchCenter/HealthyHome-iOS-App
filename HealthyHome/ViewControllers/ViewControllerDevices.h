//
//  ViewControllerDevices.h
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "DaysiMotion.h"
#include "DaysiLight.h"
#include "ViewControllerDaysiDevicePair.h"
#import "ViewControllerConfirm.h"
@class ViewControllerDevices;

@protocol ViewControllerDevicesDelegate <NSObject>
- (void)OnDismissDevices:(ViewControllerDevices *)controller DisconnectMotion:(bool )motion DisconnectLight:(bool) light;
@end

@interface ViewControllerDevices : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, ViewControllerDevicePairDelegate, ViewControllerConfirmDelegate >
{
     NSInteger lastPage;
}
- (IBAction)UIButtonHomeClicked:(id)sender;

//Labels


@property (weak, nonatomic) IBOutlet UIButton *UIButtonDaysiMotionPair;
- (IBAction)UIButtonDaysiMotionClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonDaysiLightPair;
- (IBAction)UIButtonDaysiLightClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiLightId;


@property (weak, nonatomic) IBOutlet UILabel *UILabelDataLogged;

@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiLight;

@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiMotion;
@property (weak, nonatomic) IBOutlet UILabel *UILabelDaysiMotionId;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonClose;

@property (weak, nonatomic) IBOutlet UIScrollView *UIScrollViewDaysiMotion;
@property (weak, nonatomic) IBOutlet UIScrollView *UIScrollViewDaysiLight;
@property (weak, nonatomic) IBOutlet UIPageControl *UIPageControlDaysiMotion;
@property (weak, nonatomic) IBOutlet UIPageControl *UIPageControlDaysiLight;

@property (weak, atomic) DaysiMotion* myDaysiMotionData;
@property (weak, atomic) DaysiLight* myDaysiLightData;

@property (weak, nonatomic) IBOutlet UITextField *UITextFieldControlHubId;

-(void)RefreshUIViewControllerDevices;

-(void) UpdateDaysiMotionData;
-(void) UpdateDaysiLightData;

@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiMotion;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiLight;


@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewHeartBeat;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiMotionSync;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDaysiLightSync;
@property (nonatomic, weak) id <ViewControllerDevicesDelegate> delegate;
@end
