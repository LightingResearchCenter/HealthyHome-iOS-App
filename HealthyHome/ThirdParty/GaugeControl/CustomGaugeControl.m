//
//  CustomGuageControl.m
//  gaugeControl
//
//  Created by macbookpro on 1/24/13.
//  Copyright (c) 2013 macbookpro. All rights reserved.
//

#import "CustomGaugeControl.h"
#import "CustomGaugeControlConfig.h"


#define PI 3.141592
@implementation CustomGaugeControl
@synthesize viewHeight = _viewHeight;
@synthesize tickView = _tickView;
@synthesize minValue = _minValue, maxValue = _maxValue;
@synthesize trianglePosition = _trianglePosition, triangleColor = _triangleColor, triangleVisible = _triangleVisible;
@synthesize leftTickValue = _leftTickValue, leftTickColor = _leftTickColor;
@synthesize rightTickValue = _rightTickValue, rightTickColor = _rightTickColor;
@synthesize currentValue = _currentValue;
@synthesize leftGradientStartColor = _leftGradientStartColor, leftGradientEndColor = _leftGradientEndColor;
@synthesize rightGradientStartColor = _rightGradientStartColor, rightGradientEndColor = _rightGradientEndColor;

- (void)initializeValues
{
    _minValue = 0;
    _maxValue = 100;
    
    _tickView = [[TickView alloc]init];
    [_tickView setBackgroundColor:[UIColor clearColor]];
    [self.superview addSubview:_tickView];
    _triangleView = [[TriangleView alloc]init];
    [_triangleView setBackgroundColor:[UIColor clearColor]];
    [self.superview addSubview:_triangleView];

    [_tickView setParent:self];
    _trianglePosition = _minValue + (_maxValue - _minValue) / 6;
    _triangleColor = [UIColor blackColor];
    _triangleVisible = YES;
    
    UIColor *myDarkOrangeColor = [[UIColor alloc]initWithRed:235.0/255.0 green:77.0/255.0 blue:0.0/255.0 alpha:1];

    _leftTickValue = _minValue + (_maxValue - _minValue) * 0.1f;
    _leftTickColor = myDarkOrangeColor;
    
    _rightTickValue = _minValue + (_maxValue - _minValue) * 0.99f;
    
    _rightTickColor = myDarkOrangeColor;
    
    _currentValue = _minValue + (_maxValue - _minValue) * 0.3f;
    
    _leftGradientStartColor = [UIColor colorWithWhite:0.9f alpha:1.0f];

    CGFloat nRed=248.0/255.0;
    CGFloat nBlue=192.0/255.0;
    CGFloat nGreen=0.0/255.0;
    UIColor *myOrangeColor=[[UIColor alloc]initWithRed:nRed green:nBlue blue:nGreen alpha:1];
   _leftGradientEndColor = myOrangeColor;
    
     // Dark Grey
    _rightGradientStartColor = [[UIColor alloc]initWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1];;
    _rightGradientEndColor  = [[UIColor alloc]initWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self initializeValues];
}

- (NSInteger)minValue
{
    return _minValue;
}

- (void)setMinValue:(NSInteger)minValue
{
    if (_minValue == minValue) return;
    _minValue = minValue;
    [self setNeedsDisplay];
}

- (NSInteger)maxValue
{
    return _maxValue;
}

- (void)setMaxValue:(NSInteger)maxValue
{
    if (_maxValue == maxValue) return;
    _maxValue = maxValue;
    [self setNeedsDisplay];
}

- (NSInteger)trianglePosition
{
    return _trianglePosition;
}

- (void)setTrianglePosition:(NSInteger)trianglePosition
{
    if (_trianglePosition == trianglePosition) return;
    _trianglePosition = trianglePosition;
    [self setNeedsDisplay];
}

- (UIColor *)triangleColor
{
    return _triangleColor;
}

- (void)setTriangleColor:(UIColor *)triangleColor
{
    _triangleColor = triangleColor;
    [self setNeedsDisplay];
}

- (BOOL)triangleVisible
{
    return _triangleVisible;
}

- (void)setTriangleVisible:(BOOL)triangleVisible
{
    if (_triangleVisible == triangleVisible) return;
    _triangleVisible = triangleVisible;
    [self setNeedsDisplay];
}

