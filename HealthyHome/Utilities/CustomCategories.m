//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit implements custom categories

#import "CustomCategories.h"

@implementation NSObject (CustomCategories)

@end


@implementation UIColor (MyCategory)

+ (UIColor *)CustomOrangeColor {
    UIColor *myDarkOrangeColor = [[UIColor alloc]initWithRed:245.0/255.0 green:142.0/255.0 blue:0.0/255.0 alpha:1];
    return myDarkOrangeColor;
}

+ (UIColor *)CustomGreenColor {
    UIColor *myDarkOrangeColor = [[UIColor alloc]initWithRed:74.0/255.0 green:162.0/255.0 blue:136.0/255.0 alpha:1];
    return myDarkOrangeColor;
}
@end


//@implementation CGRect (MyCGRectCategory)
//+ (CGPoint *)BottomRight {
//    CGPoint point = self.frame.origin;
//    point.x += self.bounds.size.width;
//    point.y += self.bounds.size.height;
//    return point;
//}

@implementation UIView (MyUIViewCategory)
+ (CGPoint )BottomRight {
   
    CGPoint myBottomRight = CGPointMake(0,0);
    return myBottomRight;
}

@end

@implementation UIButton(ColoredBackground)

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:self.frame];
    [tcv setBackgroundColor:backgroundColor];
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // set image as button's background image for the given state
    [self setBackgroundImage:image forState:state];
    UIGraphicsEndImageContext();
    
    // ensure rounded button
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8.0;
    
    
    
}
@end

@implementation CBUUID (StringExtraction)

- (NSString *)representativeString;
{
    NSData *data = [self data];
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity:16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
    {
        switch (currentByteIndex)
        {
            case 3:
            case 5:
            case 7:
            case 9:[outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]]; break;
            default:[outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
        }
        
    }
    
    return outputString;
}

@end

@implementation NSDate (FriendlyStrings)

+ (NSString *)FriendlyTimeBetweenTwoDates:(NSDate *)oldDate NewDate:(NSDate *)newDate ThresholdSeconds:(int)nowThresholdInSeconds
{
   NSString *myString = @"Unknown";
    
    NSTimeInterval elapsedTime = [newDate timeIntervalSinceDate:oldDate];
    
    if (elapsedTime < nowThresholdInSeconds)
    {
        myString = @"a few seconds";
    }
    
    else if (elapsedTime < 60)
    {
        myString = @"a minute";
    }
    
    else if (elapsedTime > 60 && elapsedTime < 3600)
    {
        int minutesElapsed = elapsedTime / 60;
        myString = (minutesElapsed ==1)?[NSString stringWithFormat:@"1 minute"]:[NSString stringWithFormat:@"%d minutes",minutesElapsed];
    }
    
    else if (elapsedTime > 3600 && elapsedTime < (24 *3600))
    {
        float hoursElapsed = elapsedTime / 3600;
        myString = (hoursElapsed ==1)?[NSString stringWithFormat:@"1 hr."]:[NSString stringWithFormat:@"%3.1f hrs.",hoursElapsed];
    }
    
    else if (elapsedTime > (24 * 3600) )
    {
        float daysElapsed = elapsedTime / (24 *3600);
        myString = (daysElapsed ==1)?[NSString stringWithFormat:@"1 day"]:[NSString stringWithFormat:@"%3.1f days",daysElapsed];
    }
 
   return myString;
    
}

+ (NSString *)ElapsedTimeBetweenTwoDates:(NSDate *)oldDate NewDate:(NSDate *)newDate ThresholdSeconds:(int)nowThresholdInSeconds
{
    NSString *myString = @"Unknown";
    
    NSTimeInterval elapsedTimeInSeconds = [newDate timeIntervalSinceDate:oldDate];
    
    if (elapsedTimeInSeconds < nowThresholdInSeconds)
    {
        myString = [NSString stringWithFormat:@"%d / %d",(int)elapsedTimeInSeconds, nowThresholdInSeconds] ;
    }
    
    else if (elapsedTimeInSeconds < 60)
    {
        myString = @"a minute";
    }
    
    else if (elapsedTimeInSeconds > 60 && elapsedTimeInSeconds < 3600)
    {
        int minutesElapsed = elapsedTimeInSeconds / 60;
        myString = (minutesElapsed ==1)?[NSString stringWithFormat:@"1 minute"]:[NSString stringWithFormat:@"%d minutes",minutesElapsed];
    }
    
    else if (elapsedTimeInSeconds > 3600 && elapsedTimeInSeconds < (24 *3600))
    {
        float hoursElapsed = elapsedTimeInSeconds / 3600;
        myString = (hoursElapsed ==1)?[NSString stringWithFormat:@"1 hr."]:[NSString stringWithFormat:@"%3.1f hrs.",hoursElapsed];
    }
    
    else if (elapsedTimeInSeconds > (24 * 3600) )
    {
        float daysElapsed = elapsedTimeInSeconds / (24 *3600);
        myString = (daysElapsed ==1)?[NSString stringWithFormat:@"1 day"]:[NSString stringWithFormat:@"%3.1f days",daysElapsed];
    }
    
    return myString;
    
}
@end



@implementation NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
//    //Check if the data contains ASCII encoded data - if so return that
//    NSString *dataStr;
//    dataStr = [[NSString alloc] initWithData:[self bytes] encoding:NSASCIIStringEncoding];
//    if (!dataStr)
//    {
//        NSLog(@"ASCII not working, will try utf-8!");
//        dataStr = [[NSString alloc] initWithData:[self bytes] encoding:NSUTF8StringEncoding];
//    }
//    
//    if (dataStr)
//    {
//        return dataStr;
//    }
    
    //If here we were unable to get a ASCII or UTF-8 encoded sring - give a Hexadecimal version of the string.
    NSUInteger  dataLength  = [self length];
    NSMutableString  *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    
    return [NSString stringWithString:hexString];
}


+ (NSString *)stringFromFloat:(CGFloat)n usingSeparatorForDecimal:(NSString *)separator {
    NSString *temp = [NSString stringWithFormat:@"%f", n];
    return [temp stringByReplacingOccurrencesOfString:@"." withString:separator];
}

@end

