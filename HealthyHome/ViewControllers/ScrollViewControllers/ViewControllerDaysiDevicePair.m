

#import "ViewControllerDaysiDevicePair.h"
#import "CSNetAddressKeyboard.h"
#import "UserSettings.h"

#import "GlobalConfig.h"

@interface ViewControllerDaysiDevicePair ()

@end
#define MAXLENGTH 4

@implementation ViewControllerDaysiDevicePair
@synthesize strDeviceId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.UITextFieldDaysiDeviceAddress.inputView = [[CSNetAddressKeyboard alloc]
                                                   initWithTextField:self.UITextFieldDaysiDeviceAddress keyboardLayout:CSNetAddressKeyboardIPv6];
    self.UITextFieldDaysiDeviceAddress.delegate = self;

    self.UITextFieldDaysiDeviceAddress.text = self.strDeviceId;
    NSLog(@"Device Id is set to %@", self.UITextFieldDaysiDeviceAddress.text);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Keyboard Dismiss
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.UITextFieldDaysiDeviceAddress) {

        if (textField.text.length == 0)
        {
            textField.text = @"0000";
        }
        
        else if (textField.text.length < MAXLENGTH)
        {
            const unichar arrayChars[] = {'0'};
            NSString *preStr = [NSString stringWithCharacters:arrayChars length:MAXLENGTH - textField.text.length];
            textField.text  = [textField.text stringByAppendingString:preStr];
        }
        

        
     
        [textField resignFirstResponder];
    }
    

    return NO;
}

NSString *ZerosWithLength(int length)
{
    char UTF8Arr[length + 1];
    
    memset(UTF8Arr, '0', length * sizeof(*UTF8Arr));
    UTF8Arr[length] = '\0';
    
    return [NSString stringWithUTF8String:UTF8Arr];
}

-(void) resignKeyboard
{
    if (self.UITextFieldDaysiDeviceAddress.text.length == 0)
    {
        self.UITextFieldDaysiDeviceAddress.text = @"0000";
    }
    
    else if (self.UITextFieldDaysiDeviceAddress.text.length < MAXLENGTH)
    {

        NSString *preStr = ZerosWithLength((int)MAXLENGTH - (int)self.UITextFieldDaysiDeviceAddress.text.length);
        self.UITextFieldDaysiDeviceAddress.text  = [preStr stringByAppendingString:self.UITextFieldDaysiDeviceAddress.text];
    }
    
    [self.UITextFieldDaysiDeviceAddress resignFirstResponder];
    
    // Invoke the delegate to update the pairing Id being set here
    [self.delegate OnUpdateDevicePairId:self PairingId:self.UITextFieldDaysiDeviceAddress.text];

}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleBlack;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                //   [[UIBarButtonItem alloc]initWithTitle:@"A" style:UIBarButtonItemStyleBordered target:self action:@selector(addToField:)],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    
    textField.inputAccessoryView = keyboardToolBar;
    [self.delegate  OnEditingPairId:self];
    return 1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    long length = [textField.text length] ;
    if (length >= MAXLENGTH && ![string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:MAXLENGTH];
        return NO;
    }
    return YES;
}



@end