- (NSInteger)leftTickValue
{
    return _leftTickValue;
}

- (void)setLeftTickValue:(NSInteger)leftTickValue
{
    if (_leftTickValue == leftTickValue) return;
    _leftTickValue = leftTickValue;
    [self setNeedsDisplay];
}

- (UIColor *)leftTickColor
{
    return _leftTickColor;
}

- (void)setLeftTickColor:(UIColor *)leftTickColor
{
    _leftTickColor = leftTickColor;
    [self setNeedsDisplay];
}

- (NSInteger)rightTickValue
{
    return _rightTickValue;
}

- (void)setRightTickValue:(NSInteger)rightTickValue
{
    if (_rightTickValue == rightTickValue) return;
    _rightTickValue = rightTickValue;
    [self setNeedsDisplay];
}

- (UIColor *)rightTickColor
{
    return _rightTickColor;
}

- (void)setRightTickColor:(UIColor *)rightTickColor
{
    _rightTickColor = rightTickColor;
    [self setNeedsDisplay];
}

- (NSInteger)currentValue
{
    return _currentValue;
}

- (void)setCurrentValue:(NSInteger)currentValue
{
    if (_currentValue == currentValue) return;
    _currentValue = currentValue;
    [self setNeedsDisplay];
}

- (UIColor *)leftGradientStartColor
{
    return _leftGradientStartColor;
}

- (void)setLeftGradientStartColor:(UIColor *)leftGradientStartColor
{
    _leftGradientStartColor = leftGradientStartColor;
    [self setNeedsDisplay];
}

- (UIColor *)leftGradientEndColor
{
    return _leftGradientEndColor;
}

- (void)setLeftGradientEndColor:(UIColor *)leftGradientEndColor
{
    _leftGradientEndColor = leftGradientEndColor;
    [self setNeedsDisplay];
}

- (UIColor *)rightGradientStartColor
{
    return _rightGradientStartColor;
}

- (void)setRightGradientStartColor:(UIColor *)rightGradientStartColor
{
    _rightGradientStartColor = rightGradientStartColor;
    [self setNeedsDisplay];
}

- (UIColor *)rightGradientEndColor
{
    return _rightGradientEndColor;
}

- (void)setRightGradientEndColor:(UIColor *)rightGradientEndColor
{
    _rightGradientEndColor = rightGradientEndColor;
    [self setNeedsDisplay];
}

//  this function calculates the vertical height of of the upper arc from the bottom of the guage view, it is the minimun of the two values in the parametres i.e if the view height is very small then the arc height is selected to be its half, or if its large enough then the arc height is fixed to 20 irrespective of the actual view height
- (CGFloat)arcHeight
{
    return MIN(30, _viewHeight / 1.5);
}

//  this function calculates the center of the circle of which the arc is a part of, the x component is simply the half of the total width of the guage view (as teh arc touches both the left and right ends of the gauge view), the formula y = (l * l) / (2 * k) + (k / 2) for the y component can be simply derived using trigonometric techniques (derivation will be provided in a separate document)
- (CGPoint)arcCenterPt
{
    CGFloat k = _viewHeight - [self arcHeight];
    CGFloat l = self.frame.size.width / 2;
    
    CGFloat x = l;
    CGFloat y = (l * l) / (2 * k) + (k / 2);
    
    return CGPointMake(x, y);
}

//  this function calculates the  half of the total angle of the arc. the formula atan(x / y) can be simply derived using trigonometric techniques (derivation will be provided in a separate document).the maximum of 0 and the calculated angle is taken to avoid negative angles
- (CGFloat)halfArcAngle
{
    CGFloat x = self.frame.size.width / 2;
    CGFloat y = [self arcCenterPt].y - (_viewHeight - [self arcHeight]);
    return MAX(0, atan(x / y));
}

