//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  Implements a Custom Gauge View that create a control with rotating needle

#import "ViewRaptorGauge.h"
#import "GlobalConfig.h"
#import "RNGridMenu.h"
#import "URBSegmentedControl.h"
#import "UserSettings.h"

@implementation ViewRaptorGauge
NSTimer *timerTextBlink;                      // Timer to Blink Text
NSTimer *timerDismissUnitSlection;            // Timer to dismiss pressure unit selection
@synthesize blinkText;
URBSegmentedControl *controlPressureUnitSelect;  //Provides a control to select the Pressure Unit
CABasicAnimation *myWaitAnimation;



- (void) awakeFromNib
{
    // Create a UIView from the nib and bind it to self.contentView
    [[NSBundle mainBundle] loadNibNamed:@"ViewRaptorGauge" owner:self options:nil];
    
    [self addSubview:self.UIViewMain];
    
    //Remove the background color from UIViews and UImageViews that are added during the design time
    self.UIImageViewInsideBezel.backgroundColor = [UIColor clearColor];
    self.UIImageViewOutsideRing.backgroundColor = [UIColor clearColor];
    self.UIImageViewPressureColorRing.backgroundColor = [UIColor clearColor];
    self.UIImageViewTickCurrentPressure.backgroundColor = [UIColor clearColor];
    
    self.UIImageViewInsideBezel.alpha = 1.0;
    self.UIImageViewOutsideRing.alpha = 1.0;
    self.UIImageViewPressureColorRing.alpha = 1.0;
    self.UIImageViewTickCurrentPressure.alpha = 1.0;
    
    
    self.UIViewMain.backgroundColor = [UIColor clearColor];
    
    
    // Create a rotate animation that rotates the layer
    myWaitAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myWaitAnimation.fromValue = [NSNumber numberWithFloat:0];
    myWaitAnimation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    myWaitAnimation.duration = k_ANIMATION_RING_ROTATE_TIME_SECONDS;
    myWaitAnimation.repeatCount = 1;
    
    
    

    controlPressureUnitSelect = [[URBSegmentedControl alloc] initWithItems:[UserSettings PressureUnits]];
    [self.UIViewMain addSubview:controlPressureUnitSelect];
    
    // Set some placement parameters (Need to handle rotation)
    controlPressureUnitSelect.frame = CGRectMake(10,10,320,100);
    [controlPressureUnitSelect addTarget:self action:@selector(ControlPressureUnitChanged) forControlEvents:UIControlEventValueChanged];
    controlPressureUnitSelect.center = self.UIViewGlowButton.center;
    [controlPressureUnitSelect setHidden:true];
    //Todo Place the control just below the presssure select control
}

-(bool) blinkText
{
    return blinkText;
}

-(void) setBlinkText:(bool)state
{
    blinkText = state;
    if (state)
    {
        if (timerTextBlink == nil)
        {
            timerTextBlink =  [NSTimer scheduledTimerWithTimeInterval:.75/1.0
                                                               target:self
                                                             selector:@selector(timerBlinkTextTimeout)
                                                             userInfo:nil
                                                              repeats:YES];
            
        }
        
    }
    else
    {
        if (timerTextBlink != nil)
        {
            [timerTextBlink invalidate];
            timerTextBlink = nil;
            
        }
        
    }
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}




#pragma mark - Gauge UserInterface
-(void)SetMeritGaugeToValueInAngles: (int)currentValue MaxValue:(int)maxValue
{
    
    static int oldCurrentValue = 0;
    static int oldPeakValue = 0;
    
    
    CABasicAnimation *rotateCurrentPressureTick = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotateCurrentPressureTick setDelegate:self];
    rotateCurrentPressureTick.fromValue = [NSNumber numberWithFloat:oldCurrentValue/57.2958];
    rotateCurrentPressureTick.removedOnCompletion = NO;
    rotateCurrentPressureTick.fillMode = kCAFillModeForwards;
    rotateCurrentPressureTick.toValue = [NSNumber numberWithFloat:  currentValue/57.2958];
    rotateCurrentPressureTick.duration = 10.0; // seconds
    
    [self.UIImageViewTickCurrentPressure.layer addAnimation:rotateCurrentPressureTick forKey:@"rotateTick"]; // "key" is optional
    
    
    CABasicAnimation *rotateMaxPressureTick = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotateMaxPressureTick setDelegate:self];
    rotateMaxPressureTick.fromValue = [NSNumber numberWithFloat:oldPeakValue/57.2958];
    rotateMaxPressureTick.removedOnCompletion = NO;
    rotateMaxPressureTick.fillMode = kCAFillModeForwards;
    rotateMaxPressureTick.toValue = [NSNumber numberWithFloat:  maxValue/57.2958];
    rotateMaxPressureTick.duration = 10.0; // seconds
    
    [self.UIImageViewTickMaxPressure.layer addAnimation:rotateMaxPressureTick forKey:@"rotateMaxTick"]; // "key" is optional
    
    oldCurrentValue = currentValue;
    oldPeakValue = maxValue;
    
}





