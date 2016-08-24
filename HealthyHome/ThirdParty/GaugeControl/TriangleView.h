//
//  trangleView.h
//  GaugeWithNewTicks
//
//  Created by macbookpro on 2/25/13.
//  Copyright (c) 2013 Rajeev Bhalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomGaugeControl.h"
@class  CustomGaugeControl;
@interface TriangleView : UIView{
    CustomGaugeControl * _gaugeView;
}
-(void)setParent:(CustomGaugeControl*)gauge;
@end