//  this function returns a gradient on the basis of a start and end color. A gradient defines a smooth transition between colors across an area. The CGGradientRef opaque type, and the functions that operate on it, are used to creat radial and axial gradient fills
- (CGGradientRef)gradientWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor
{
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int numberOfStartColorComponents = CGColorGetNumberOfComponents(startColor.CGColor);
    int numberOfEndColorComponents = CGColorGetNumberOfComponents(endColor.CGColor);
    float *startColorComponents = (float *)CGColorGetComponents(startColor.CGColor);
    float *endColorComponents = (float *)CGColorGetComponents(endColor.CGColor);
    
    CGFloat colors[8];
    
    // color components can be 2 or 4
    int index;
    for (int i = 0; i < 4; i ++) {
        
        index = MAX(0, (i + numberOfStartColorComponents - 4));
        colors[i] = startColorComponents[index];
        index = MAX(0, (i + numberOfEndColorComponents - 4));
        colors[i + 4] = endColorComponents[index];
    }
    
    gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

//  this function calculates the  point (in terms of x and y) on an arc of some radius for a given angle.the formulas for finding the x and y can be simply derived using trigonometric techniques (derivation will be provided in a separate document).

- (CGPoint)positionFromAngle:(CGFloat)angle forRadius:(CGFloat)radius
{
    CGFloat halfArcAngle = [self halfArcAngle];
    
    CGPoint pt;
    pt.x = self.frame.size.width / 2 + radius * sinf(angle - halfArcAngle);
    pt.y = radius - radius * cosf(angle - halfArcAngle);
    
    return pt;
}

//  this function does exactly the opposite of what the previous function does i.e it calculates the angle subtended by a point on the arc of a specific radius according to the value of the slider. The formula for finding angle can be simply derived using trigonometric techniques (derivation will be provided in a separate document).
- (CGFloat)angleFromValue:(NSInteger)value
{
    CGFloat halfArcAngle = [self halfArcAngle];
    return halfArcAngle * 2 * (value - self.minValue) / (self.maxValue - self.minValue);
}
- (CGFloat)angleFromValueForTick:(NSInteger)value
{
    CGFloat halfArcAngle = [self halfArcAngle];
        return halfArcAngle * (value - 50) / 50;
}

// overriding drawRect method to perform custom drawing.

- (void)drawRect:(CGRect)rect
{
    _viewHeight = MIN(146,self.bounds.size.height);
    _tickView.frame =  CGRectMake(self.frame.origin.x-(k_horizontalOffsetForTickView), self.frame.origin.y-k_verticalOffsetForTickView, self.frame.size.width+(2*k_horizontalOffsetForTickView), self.frame.size.height+2*k_verticalOffsetForTickView);
    
    _triangleView.frame =  CGRectMake(self.frame.origin.x-(k_horizontalOffsetForTriangleView), self.frame.origin.y-k_verticalOffsetForTriangleView, self.frame.size.width+(2*k_horizontalOffsetForTriangleView), self.frame.size.height+2*k_verticalOffsetForTriangleView);
    [_triangleView setParent:self];

    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGGradientRef gradient;
    CGPoint startPt, endPt; // temp variables for drawing gradient
    
    CGFloat halfArcAngle = [self halfArcAngle];
    CGPoint arcCenterPt = [self arcCenterPt];
    
    CGFloat longRadius = arcCenterPt.y;
    CGFloat shortRadius;
    
    if(_viewHeight<40){
        shortRadius = longRadius - [self arcHeight] / cosf(halfArcAngle);
    }
    
    else if (_viewHeight<140){
        shortRadius = (longRadius - [self arcHeight] / cosf(halfArcAngle)) + 5 + 2*_viewHeight/40;
        
        
    }
    else{
        shortRadius = (longRadius - [self arcHeight] / cosf(halfArcAngle)) + 5 + 2*140/40;
    }
    
    CGFloat leftArcAngle = [self angleFromValue:self.currentValue];
    
    CGPoint borderPt = [self positionFromAngle:leftArcAngle forRadius:longRadius];
    
    
    //  for a given arc center an arc is added (according to calculated angles) for the longer radius which is then filled witha linearly distributed gradient, both left and right arc gradients are made in this manner by varying the start and end angles (removing the gradient below the shorter radius is being taken care of at the end)
    
    //   NOTE: this drawRect method will be called every time an input is changed. you can see that "setNeedsDisplay" function is called at the end of setters function of all the inputs. This method ultimately calls the drawRect method.
    
    // fill left arc with gradient;
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, arcCenterPt.x, arcCenterPt.y);
    CGContextAddArc(context, arcCenterPt.x, arcCenterPt.y, longRadius, (-halfArcAngle - PI / 2), -halfArcAngle - PI / 2 + leftArcAngle, 0);
    CGContextAddLineToPoint(context, arcCenterPt.x, arcCenterPt.y);
    CGContextClip(context);
    
    gradient = [self gradientWithStartColor:self.leftGradientStartColor andEndColor:self.leftGradientEndColor];
    startPt = CGPointMake(0, _viewHeight - [self arcHeight]);
    endPt = borderPt;
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
    
    // fill right arc with gradient
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, arcCenterPt.x, arcCenterPt.y);
    CGContextAddArc(context, arcCenterPt.x, arcCenterPt.y, longRadius, -halfArcAngle - PI / 2 + leftArcAngle, halfArcAngle - PI / 2, 0);
    CGContextAddLineToPoint(context, arcCenterPt.x, arcCenterPt.y);
    CGContextClip(context);
    
    gradient = [self gradientWithStartColor:self.rightGradientStartColor andEndColor:self.rightGradientEndColor];
    startPt = borderPt;
    endPt = CGPointMake(self.frame.size.width, _viewHeight - [self arcHeight]);
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
    
    // draw left and right ticks
    [self setCoordinatesForLeftTick];
    [self setCoordinatesForRightTick];
   
    
    //// Text Drawing
    //// Shadow Declarations
    CGPoint leftTickTextPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue] forRadius:shortRadius];
    leftTickTextPoint.x = leftTickTextPoint.x;
    leftTickTextPoint.y = leftTickTextPoint.y+longRadius-shortRadius+k_verticalOffsetForTickView+k_minTextTextOffset;
    CGPoint rightTickTextPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue] forRadius:longRadius+k_verticalOffsetForTickView];
    [self.tickView setLeftTickTextPoint:leftTickTextPoint];
    [self.tickView setRightTickTextPoint:rightTickTextPoint];
    [self.tickView setLeftTickTextRotationAngle:halfArcAngle*(self.leftTickValue -k_sliderMidValue)/k_sliderMidValue ];
    [self.tickView setRightTickTextRotationAngle:halfArcAngle*(self.rightTickValue -k_sliderMidValue)/k_sliderMidValue ];
     [self.tickView setNeedsDisplay];
   
    // the triangle is basically drawn by using the arc center, longradius and the short radius to draw an arc and filling it with a the triangle color. But is is directed downwards i.e the pointy part is towards the top so that when truncated below the lower radius (at the end) it shows the triangle for the gauge. first the drop shadow is drawn in this manner and then the triangle
     [_triangleView setNeedsDisplay];

    
    
    // finally clear all unnecessary parts; now here all the extraneous drawing that is below the lower radius is filled with the same color as the background so that only the gauge (area between the sort and long radius) appears
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextMoveToPoint(context, arcCenterPt.x, arcCenterPt.y);
    
    CGContextAddArc(context, arcCenterPt.x, arcCenterPt.y, shortRadius,0, 2*
                    PI, 0);
    
    
    CGContextAddLineToPoint(context, arcCenterPt.x, arcCenterPt.y);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

