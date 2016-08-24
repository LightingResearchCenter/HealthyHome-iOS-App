//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This file implements the scroll view Controller for the Temperature Data view



#import "ViewControllerTemperatureData.h"
#import "TestFlight.h"
#import "SledUserSettings.h"

@interface ViewControllerTemperatureData ()

@end

@implementation ViewControllerTemperatureData

DataPoint *temperatureData;
@synthesize pTemperatureDataSledProtocol;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ButtonHoldPressed:(id)sender {
    
    NSString *tempUnitSymbol = [SledUserSettings GetTemperatureUnitSymbol];
    self.LabelHold.text = [NSString stringWithFormat:@"%04.1f %@", [SledUserSettings ConvertTempToUserUnits: [temperatureData GetCurrent] ], tempUnitSymbol];
    [temperatureData SetHold:[temperatureData GetCurrent]];
        [TestFlight passCheckpoint:@"Checkpoint - Temperature Hold"]; 
}

- (IBAction)ButtonResetPressed:(id)sender {
    [temperatureData ResetStats];
    [TestFlight passCheckpoint:@"Checkpoint - Temperature Reset"]; 
}

-(void)update:(DataPoint *)myTemp
{ 
   
    temperatureData = myTemp;
    NSString *tempUnitSymbol = [SledUserSettings GetTemperatureUnitSymbol];

    if (pTemperatureDataSledProtocol.temperatureStatus == 1)
    {
        self.LabelMax.text = [NSString stringWithFormat:@"%04.1f %@", [SledUserSettings ConvertTempToUserUnits: myTemp.GetMaximum ], tempUnitSymbol];
        self.LabelAverage.text = [NSString stringWithFormat:@"%04.1f %@",  [SledUserSettings ConvertTempToUserUnits: myTemp.GetAverage], tempUnitSymbol];
        self.LabelMin.text = [NSString stringWithFormat:@"%04.1f %@",  [SledUserSettings ConvertTempToUserUnits:myTemp.GetMinimum], tempUnitSymbol];
        self.LabelHold .text = [NSString stringWithFormat:@"%04.1f %@",  [SledUserSettings ConvertTempToUserUnits:myTemp.GetHold], tempUnitSymbol];
    }
    else
    {
        self.LabelMax.text = [NSString stringWithFormat:@"--.--" ];
        self.LabelAverage.text = [NSString stringWithFormat:@"--.--"];
        self.LabelMin.text = [NSString stringWithFormat:@"--.--"];
        self.LabelHold .text = [NSString stringWithFormat:@"--.--"];
    }
 
    
}
- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
