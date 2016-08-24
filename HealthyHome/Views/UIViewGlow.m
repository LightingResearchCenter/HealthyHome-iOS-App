//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit is implements a view that makes it's contents glow

#import "UIViewGlow.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCategories.h"

#define TRIANGLE_WIDTH (15)
#define TRIANGLE_HEIGHT (15)
#define TRIANGLE_POSITION (15)

#define GLOW_VIEW_RADIUS  (5.0f)
#define GLOW_VIEW_OPACITY (1.00f)

@implementation UIViewGlow
@synthesize showDownArrow;
@synthesize glow;

-(void)SetGlowEffect: (Boolean)state
{
    self.layer.shadowRadius = state == YES?GLOW_VIEW_RADIUS:0;
}

- (id)initWithFrame:(CGRect)frame SetGlow:(Boolean)glow
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.userInteractionEnabled = NO;
        UIColor *myDarkOrangeColor = [UIColor orangeColor];
        
        self.layer.shadowColor = myDarkOrangeColor.CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = GLOW_VIEW_RADIUS;
        self.layer.shadowOpacity = GLOW_VIEW_OPACITY;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) awakeFromNib
{
    // Initial values
    UIColor *myDarkOrangeColor = [UIColor CustomOrangeColor];

    self.layer.shadowColor = myDarkOrangeColor.CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = GLOW_VIEW_RADIUS;
    self.layer.shadowOpacity = GLOW_VIEW_OPACITY;
    self.backgroundColor = [UIColor clearColor];
}

- (void) setGlow:(Boolean)glow
{
    
    
}
-(void) drawRect:(CGRect)rect
{
    
    if (showDownArrow == YES){
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        int triangle_origin_X = self.frame.size.width - TRIANGLE_POSITION;
        int triangle_origin_Y = self.frame.size.height - TRIANGLE_POSITION;
        
        //// Shadow Declarations
        UIColor* shadow = [UIColor blackColor];
        CGSize shadowOffset = CGSizeMake(3.1, 2.1);
        CGFloat shadowBlurRadius = 5;
        
        //// Polygon Drawing
        UIBezierPath* polygonPath = [UIBezierPath bezierPath];

        
        [polygonPath moveToPoint: CGPointMake(triangle_origin_X, triangle_origin_Y)];
        [polygonPath addLineToPoint: CGPointMake(triangle_origin_X +TRIANGLE_WIDTH, triangle_origin_Y+0)];
        [polygonPath addLineToPoint: CGPointMake(triangle_origin_X +(TRIANGLE_WIDTH/2), triangle_origin_Y+(TRIANGLE_HEIGHT/2))];
        [polygonPath addLineToPoint: CGPointMake(triangle_origin_X , triangle_origin_Y)];
        
        
        [polygonPath closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [[UIColor orangeColor] setFill];
        [polygonPath fill];
        CGContextRestoreGState(context);
    }

 
    
}

@end
