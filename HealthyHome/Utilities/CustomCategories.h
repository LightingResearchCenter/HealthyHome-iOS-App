//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements custom categories


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>

#ifndef __CUSTOMCATEGORIES_H
#define __CUSTOMCATEGORIES_H

@interface NSObject (CustomCategories)

@end

@interface UIView (MyUIViewCategory)

+ (CGPoint )BottomRight;

@end

@interface UIColor (MyCategory)

+ (UIColor *)CustomOrangeColor;
+ (UIColor *)CustomGreenColor;

@end


    
@interface UIButton (ColoredBackground)

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

@interface CBUUID (StringExtraction)

- (NSString *)representativeString;

@end

#pragma mark - String Conversion
@interface NSData (NSData_Conversion)

- (NSString *)hexadecimalString;

@end

@interface NSDate (FriendlyStrings)
+ (NSString *)FriendlyTimeBetweenTwoDates:(NSDate *)oldDate NewDate:(NSDate *)newDate ThresholdSeconds:(int)nowThresholdInSeconds;
+ (NSString *)ElapsedTimeBetweenTwoDates:(NSDate *)oldDate NewDate:(NSDate *)newDate ThresholdSeconds:(int)nowThresholdInSeconds;

@end

#endif