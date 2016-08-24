//
//  TickView.m
//  GaugeWithNewTicks
//
//  Created by macbookpro on 2/20/13.
//  Copyright (c) 2013 Rajeev Bhalla. All rights reserved.
//

#import "TickView.h"
#define PI 3.141592
@implementation TickView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _minLabelContainer = [[UIImageView alloc]initWithFrame:CGRectMake(_leftTickPoint.x, _leftTickPoint.y, k_textContentWidth, k_textContentHeight)];
    
        _minLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_textContentWidth, k_textContentHeight)];
        _minLabel.text = @"Min";
        _minLabel.backgroundColor = [UIColor clearColor];
        _minLabel.textAlignment = NSTextAlignmentCenter;
        _minLabel.font = [UIFont fontWithName: @"Helvetica" size: 12];
        _minLabel.textColor = [UIColor whiteColor];
        [_minLabelContainer addSubview:_minLabel];
        [self addSubview:_minLabelContainer];
        
        _maxLabelContainer = [[UIImageView alloc]initWithFrame:CGRectMake(_leftTickPoint.x, _leftTickPoint.y, k_textContentWidth, k_textContentHeight)];
        
        _maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_textContentWidth, k_textContentHeight)];
        _maxLabel.text = @"Max";
        _maxLabel.backgroundColor = [UIColor clearColor];
        _maxLabel.textAlignment = NSTextAlignmentCenter;
        _maxLabel.font = [UIFont fontWithName: @"Helvetica" size: 12];
        _maxLabel.textColor = [UIColor whiteColor];
        [_maxLabelContainer addSubview:_maxLabel];
        [self addSubview:_maxLabelContainer];

        return self;
    }
    return nil;
}
-(void)setParent:(CustomGaugeControl*)gauge{
    _gaugeView = gauge;
}

// Drawing the bezier path for the left tick requires the path to move trought six points of the shape and then fill the drawn structure with orange color. Whenever the slider is moved the points are recalculated and saved in the leftTickPointsArray, then the setNeedsDisplay function is called again to shift the tick to the new position according to the silder value.
// these points change whenever the left tick slider value is disturbed and this array is updated
-(void)setLeftTickCoordinates:(NSArray*)points{
    _leftTickPointsArray = points;
}

// Drawing the bezier path for the right tick requires the path to move trought six points of the shape and then fill the drawn structure with black color. Whenever the slider is moved the points are recalculated and saved in the rightTickPointsArray, then the setNeedsDisplay function is called again to shift the tick to the new position according to the silder value.
// these points change whenever the right tick slider value is disturbed and this array is updated
-(void)setRightTickCoordinates:(NSArray*)points{
    _rightTickPointsArray = points;
}


// This function sets the angle through which a transform needs to be given to the left tick Text to keep it parralel to the tangent at left tick point
-(void)setLeftTickTextRotationAngle:(CGFloat)angle{
    _leftTickTextRotationAngle=angle;
}

// This function sets the angle through which a transform needs to be given to the right tick Text to keep it parralel to the tangent at right tick point
-(void)setRightTickTextRotationAngle:(CGFloat)angle{
    _rightTickTextRotationAngle=angle;
}

// This function is to set the point where left tick text needs to be displayed
-(void)setLeftTickTextPoint:(CGPoint)point{
    _leftTickTextPoint=point;
}

// This function is to set the point where right tick text needs to be displayed
-(void)setRightTickTextPoint:(CGPoint)point{
    _rightTickTextPoint=point;
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor clearColor];
    CGSize shadowOffset = CGSizeMake(2.1, 1.1);
    CGFloat shadowBlurRadius = 5;
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];

    
    // The points from the left tick points array are used to draw the bezier path for the left tick
    [bezierPath moveToPoint: [[_leftTickPointsArray objectAtIndex:0]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:1]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:2]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:3]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:4]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:5]CGPointValue]];
        [bezierPath addLineToPoint: [[_leftTickPointsArray objectAtIndex:0]CGPointValue]];
    
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
     // the path is then filled with orange color
    [[UIColor orangeColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);

    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow2 = [UIColor clearColor];
    CGSize shadowOffset2 = CGSizeMake(2.1, 1.1);
    CGFloat shadowBlurRadius2 = 5;
    
    //// Bezier Drawing
    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];

    // The points from the right tick points array are used to draw the bezier path for the right tick
        [bezierPath2 moveToPoint: [[_rightTickPointsArray objectAtIndex:0]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:1]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:2]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:3]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:4]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:5]CGPointValue]];
        [bezierPath2 addLineToPoint: [[_rightTickPointsArray objectAtIndex:0]CGPointValue]];

    [bezierPath2 closePath];
    CGContextSaveGState(context2);
    CGContextSetShadowWithColor(context2, shadowOffset2, shadowBlurRadius2, shadow2.CGColor);
    
    // the path is then filled with black color
    [[UIColor orangeColor] setFill];
    [bezierPath2 fill];
    CGContextRestoreGState(context2);
    
    
    _minLabelContainer.center =CGPointMake(_leftTickTextPoint.x+k_horizontalOffsetForTickView, _leftTickTextPoint.y+k_verticalOffsetForMinText);
    _minLabelContainer.transform = CGAffineTransformMakeRotation(_leftTickTextRotationAngle );
    _maxLabelContainer.center =CGPointMake(_rightTickTextPoint.x+k_horizontalOffsetForTickView, _rightTickTextPoint.y-k_verticalOffsetForMaxText);
    _maxLabelContainer.transform = CGAffineTransformMakeRotation(_rightTickTextRotationAngle );

}
@end
