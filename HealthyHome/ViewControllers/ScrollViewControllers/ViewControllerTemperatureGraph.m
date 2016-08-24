//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This file implements the scroll view Controller for the Temperature Graph view


#import "ViewControllerTemperatureGraph.h"

@interface ViewControllerTemperatureGraph ()

@end

@implementation ViewControllerTemperatureGraph

DataPoint *myDataPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Configure the plotter strip
    // ... This strip has high/low limits specified
    _plotStripTemperature.lowerLimit = -10.0f;
    _plotStripTemperature.upperLimit = 50.0f;
    _plotStripTemperature.capacity = 100;
    _plotStripTemperature.backgroundColor = [UIColor blackColor];
    _plotStripTemperature.lineColor = [UIColor whiteColor];
    _plotStripTemperature.showDot = YES;

    _plotStripTemperature.labelFormat = @"Temperature Trend";

    _plotStripTemperature.label = _UILabelPlotStrip;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)update:(DataPoint *)temp
{
    myDataPoint = temp;
    _plotStripTemperature.value = [myDataPoint GetCurrent];
    
}

@end
