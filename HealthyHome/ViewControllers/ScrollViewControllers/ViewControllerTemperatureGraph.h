//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This file implements the scroll view Controller for the Temperature Graph view



#import <UIKit/UIKit.h>
#import "F3PlotStrip.h"
#import "DataPoint.h"

@interface ViewControllerTemperatureGraph : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *UILabelPlotStrip;
-(void) update:(DataPoint *)temp;
@property (strong, nonatomic) IBOutlet F3PlotStrip *plotStripTemperature;

@end
