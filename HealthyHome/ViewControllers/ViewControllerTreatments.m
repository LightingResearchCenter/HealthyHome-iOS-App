//
//  ViewControllerTreatments.m
//  Daysimeter
//
//  Created by RAJEEV BHALLA on 10/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerTreatments.h"
#include "DaysiUtilities.h"
#import "CircadianModelManager.h"
#import "M13BadgeView.h"

@interface ViewControllerTreatments ()

@end

@implementation ViewControllerTreatments


NSMutableArray *myTreatmentArray;
M13BadgeView *myBadge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

char * ConvertUnixTimeToString (long unixTime)
{
    static char buf[100];
    struct tm * timeInfo;
    time_t myTime;
    //Convert Treatment Time to a human readable format
    myTime = unixTime;
    timeInfo = localtime(&myTime);
    strftime(buf, sizeof(buf), "%a %y-%m-%d %H:%M", timeInfo);
    return buf;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButtonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    [DaysiUtilities SetLayerToGlow:self.UIImageViewTableFrame.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    //Set up a badge View
    myBadge = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 24.0, 24.0)];
    myBadge.verticalAlignment = M13BadgeViewVerticalAlignmentMiddle;
    myBadge.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
    myBadge.badgeBackgroundColor = [UIColor redColor];
    myBadge.borderWidth = 2.0;
    [self.UIImageVieMortalPestle addSubview:myBadge];
    
    
    
    //Setup the data source and delegate for the UITableView to self
    self.UITableViewTreatments.delegate = self;
    self.UITableViewTreatments.dataSource   = self;
    
    myTreatmentArray = [[NSMutableArray alloc]init];
    
    int errorCode = [_ciracdianManager GetLastStatus];
    
    if (errorCode == ERROR_CODE_NONE)
    {
        
        [self.UILabelErrorCode setHidden:true];
        [self.UITableViewTreatments setHidden:false];
        TREATMENT_T *treatments = [_ciracdianManager GetTreatments];
        
        if (treatments->count == 0)
        {
            [self.UILabelErrorCode setHidden:false];
            [self.UITableViewTreatments setHidden:true];
            self.UILabelErrorCode.text = [NSString stringWithFormat:@"No treatments"];
            
        }
        else
        {
            [self.UILabelErrorCode setHidden:true];
            [self.UITableViewTreatments setHidden:false];
            for (int i=0; i<treatments->count; i++)
            {
                TREATMENT_ELEMENT_T *myTreatment = &treatments->pTreatmentElementCollection[i];
                NSString *myTreatmentStr = [NSString stringWithFormat:@"%s %i Hr",
                                            ConvertUnixTimeToString(myTreatment->startTime),
                                            myTreatment->duration];
                
                [myTreatmentArray addObject:myTreatmentStr];
                
            }
        }
        myBadge.Text = [NSString stringWithFormat:@"%d", treatments->count];
    }
    else
    {
        [self.UITableViewTreatments setHidden:true];
        myBadge.Text = [NSString stringWithFormat:@"Error"];
        [self.UILabelErrorCode setHidden:false];
        self.UILabelErrorCode.text = [NSString stringWithFormat:@"Error: %04x", errorCode ];
    }
    
    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ButtonHomeClicked:(id)sender
{
    [self.delegate OnDismissTreatments:self  Confirm:true];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //    NSArray *myArray = [ViewControllerLog GetUniqueSerialIds];
    //
    //    return [myArray count];
}

-(NSString *)GetSerialNumberForSection:(int)section
{
    //    NSArray *myArray = [ViewControllerLog GetUniqueSerialIds];
    //    NSDictionary * obj = myArray[section];
    //    NSString *myString = [NSString stringWithFormat:@"%@", [obj objectForKey:@"syringeId"] ];
    return @"1234";
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *myString = [NSString stringWithFormat:@"Treatment Schedule"];
    
    //    NSString *myString = [NSString stringWithFormat:@"Treatment Schedule: %@", [self GetSerialNumberForSection:section]];
    return myString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSString* serialNumber = [self GetSerialNumberForSection:section];
    //    int  count = [ViewControllerLog GetRecordCountForSerialNumber:serialNumber];
    return [myTreatmentArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
    tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    tableViewHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.0f];
    tableViewHeaderFooterView.contentView.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.0f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0)
    {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *mySerialNumber = [self GetSerialNumberForSection:indexPath.section];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Treatment %d", indexPath.row+1];
    cell.detailTextLabel.text = [myTreatmentArray objectAtIndex:indexPath.row];
    
    UIFont *myFont = [UIFont fontWithName:@"ArchitectsDaughter" size:14.0];
    cell.detailTextLabel.font = myFont;
    
    
    //    if ( [pMySelectedRecords indexOfObject:indexPath] == NSNotFound ) {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //        cell.accessoryView = nil;
    //    } else {
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //        cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"CheckMark.png"]];;
    //        [cell.accessoryView setFrame:CGRectMake(0, 0, 120, 120)];
    //
    //
    //    }
    
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    // Set up the cell...
    //    EntityReading *myReading = [pMyLogList objectAtIndex:indexPath.row];
    //    //bool isSelected = [myReading.isSelected boolValue];
    //
    //    if ( [pMySelectedRecords indexOfObject:indexPath] == NSNotFound ) {
    //        [pMySelectedRecords addObject:indexPath];
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //
    //
    //    } else {
    //        [pMySelectedRecords removeObject:indexPath];
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //
    //    }
    [self.UITableViewTreatments reloadData];
}

@end
