//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a StopWatch

#import <UIKit/UIKit.h>

@interface StopWatch : UIView
{

    
    
}

@property (readonly) BOOL running;

-(void) Start;
-(void) Stop;
-(void) Reset;
-(NSString *)GetElapsedTime;

@end
