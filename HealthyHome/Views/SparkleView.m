//
//  SparkleView.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 12/12/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "SparkleView.h"



@implementation SparkleView

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    float multiplier = 0.25f;
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    
    //Create the emitter layer
    emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = pt;
    emitter.emitterMode = kCAEmitterLayerOutline;
    emitter.emitterShape = kCAEmitterLayerCircle;
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterSize = CGSizeMake(100 * multiplier, 0);
    
    //Create the emitter cell
    CAEmitterCell* particle = [CAEmitterCell emitterCell];
    particle.emissionLongitude = M_PI;
    particle.birthRate = multiplier * 1000.0;
    particle.lifetime = multiplier;
    particle.lifetimeRange = multiplier * 0.35;
    particle.velocity = 180;
    particle.velocityRange = 130;
    particle.emissionRange = 1.1;
    particle.scaleSpeed = 1.0; // was 0.3
    particle.color = [[[UIColor redColor] colorWithAlphaComponent:0.5f] CGColor];
    particle.contents = (__bridge id)([UIImage imageNamed:@"sparkle.png"].CGImage);
    particle.name = @"particle";
    
    emitter.emitterCells = [NSArray arrayWithObject:particle];
    [self.layer addSublayer:emitter];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    
    // Disable implicit animations
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    emitter.emitterPosition = pt;
    [CATransaction commit];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [emitter removeFromSuperlayer];
    emitter = nil;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event]; }

@end