// Drawing the bezier path for the left tick requires the path to move trought six points of the shape and then fill the drawn structure with orange color. Here these six points are calculated for a specific value of the slider using the predefined positionFromAngle and angleFromValue functions. Whenever the slider is moved the points are recalculated and the setNeedsDisplay function is called again to shift the tick to the new position according to the silder value.

-(void)setCoordinatesForLeftTick{
    CGFloat longRadius = [self arcCenterPt].y;
    CGFloat shortRadius;
    
    if(_viewHeight<40){
        shortRadius = longRadius - [self arcHeight] / cosf([self halfArcAngle]);
    }
    
    else if (_viewHeight<140){
        shortRadius = (longRadius - [self arcHeight] / cosf([self halfArcAngle])) + 5 + 2*_viewHeight/40;
        
        
    }
    else{
        shortRadius = (longRadius - [self arcHeight] / cosf([self halfArcAngle])) + 5 + 2*140/40;
    }

CGPoint sixthPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue+1] forRadius:shortRadius];
    sixthPoint.y = sixthPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius;
    sixthPoint.x = sixthPoint.x+k_horizontalOffsetForTickView;
CGPoint thirdPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue-1] forRadius:shortRadius];
    thirdPoint.y = thirdPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius;
    thirdPoint.x = thirdPoint.x+k_horizontalOffsetForTickView;
