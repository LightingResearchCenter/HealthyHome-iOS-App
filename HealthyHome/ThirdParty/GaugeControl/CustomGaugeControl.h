//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This is the implementation file for the Custom Gauge Control Component

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TickView.h"
#import "TriangleView.h"
#import "tick_view_config.h"
@class TriangleView;
@class TickView;
@interface CustomGaugeControl : UIView{
    CGFloat _viewHeight;
    TickView * _tickView;
    TriangleView * _triangleView;
}
- (CGFloat)arcHeight;
- (CGPoint)arcCenterPt;
- (CGFloat)halfArcAngle;
- (CGGradientRef)gradientWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor;
- (CGPoint)positionFromAngle:(CGFloat)angle forRadius:(CGFloat)radius;
- (CGFloat)angleFromValue:(NSInteger)value;
- (CGFloat)angleFromValueForTick:(NSInteger)value;
@property (nonatomic)  CGFloat viewHeight;
@property (nonatomic,retain) TickView * tickView;
@property NSInteger minValue;
@property NSInteger maxValue;
@property NSInteger trianglePosition;
@property (nonatomic, strong) UIColor *triangleColor;
@property BOOL triangleVisible;
@property NSInteger leftTickValue;
@property (nonatomic, strong) UIColor *leftTickColor;
@property NSInteger rightTickValue;
@property (nonatomic, strong) UIColor *rightTickColor;
@property NSInteger currentValue;
@property (nonatomic, strong) UIColor *leftGradientStartColor;
@property (nonatomic, strong) UIColor *leftGradientEndColor;
@property (nonatomic, strong) UIColor *rightGradientStartColor;
@property (nonatomic, strong) UIColor *rightGradientEndColor;

@end