-(void)SetMeritGaugeToString: (NSString *)myStr
{
    self.UILabelPressureValue.text = myStr;
}

//The delegate method for the animation
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        NSLog(@"%@", @"The animation is finished. Do something here.");
    }
    
}

#pragma mark - GaugeAnimation
-(void) StartAnimation: (int)animationTimeSeconds
{
    [[self.UIImageViewOutsideRing layer] addAnimation:myWaitAnimation forKey:@"rotate360"];
    
}


- (void) SetMeritGaugeWithOuterRing:(BOOL)outerRingVisible
                          innerRing:(BOOL)innerRingVisible
                      colorGradient:(BOOL)colorGradientVisible
                           tickMark:(BOOL)tickMarkVisible
                      pressureValue:(BOOL)pressureValueVisible
                       pressureUnit:(BOOL)pressureUnitVisible




{
    [self.UIImageViewOutsideRing setHidden:!outerRingVisible];
    [self.UIImageViewInsideBezel setHidden:!innerRingVisible];
    [self.UIImageViewPressureColorRing setHidden:!colorGradientVisible];
    [self.UIImageViewTickCurrentPressure setHidden:!tickMarkVisible];
    [self.UIImageViewTickMaxPressure setHidden:!tickMarkVisible];
    [self.UILabelPressureUnit setHidden:!pressureUnitVisible];
    [self.UIButtonPressureUnit setHidden:!pressureUnitVisible];
    self.UIViewGlowButton.showDownArrow = false;
    [self.UIViewGlowButton setHidden: !pressureUnitVisible];


    if (pressureValueVisible == false)
    {
        self.blinkText = false;
    }

    if (self.blinkText == false)
    {
        [self.UILabelPressureValue setHidden:!pressureValueVisible];
    }
    
    
}

#pragma mark - ButtonPresses

- (IBAction)UIButtonPressureUnitPressed:(id)sender
{
    
    
#if k_FEATURE_GAUGE_ALLOWS_PRESSURE_UNIT_CHANGE
    [controlPressureUnitSelect setHidden:false];
    
    //Automatically dismiss the control after a set time
    timerDismissUnitSlection =  [NSTimer scheduledTimerWithTimeInterval:k_TIME_PRESSURE_UNIT_SELECTION_DISMISS_SECONDS
                                                                 target:self
                                                               selector:@selector(timerDismissPressureUnitSelection)
                                                               userInfo:nil
                                                                repeats:YES];
    
#endif
    
}


-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (popup.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


-(void) SetPressureTextColor:(UIColor*)pColor
{
    self.UILabelPressureValue.textColor = pColor;
}

#pragma mark - PressureUnitChanged
-(void) ControlPressureUnitChanged
{
    //Reload the timer when the user changes the pressure unit
    [timerDismissUnitSlection invalidate];
    timerDismissUnitSlection =  [NSTimer scheduledTimerWithTimeInterval:k_TIME_PRESSURE_UNIT_SELECTION_DISMISS_SECONDS
                                                                 target:self
                                                               selector:@selector(timerDismissPressureUnitSelection)
                                                               userInfo:nil
                                                                repeats:YES];
}

#pragma mark - Timers
-(void) timerBlinkTextTimeout
{
    static bool blinkState = 0;
    [self.UILabelPressureValue setHidden:blinkState];
    blinkState ^=1;
    
    
}


-(void) timerDismissPressureUnitSelection
{

    //Hide the control and invalidate the timer
    [controlPressureUnitSelect setHidden:true];
    [timerDismissUnitSlection invalidate];
    NSString *pStr = (NSString *)[[UserSettings PressureUnits] objectAtIndex:controlPressureUnitSelect.selectedSegmentIndex];
    NSLog(@"Item %d Value: %@", controlPressureUnitSelect.selectedSegmentIndex, pStr);
    [self.UIButtonPressureUnit setTitle:pStr forState:UIControlStateNormal];
}


@end
