//
//  DaysiUtilities.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/29/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#ifndef Daysimeter_DaysiUtilities_h
#define Daysimeter_DaysiUtilities_h

@interface DaysiUtilities : NSObject

+ (void) SetLayerToGlow: (CALayer *) pLayer WithColor:(UIColor *)glowColor;
+ (UIColor *) GetGlowColor;
+ (CABasicAnimation *)translateAnimation;
+ (CABasicAnimation *)rotateAnimation: (int)timeInSecs ;
+ (CABasicAnimation *)pulseAnimation;
+(CAAnimationGroup *) rotateAndFade: (int)timeinSecs;
+(void )rotateAndFadeView: (UIView *)myView ForDurationInSecs:(int)timeInSecs;
+(NSString *) GetTimeFromFloatValue: (float)myFloatValue;
+ (UIColor *) GetDeviceConnectedGlowColor;
+ (NSString *)deviceUUID;
+ (NSArray *) GetNameFromDeviceName: (NSString *)  deviceName;
+ (NSString *) ZerosWithLength:(int)length;
+ (BOOL)connectedToInternet;
+ (int)GetGMTOffset;
+ (NSString *)identifierForAdvertising;
+(NSString *)GetStringForDate:(NSDate *)pDate;
+ (NSArray *)smoothedArray:(NSArray *)items FilterCount:(int)numberToAverageBy;
@end

#endif
