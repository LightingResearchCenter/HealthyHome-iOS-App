//
//  TickView.h
//  GaugeWithNewTicks
//
//  Created by macbookpro on 2/20/13.
//  Copyright (c) 2013 Rajeev Bhalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tick_view_config.h"
#import "CustomGaugeControl.h"
@class  CustomGaugeControl;
@interface TickView : UIView{

    NSArray * _leftTickPointsArray;
    NSArray * _rightTickPointsArray;
    CGPoint _rightTickPoint;
    CGPoint _leftTickPoint;
    UILabel * _maxLabel;
    UILabel * _minLabel;
    CGFloat _leftTickTextRotationAngle;
    CGFloat _rightTickTextRotationAngle;
    CGPoint _leftTickTextPoint;
    CGPoint _rightTickTextPoint;
    UIImageView * _minLabelContainer;
    UIImageView * _maxLabelContainer;
    CustomGaugeControl * _gaugeView;
}
-(void)setParent:(CustomGaugeControl*)gauge;
-(void)setLeftTickCoordinates:(NSArray*)points;
-(void)setRightTickCoordinates:(NSArray*)points;
-(void)setLeftTickTextRotationAngle:(CGFloat)angle;
-(void)setRightTickTextRotationAngle:(CGFloat)angle;
-(void)setLeftTickTextPoint:(CGPoint)point;
-(void)setRightTickTextPoint:(CGPoint)point;
@end
