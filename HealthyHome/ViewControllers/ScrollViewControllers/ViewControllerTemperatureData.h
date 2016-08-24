//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This file implements the scroll view Controller for the Temperature Data view


#import <UIKit/UIKit.h>
#import "DataPoint.h"
#include "protocolDemo1.h"

@interface ViewControllerTemperatureData : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *LabelMax;
@property (strong, nonatomic) IBOutlet UILabel *LabelMin;
@property (strong, nonatomic) IBOutlet UILabel *LabelAverage;
@property (strong, nonatomic) IBOutlet UILabel *LabelHold;

@property (strong, nonatomic) IBOutlet UIButton *ButtonHold;
@property (strong, nonatomic) IBOutlet UIButton *ButtonReset;
@property (strong, atomic) protocolDemo1 *pTemperatureDataSledProtocol;

- (IBAction)ButtonHoldPressed:(id)sender;
- (IBAction)ButtonResetPressed:(id)sender;
-(void) update:(DataPoint *)temp;
@end
