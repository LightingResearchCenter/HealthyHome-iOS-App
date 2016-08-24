//
//  ViewControllerInformation.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/29/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerInformation.h"
#include "DaysiUtilities.h"

@interface ViewControllerInformation ()

@end

@implementation ViewControllerInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButtonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    //self.UILabelAppVersion.text = [self GetAppVersionString];
    NSLog(@"%@", self.UILabelAppVersion.text);
    
    self.UILabelAppVersion.text = [self GetAppVersionString];
    self.UILabelDaysiLightFirmwareVersion.text = self.myDaysiLight.isDevicePresent? self.myDaysiLight.strFWVersion:@"Not Present";
    self.UILabelDaysiMotionFirmwareVersion.text = self.myDaysiMotion.isDevicePresent? self.myDaysiMotion.strFWVersion:@"Not Present";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)GetAppVersionString
{
    
    NSString *myString;
    
    // Get the Version from the Bundle
    NSString *delimeter = @":";
    NSString *majorVersion = @"0";
    NSString *minorVersion = @"0";
    NSString *engineeringrVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *finalAppVersion = [[[[[[majorVersion stringByAppendingString:delimeter]
                                     stringByAppendingString:minorVersion]
                                    stringByAppendingString:delimeter]
                                   stringByAppendingString:engineeringrVersion]
                                  stringByAppendingString:delimeter]
                                 stringByAppendingString:buildVersion];
    
    //Mark whether the Build is a Debug or Release.
    //Todo - Renove at Production code
#if DEBUG
    finalAppVersion = [finalAppVersion stringByAppendingString:@" (Debug)"];
#else
    finalAppVersion = [finalAppVersion stringByAppendingString:@" (Release)"];
#endif
    
    myString = [NSString stringWithFormat:@
                " Version: %@\r\n"
                " Build Date: %@\r\n"
                " Build Time: %@"
                ,finalAppVersion, @__DATE__, @__TIME__];
    
    return myString;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Button Handlers
- (IBAction)UIButtonClose:(id)sender {
        [self dismissViewControllerAnimated:NO completion:nil];
}

@end
