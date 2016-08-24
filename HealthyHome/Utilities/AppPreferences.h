//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This file stores the Application preferences

#import <Foundation/Foundation.h>

@interface AppPreferences : NSObject

typedef enum {
    PressureUnit,
    AnalogAUnit,
    AnalogBUnit,
    
    // Keep Last
    KeyName_Size
} E_KeyName_T;







-(void) LoadConfiguration:(NSString *)key;
-(BOOL)SetValueForKey:(NSString *)key;
-(BOOL) KeyExists:(NSString *)key;


@property (nonatomic, strong) NSString * m_PressureUnits_Dep;


@end