CGPoint firstPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue+1] forRadius:longRadius];
    firstPoint.y = firstPoint.y+k_verticalOffsetForTickView;
    firstPoint.x = firstPoint.x+k_horizontalOffsetForTickView;
CGPoint secondPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue-1] forRadius:longRadius];
    secondPoint.y = secondPoint.y+k_verticalOffsetForTickView;
    secondPoint.x = secondPoint.x+k_horizontalOffsetForTickView;
CGPoint fifthPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue+3] forRadius:shortRadius-5];
    fifthPoint.y = fifthPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius+5;
    fifthPoint.x = fifthPoint.x+k_horizontalOffsetForTickView;
CGPoint fourthPoint = [self positionFromAngle:[self angleFromValue:self.leftTickValue-3] forRadius:shortRadius-5];
    fourthPoint.y = fourthPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius+5;
    fourthPoint.x = fourthPoint.x+k_horizontalOffsetForTickView;
    [self.tickView setLeftTickCoordinates:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:firstPoint],[NSValue valueWithCGPoint:secondPoint],[NSValue valueWithCGPoint:thirdPoint],[NSValue valueWithCGPoint:fourthPoint],[NSValue valueWithCGPoint:fifthPoint],[NSValue valueWithCGPoint:sixthPoint],nil]];
    
}

// Drawing the bezier path for the right tick requires the path to move trought six points of the shape and then fill the drawn structure with black color. Here these six points are calculated for a specific value of the slider using the predefined positionFromAngle and angleFromValue functions. Whenever the slider is moved the points are recalculated and the setNeedsDisplay function is called again to shift the tick to the new position according to the silder value.
-(void)setCoordinatesForRightTick{
    CGFloat longRadius = [self arcCenterPt].y;
    CGFloat shortRadius;
    
    if(_viewHeight<40){
        shortRadius = longRadius - [self arcHeight] / cosf([self halfArcAngle]);
    }
    
    else if (_viewHeight<140){
        shortRadius = (longRadius - [self arcHeight] / cosf([self halfArcAngle])) + 5 + 2*_viewHeight/40;
        
        
    }
    else{
        shortRadius = (longRadius - [self arcHeight] / cosf([self halfArcAngle])) + 5 + 2*140/40;
    }
    CGPoint thirdPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue+1] forRadius:longRadius];
    thirdPoint.y = thirdPoint.y+k_verticalOffsetForTickView;
    thirdPoint.x = thirdPoint.x+k_horizontalOffsetForTickView;
    CGPoint sixthPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue-1] forRadius:longRadius];
    sixthPoint.y = sixthPoint.y+k_verticalOffsetForTickView;
    sixthPoint.x = sixthPoint.x+k_horizontalOffsetForTickView;
    CGPoint firstPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue-1] forRadius:shortRadius];
    firstPoint.y = firstPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius;
    firstPoint.x = firstPoint.x+k_horizontalOffsetForTickView;
    CGPoint secondPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue+1] forRadius:shortRadius];
    secondPoint.y = secondPoint.y+k_verticalOffsetForTickView+longRadius-shortRadius;
    secondPoint.x = secondPoint.x+k_horizontalOffsetForTickView;
    
    CGPoint fourthPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue+2] forRadius:longRadius+5];
    fourthPoint.y = fourthPoint.y+k_verticalOffsetForTickView-5;
    fourthPoint.x = fourthPoint.x+k_horizontalOffsetForTickView;
    CGPoint fifthPoint = [self positionFromAngle:[self angleFromValue:self.rightTickValue-2] forRadius:longRadius+5];
    fifthPoint.y = fifthPoint.y+k_verticalOffsetForTickView-5;
    fifthPoint.x = fifthPoint.x+k_horizontalOffsetForTickView;
    [self.tickView setRightTickCoordinates:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:firstPoint],[NSValue valueWithCGPoint:secondPoint],[NSValue valueWithCGPoint:thirdPoint],[NSValue valueWithCGPoint:fourthPoint],[NSValue valueWithCGPoint:fifthPoint],[NSValue valueWithCGPoint:sixthPoint],nil]];
}

@end
