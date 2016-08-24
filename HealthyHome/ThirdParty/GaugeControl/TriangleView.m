//
//  trangleView.m
//  GaugeWithNewTicks
//
//  Created by macbookpro on 2/25/13.
//  Copyright (c) 2013 Rajeev Bhalla. All rights reserved.
//

#import "TriangleView.h"

#define PI 3.141592

@implementation TriangleView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
                
        return self;
    }
    return nil;
}
-(void)setParent:(CustomGaugeControl*)gauge{
    _gaugeView = gauge;
    [self setHidden:[gauge isHidden]];
    
}
-(void)drawRect:(CGRect)rect{
       CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat halfArcAngle = [_gaugeView halfArcAngle];
    CGPoint arcCenterPt = [_gaugeView arcCenterPt];
    arcCenterPt.x = arcCenterPt.x + k_horizontalOffsetForTriangleView;
    arcCenterPt.y = arcCenterPt.y + k_verticalOffsetForTriangleView;
    CGFloat longRadius = [_gaugeView arcCenterPt].y;
    CGFloat shortRadius;
    
    if(_gaugeView.viewHeight<40){
        shortRadius = longRadius - [_gaugeView arcHeight] / cosf(halfArcAngle);
    }
    
    else if (_gaugeView.viewHeight<140){
        shortRadius = (longRadius - [_gaugeView arcHeight] / cosf(halfArcAngle)) + 5 + 2*_gaugeView.viewHeight/40;
        
        
    }
    else{
        shortRadius = (longRadius - [_gaugeView arcHeight] / cosf(halfArcAngle)) + 5 + 2*140/40;
    }
    
    // draw drop shadow for triangle
    if (_gaugeView.triangleVisible) {
        
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] setFill];
        CGFloat triangleTopGap;
        if (_gaugeView.viewHeight<40){
            triangleTopGap = [_gaugeView arcHeight] / (_gaugeView.viewHeight/10);
            triangleTopGap = triangleTopGap+2;
        }
        else if(_gaugeView.viewHeight>=40&&_gaugeView.viewHeight<80){
            triangleTopGap = [_gaugeView arcHeight] / 4;
            triangleTopGap = triangleTopGap+5;
        }
        else{
            triangleTopGap = [_gaugeView arcHeight] / 2;
            triangleTopGap = triangleTopGap+10;
        }
        CGFloat triangleAngle = [_gaugeView angleFromValue:_gaugeView.trianglePosition];
        CGPoint trianglePt = [_gaugeView positionFromAngle:triangleAngle forRadius:longRadius - triangleTopGap];
        trianglePt.y += triangleTopGap;
        trianglePt.x = trianglePt.x + k_horizontalOffsetForTriangleView;
        trianglePt.y = trianglePt.y + k_verticalOffsetForTriangleView;
        CGFloat triangleStartAngle ;
        CGFloat triangleEndAngle;
        if(_gaugeView.viewHeight<40){
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *120/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *120/_gaugeView.viewHeight);
        }
        else if(_gaugeView.viewHeight>=40&&_gaugeView.viewHeight<80){
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *160/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *160/_gaugeView.viewHeight);
        }
        
        else{
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *200/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *200/_gaugeView.viewHeight);
        }
        CGContextMoveToPoint(context, trianglePt.x-k_horizontalOffsetForTriangleShadowView, trianglePt.y-k_verticalOffsetForTriangleShadowView);
        CGContextAddArc(context, trianglePt.x-k_horizontalOffsetForTriangleShadowView, trianglePt.y-k_verticalOffsetForTriangleShadowView, longRadius, triangleStartAngle, triangleEndAngle, 0);
        CGContextFillPath(context);
    }
    
    // draw triangle
    if (_gaugeView.triangleVisible) {
        
        [_gaugeView.triangleColor setFill];
        CGFloat triangleTopGap;
        if (_gaugeView.viewHeight<40){
            triangleTopGap = [_gaugeView arcHeight] / (_gaugeView.viewHeight/10);;
        }
        else if(_gaugeView.viewHeight>=40&&_gaugeView.viewHeight<80){
            triangleTopGap = [_gaugeView arcHeight] / 4;
        }
        else{
            triangleTopGap = [_gaugeView arcHeight] / 2;
        }
        CGFloat triangleAngle = [_gaugeView angleFromValue:_gaugeView
                                 .trianglePosition];
        CGPoint trianglePt = [_gaugeView positionFromAngle:triangleAngle forRadius:longRadius - triangleTopGap];
        trianglePt.y += triangleTopGap;
        trianglePt.x = trianglePt.x + k_horizontalOffsetForTriangleView;
        trianglePt.y = trianglePt.y + k_verticalOffsetForTriangleView;
        CGFloat triangleStartAngle ;
        CGFloat triangleEndAngle;
        if(_gaugeView.viewHeight<40){
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *120/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *120/_gaugeView.viewHeight);
        }
        else if(_gaugeView.viewHeight>=40&&_gaugeView.viewHeight<80){
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *160/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *160/_gaugeView.viewHeight);
        }
        
        else{
            triangleStartAngle = PI / 2 - (halfArcAngle - triangleAngle) - (0.1f *200/_gaugeView.viewHeight);
            triangleEndAngle = PI / 2 - (halfArcAngle - triangleAngle) + (0.1f *200/_gaugeView.viewHeight);
        }
        CGContextMoveToPoint(context, trianglePt.x, trianglePt.y);
        CGContextAddArc(context, trianglePt.x, trianglePt.y, longRadius, triangleStartAngle, triangleEndAngle, 0);
        CGContextFillPath(context);
    }
    
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextMoveToPoint(context, arcCenterPt.x, arcCenterPt.y);
    
    CGContextAddArc(context, arcCenterPt.x, arcCenterPt.y, shortRadius,0, 2*
                    PI, 0);
    
    
    CGContextAddLineToPoint(context, arcCenterPt.x, arcCenterPt.y
                            );
    CGContextFillPath(context);

}
@end
