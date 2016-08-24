//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  Implements a Custom Gauge View that shows value in various units

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "UIViewGlow.h"
#import "StopWatch.h"

@interface ViewRaptorGauge : UIView <RNGridMenuDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UILabel *UILabelPressureValue;
@property (strong, nonatomic) IBOutlet UILabel *UILabelPressureUnit;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageViewInsideBezel;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageViewOutsideRing;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageViewTickCurrentPressure;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageViewPressureColorRing;
@property (strong, nonatomic) IBOutlet UIView *UIViewMain;
@property (strong, nonatomic) IBOutlet UIViewGlow *UIViewGlowButton;
@property (strong, nonatomic) IBOutlet UIImageView *UIImageViewTickMaxPressure;
@property bool blinkText;  // Gauge will blink text when set
@property (strong, nonatomic) IBOutlet StopWatch *UIViewStopWatch;

- (void) SetGaugeWithOuterRing:(BOOL)outerRingVisible
                          innerRing:(BOOL)innerRingVisible
                      colorGradient:(BOOL)colorGradientVisible
                           tickMark:(BOOL)tickMarkVisible
                      pressureValue:(BOOL)pressureValueVisible
                       pressureUnit:(BOOL)pressureUnitVisible
;
- (IBAction)UIButtonPressureUnitPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *UIButtonPressureUnit;

-(void)SetGaugeToValueInPSI: (int)currentValue PressureUnit:(NSString *)UnitString PeakValue:(int)peakValue BlinkText:(bool)blinkState;
-(void)SetGaugeToString: (NSString *)myStr;
-(void)StartAnimation:(int)seconds;
-(void) SetPressureTextColor:(UIColor *)pColor;

@end
