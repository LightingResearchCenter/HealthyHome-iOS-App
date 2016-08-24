//
//  DaysiUtilities.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/29/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaysiUtilities.h"
#import "CustomCategories.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <CoreGraphics/CoreGraphics.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation DaysiUtilities

+ (void) SetLayerToGlow: (CALayer *)pLayer WithColor:(UIColor *)glowColor
{
    
    pLayer.shadowColor = [glowColor CGColor];
    pLayer.shadowRadius = 4.0f;
    pLayer.shadowOpacity = .9;
    pLayer.shadowOffset = CGSizeZero;
    pLayer.masksToBounds = NO;
}

+ (UIColor *) GetGlowColor
{
    return [UIColor clearColor];

}

+ (UIColor *) GetDeviceConnectedGlowColor
{
    return [UIColor blueColor];
    
}

+ (NSString *)deviceUUID
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]])
        return [[NSUserDefaults standardUserDefaults] objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    @autoreleasepool {
        
        CFUUIDRef uuidReference = CFUUIDCreate(nil);
        CFStringRef stringReference = CFUUIDCreateString(nil, uuidReference);
        NSString *uuidString = (__bridge NSString *)(stringReference);
        [[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidReference);
        CFRelease(stringReference);
        return uuidString;
    }
}



+ (uint64_t) getTickCount
{
    static mach_timebase_info_data_t sTimebaseInfo;
    uint64_t machTime = mach_absolute_time();
    
    // Convert to nanoseconds - if this is the first time we've run, get the timebase.
    if (sTimebaseInfo.denom == 0 )
    {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
    // Convert the mach time to milliseconds
    uint64_t millis = ((machTime / 1000000) * sTimebaseInfo.numer) / sTimebaseInfo.denom;
    return millis;
}

+(NSString *) GetTimeFromFloatValue: (float)myFloatValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h-mm a"];
    
    NSDate *zeroDate = [dateFormatter dateFromString:@"12-00 AM"];
    NSUInteger numberOfSlots = 24*4 - 1; //total number of 15mins slots
    
    NSUInteger actualSlot = roundf(numberOfSlots*myFloatValue);
    NSTimeInterval slotInterval = actualSlot * 15 * 60;
    
    NSDate *slotDate = [NSDate dateWithTimeInterval:slotInterval sinceDate:zeroDate];
    [dateFormatter setDateFormat:@"h:mm a"];
    return [dateFormatter stringFromDate:slotDate];
    
}

+ (CABasicAnimation *)transparencyAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [animation setToValue:[NSNumber numberWithFloat:0.2f]];
    return animation;
}

+ (CABasicAnimation *)translateAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(100.0, 100.0)]];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(100.0, 250.0)];
    return animation;
}


+ (CABasicAnimation *)pulseAnimation {
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = [NSNumber numberWithFloat:2.0];
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimation.duration =  0.2; //60. / (float)self.myHeartBeatData.heartbeatData.value / 2.;
    pulseAnimation.repeatCount = 1;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
    return pulseAnimation;
}



+ (CABasicAnimation *)rotateAnimation: (int)timeInSecs {
    
    // Create a rotate animation that rotates the layer
    CABasicAnimation * myRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myRotateAnimation.toValue = [NSNumber numberWithFloat:0];
    myRotateAnimation.fromValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    myRotateAnimation.duration = timeInSecs;
    myRotateAnimation.removedOnCompletion = true;
    myRotateAnimation.repeatCount = 1;
    return myRotateAnimation;
}

+(CAAnimationGroup *) rotateAndFade: (int)timeinSecs
{
    CAAnimationGroup *anim = [CAAnimationGroup animation];
    [anim setAnimations:[NSArray arrayWithObjects:[DaysiUtilities rotateAnimation:timeinSecs], [DaysiUtilities transparencyAnimation], nil]];
    [anim setDuration:timeinSecs];
    [anim setRemovedOnCompletion:NO];
    [anim setFillMode:kCAFillModeForwards];
    return anim;
}


+(void )rotateAndFadeView: (UIView *)myView ForDurationInSecs:(int)timeInSecs
{
    [UIView animateKeyframesWithDuration:timeInSecs delay:0 options:0 animations:^{
      [UIView addKeyframeWithRelativeStartTime:0
                              relativeDuration:0.25f
                                     animations:^{
                                         myView.alpha = 1.0;
                                     }];
        
        [UIView addKeyframeWithRelativeStartTime:0
                                relativeDuration:1
                                      animations:^{
                                          [myView.layer addAnimation:[DaysiUtilities rotateAnimation:timeInSecs] forKey:@"rotate"];
                                      }];
        
        // add fade out key frame
        // starts at 66% lasts for 33% of animation
        [UIView addKeyframeWithRelativeStartTime:0.75
                                relativeDuration:0.25
                                      animations:^{
                                          myView.alpha = 0.0;
                                      }];

    }
    completion:nil];
}

+ (NSArray *) GetNameFromDeviceName: (NSString *)  deviceName
{
    NSError * error;
    static NSString * expression = (@"^(?:iPhone|phone|iPad|iPod)\\s+(?:de\\s+)?|"
                                    "(\\S+?)(?:['’]?s)?(?:\\s+(?:iPhone|phone|iPad|iPod))?$|"
                                    "(\\S+?)(?:['’]?的)?(?:\\s*(?:iPhone|phone|iPad|iPod))?$|"
                                    "(\\S+)\\s+");
    static NSRange RangeNotFound = (NSRange){.location=NSNotFound, .length=0};
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:(NSRegularExpressionCaseInsensitive)
                                                                              error:&error];
    NSMutableArray * name = [NSMutableArray new];
    for (NSTextCheckingResult * result in [regex matchesInString:deviceName
                                                         options:0
                                                           range:NSMakeRange(0, deviceName.length)]) {
        for (int i = 1; i < result.numberOfRanges; i++) {
            if (! NSEqualRanges([result rangeAtIndex:i], RangeNotFound)) {
                [name addObject:[deviceName substringWithRange:[result rangeAtIndex:i]].capitalizedString];
            }
        }
    }
    return name;
}


+ (NSString *) ZerosWithLength:(int)length
{
    char UTF8Arr[length + 1];
    
    memset(UTF8Arr, '0', length * sizeof(*UTF8Arr));
    UTF8Arr[length] = '\0';
    
    return [NSString stringWithUTF8String:UTF8Arr];
}

+ (BOOL)connectedToInternet
{
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSError *error;
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
    NSLog(@"Error :%@",[error localizedDescription]);
    
    return ([response statusCode]==200)?YES:NO;
}
+ (int)GetGMTOffset
{
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    int timeOffset = (int)[localTimeZone secondsFromGMT]/3600.0;
    return timeOffset;
}

+ (NSString *)identifierForAdvertising
{
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
    {
        NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        
        return [IDFA UUIDString];
    }
    
    return nil;
}

+(NSString *)GetStringForDate:(NSDate *)pDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *dateString = [dateFormatter stringFromDate:pDate];
    return dateString;
    
}

+ (NSArray *)smoothedArray:(NSArray *)items FilterCount:(int)numberToAverageBy {
    
    int average = 0;
    int i = 0;

    
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    // Loop
    for (NSNumber *elevation in items) {
        
        average += [elevation intValue];
        i++;
        
        if (i == numberToAverageBy) {
            [newItems addObject:[NSNumber numberWithInt:average/numberToAverageBy]];
            i = 0;
            average = 0;
        }//end
        
    }//end for
    
    return [NSArray arrayWithArray:newItems];
    
}//end

@end