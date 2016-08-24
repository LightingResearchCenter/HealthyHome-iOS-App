//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This is a collection of Utility helper methods used by the App

#import "UserSettings.h"


@implementation UserSettings

const int k_DEFAULT_AGE = 45;
const float k_NORMAL_SLEEP_AT = 0.9;
const float k_NORMAL_WAKE_AT = 0.3;
const float k_TARGET_SLEEP_AT = 0.9;
const float k_TARGET_WAKE_AT = 0.3;
const int k_TARGET_NUMBER_OF_DAYS = 5;

const NSArray *arrayTempUnits;


+(void)WriteValue: (NSString*)valueStr ForKey:(NSString *)keyStr
{
    // get the handle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set the value
    [defaults setObject:valueStr forKey:keyStr];
    
    // save it
    [defaults synchronize];
}


+(void)WriteArray: (NSMutableArray *)myArray ForKey:(NSString *)keyStr
{
    // get the handle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set the value
    [defaults setObject:myArray forKey:keyStr];
    
    // save it
    [defaults synchronize];
    
}

+(NSString *)ReadValueForKey:(NSString *)keyStr
{
    // get the handle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Get the result
    NSString *retrievedValue = [defaults stringForKey:keyStr];
    
    return retrievedValue;
}


+(NSArray *)ReadArrayForKey:(NSString *)keyStr
{
    // get the handle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Get the result
    NSArray *retrievedValue = [defaults objectForKey:keyStr];
    
    return retrievedValue;
}

+(NSArray *) PressureUnits_Dep
{
    static NSArray *_PressureUnitArray;
    
    // This will only be true the first time the method is called...
    //
    if (_PressureUnitArray == nil)
    {
        _PressureUnitArray = [[NSArray alloc] initWithObjects: @"ATM", @"PSI", @"Bar", @"mmHG", nil];
    }
    
    return _PressureUnitArray;
    
}





#pragma -mark Setter/Getters

+(void)SetProfileDateOfBirth:(NSString *)myValue
{
    [UserSettings WriteValue:myValue ForKey:kUserProfileAge];
}


+(NSString *)GetProfileDateOfBirth
{
    NSString *strProfileAge = [UserSettings ReadValueForKey:kUserProfileAge];
    if (strProfileAge == nil)
    {
        return @"01/01/1986";
    }
    else
    {
        return(strProfileAge);
    }
    
}


+(int )GetProfileAge
{
    NSString *myDOB = [UserSettings GetProfileDateOfBirth];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm/dd/yyyy"];
    NSDate *dateOfBirth = [formatter dateFromString:myDOB];
    NSLog (@"DOB %@", dateOfBirth);
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    int age = (int)[ageComponents year];
    
    return age;
}

+(NSString *)GetProfileGender
{
    NSString *str = [UserSettings ReadValueForKey:kUserProfileGender];
    if (str == nil)
    {
        [self SetProfileGender:@"Male"];
        return @"Male";
        
    }
    else
    {
        return str;
    }
}

+(void)SetProfileGender:(NSString *)myValue
{
    [UserSettings WriteValue:myValue ForKey:kUserProfileGender];

}

+(float)GetProfileNormalSleepAt
{
    NSString *str = [UserSettings ReadValueForKey:kUserProfileNormalSleepAtTime];
    if (str == nil)
    {
        return k_NORMAL_SLEEP_AT;
    }
    else
    {
        return(str.floatValue);
    }

}


+(void)SetProfileNormalSleepAt:(float)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kUserProfileNormalSleepAtTime];
    
}

+(float)GetProfileNormalWakeAt
{
    NSString *str = [UserSettings ReadValueForKey:kUserProfileNormalWakeAtTime];
    if (str == nil)
    {
        return k_NORMAL_WAKE_AT;
    }
    else
    {
        return(str.floatValue);
    }
}

+(void)SetProfileNormalWakeAt:(float)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kUserProfileNormalWakeAtTime];
    
}

+(int)GetDaysiLightBootCount
{
    
    NSString *str = [UserSettings ReadValueForKey:kDaysiLightBootCountStrId];
    if (str == nil)
    {
        return 0;
    }
    else
    {
        return(str.intValue);
    }
    
}
+(void)SetDaysiLightBootCount:(int)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kDaysiLightBootCountStrId];
    
}

+(int)GetDaysiMotionBootCount
{
    
    NSString *str = [UserSettings ReadValueForKey:kDaysiMotionBootCountStrId];
    if (str == nil)
    {
        return 0;
    }
    else
    {
        return(str.intValue);
    }
    
}
+(void)SetDaysiMotionBootCount:(int)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kDaysiMotionBootCountStrId];
    
}

+(int)GetProfileTargetDays
{

    NSString *str = [UserSettings ReadValueForKey:kUserProfileTargetDays];
    if (str == nil)
    {
        return k_TARGET_NUMBER_OF_DAYS;
    }
    else
    {
        return(str.intValue);
    }

}
+(void)SetProfileTargetDays:(int)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kUserProfileTargetDays];

}

+(int)GetProfileNormallyWorkAt
{
    return([UserSettings ReadValueForKey:kUserProfileNormallyWorkAt].intValue);
 
}
+(void)SetProfileNormallyWorkAt:(int)myValue
{
    [UserSettings WriteValue:@(myValue).stringValue ForKey:kUserProfileNormallyWorkAt];

}

+(NSString *)GetDaysiMotionId
{
    NSString *str = [UserSettings ReadValueForKey:kDaysiMotionId];
    if (str == nil)
    {
      return @"0000";
        
    }
    return(str);

}
+(void)SetDaysiMotionId:(NSString *)myValue
{
    
    [UserSettings WriteValue:myValue ForKey:kDaysiMotionId];
    

}

+(NSString *)GetDaysiLightId
{
  
    NSString *str = [UserSettings ReadValueForKey:kDaysiLightId];
    if (str == nil)
    {
        return @"0000";
        
    }
    return(str);

}

+(void)SetDaysiLightId:(NSString *)myValue
{

    [UserSettings WriteValue:myValue ForKey:kDaysiLightId];
    

}

+(NSString *)GetControlHubId
{
    NSString *str = [UserSettings ReadValueForKey:kDaysiControlHubId];
    if (str == nil)
    {
        return @"3a5k-1554";
    }
    else
    {
        return(str);
    }
    
    return([UserSettings ReadValueForKey:kDaysiControlHubId]);
    
}

+(void)SetControlHubId:(NSString *)myValue
{
    [UserSettings WriteValue:myValue ForKey:kDaysiControlHubId];
    
}

+(NSString *)GetCalibrationStr
{
    NSString *str = [UserSettings ReadValueForKey:kCalibrationStrId];
    if (str == nil)
    {
        return @"0.000::0.000::0.000::0.000";
        
    }
    return(str);
    
}

+(void)SetCalibrationStr:(NSString *)myValue
{
    
    [UserSettings WriteValue:myValue ForKey:kCalibrationStrId];
    
    
}




@end
