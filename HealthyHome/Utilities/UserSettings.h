//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This is the header file for the module for Storing the User Settings

#import <Foundation/Foundation.h>
#include "AppPreferences.h"


#define kUserProfileAge (@"UserProfileAge")
#define kUserProfileGender (@"UserProfileGender")

#define kUserProfileNormalSleepAtTime (@"UserProfileNormalSleepAtTime")
#define kUserProfileNormalWakeAtTime (@"UserProfileNormalWakeAtTime")
//#define kUserProfileTargetSleepAtTime (@"UserProfileTargetSleepAtTime")
//#define kUserProfileTargetWakeAtTime (@"UserProfileTargetWakeAtTime")


#define kUserProfileTargetDays (@"UserProfileTargetDays")
#define kUserProfileNormallyWorkAt (@"UserProfileNormallyWorkAt")

#define kDaysiMotionId (@"UserProfileDaysiMotionId")
#define kDaysiLightId (@"UserProfileDaysiLightId")
#define kDaysiControlHubId (@"UserProfileControlHubId")
#define kCalibrationStrId (@"CalibrationStringId")
#define kDaysiLightBootCountStrId (@"DaysiLightBootCountStringId")
#define kDaysiMotionBootCountStrId (@"DaysiMotionBootCountStringId")
@interface UserSettings : NSObject


+(NSString *)ReadValueForKey:(NSString *)keyStr;
+(void)WriteValue: (NSString*)valueStr ForKey:(NSString *)keyStr;
+(void)WriteArray: (NSMutableArray *)myArray ForKey:(NSString *)keyStr;
+(NSArray *)ReadArrayForKey:(NSString *)keyStr;





+(NSString *)GetProfileDateOfBirth;
+(void)SetProfileDateOfBirth:(NSString *)myValue;
+(int )GetProfileAge;

+(NSString *)GetProfileGender;
+(void)SetProfileGender:(NSString *)myValue;

+(float)GetProfileNormalSleepAt;
+(void)SetProfileNormalSleepAt:(float)myValue;

+(float)GetProfileNormalWakeAt;
+(void)SetProfileNormalWakeAt:(float)myValue;


+(int)GetProfileTargetDays;
+(void)SetProfileTargetDays:(int)myValue;

+(int)GetProfileNormallyWorkAt;
+(void)SetProfileNormallyWorkAt:(int)myValue;

+(NSString *)GetDaysiMotionId;
+(void)SetDaysiMotionId:(NSString *)myValue;

+(NSString *)GetDaysiLightId;
+(void)SetDaysiLightId:(NSString *)myValue;

+(NSString *)GetControlHubId;
+(void)SetControlHubId:(NSString *)myValue;

+(NSString *)GetCalibrationStr;
+(void)SetCalibrationStr:(NSString *)myValue;



+(int)GetDaysiLightBootCount;
+(void)SetDaysiLightBootCount:(int)myValue;
+(int)GetDaysiMotionBootCount;
+(void)SetDaysiMotionBootCount:(int)myValue;

@end
