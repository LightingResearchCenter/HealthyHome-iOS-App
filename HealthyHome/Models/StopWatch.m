//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements a class for managing a entity for StopWatch

#import "StopWatch.h"

@implementation StopWatch

BOOL running;
NSString *mStrElapsedTime;
NSTimer *stopTimer;
NSDate *startDate;
@synthesize running;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        running = false;
        mStrElapsedTime = @"--:--";
        
    }
    return self;
}


-(void)viewDidLoad
{
    mStrElapsedTime = @"";
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    
    // Drawing Rect
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#ifdef XYZ
    // Draw a small line
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, 0,0); //start at this point
    
    CGContextAddLineToPoint(context, 20, 20); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
#endif
    
    
    CGContextSetShadow(context, CGSizeMake(5.0f, 5.0f), 10.0f);
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0);
    CGContextSetAllowsAntialiasing(context, true);
    
    [mStrElapsedTime drawAtPoint:CGPointMake(1.0f, 1.0f) withFont:[UIFont systemFontOfSize:65.0f]];
    // and now draw the Path!
    //CGContextStrokePath(context);
    
    
    
}

- (void) Start
{
    mStrElapsedTime = @"";
    NSLog (@"Started StopWatch");
    if (stopTimer == nil)
    {
        startDate = [NSDate date];
        stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
        running = true;
        
    }
    
}

- (void) Stop
{
    running = false;
    [stopTimer invalidate];
    stopTimer = nil;
    NSLog (@"Stopped StopWatch");
    
}

- (void) Reset
{
    startDate = [NSDate date];
}

-(void)updateTimer
{

    
    // Get the Current Time
    NSDate *currentDate = [NSDate date];
    
    //Calculate time Elapsed
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    //Format the time elapsed using a NSDateFormatter Object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    mStrElapsedTime = timeString;


    [self setNeedsDisplay];
}

-(NSString *)GetElapsedTime
{
    if (running)
    {
        return mStrElapsedTime;
    }
    else
    {
        return @"00:00";
    }
}

@end
