//
//  ViewControllerSelectDaysimeter.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/13/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerSelectDaysimeter.h"
#import "PeripheralCell.h"
#import "CustomCategories.h"

@interface ViewControllerSelectDaysimeter ()

@end

@implementation ViewControllerSelectDaysimeter
@synthesize myList;
int selectedRowIndex;

const int pickerFontSize = 50;

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
	// Do any additional setup after loading the view.
    long count = myList.count;
    
    _UILabelTitle.Text =  [NSString stringWithFormat:@"Please Select from %d", count];
    //UIPickerViewDaysimeter.delegate = self;
    [_UIButtonSelect setTitleColor:[UIColor CustomGreenColor]  forState:UIControlStateNormal];
    [_UIButtonCancel setTitleColor:[UIColor CustomGreenColor]  forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Handlers
- (IBAction)UIButtonCloseAction:(id)sender
{
    [self.delegate addItemViewController:self didFinishEnteringItem:selectedRowIndex];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)UIButtonCancelAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}



#pragma mark - PickerView Delegates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    selectedRowIndex = row;
    
}





// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return myList.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}



//// tell the picker the title for a given component
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSString *title;
//    PeripheralCell *myPeripheral = [myList objectAtIndex:row];
//    NSString *myStr = [myPeripheral.peripheralMacId hexadecimalString];
//    title = [myStr uppercaseString];
//
//    return title;
//}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 100)];
    
    if (component == 0) {
        
        PeripheralCell *myPeripheral = [myList objectAtIndex:row];
        NSString *strMacId = [[myPeripheral.peripheralMacId hexadecimalString] uppercaseString];
        // NSString *myStr = [NSString stringWithFormat:@"%@ (%3@)",strMacId, myPeripheral.rssi];
        
        label.font=[UIFont boldSystemFontOfSize:pickerFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        
        label.text = strMacId;
        
        
    }
    
    return label;
}




// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 400;
    
    return sectionWidth;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    int sectionHeight = pickerFontSize + 5;
    
    return sectionHeight;
}


@end
