//
//  ViewControllerDebug.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 10/30/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "ViewControllerDebug.h"
#include "DaysiUtilities.h"
#import  "ProgressHUD.h"
#include "GlobalConfig.h"
#include "AppDelegate.h"
#include "CoreDataManager.h"
#include "ViewControllerConfirm.h"
#import "ProgressHUD.h"
#import "UserSettings.h"
#import <AudioToolbox/AudioServices.h>


@interface ViewControllerDebug ()

@end

@implementation ViewControllerDebug



@synthesize managedObjectContext;
@synthesize pDaysiMotionDevice;
@synthesize pDaysiLightDevice;
ViewControllerConfirm *myViewControllerConfirmCalibrate;
ViewControllerConfirm *myViewControllerConfirmReset;

const NSString *pSTR_FILE_TREATMENTS = @"treatments.csv";

NSTimer *refreshTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DaysiUtilities SetLayerToGlow:self.UIButtonClose.layer WithColor:[DaysiUtilities GetGlowColor]];
    [DaysiUtilities SetLayerToGlow:self.UIButtonEmailLogFile.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    [DaysiUtilities SetLayerToGlow:self.UIButtonEmailASCII.layer WithColor:[DaysiUtilities GetGlowColor]];
    [DaysiUtilities SetLayerToGlow:self.UIButtonReset.layer WithColor:[DaysiUtilities GetGlowColor]];
    
    // Set the managed Object Context to the AppDelegate's managed object Context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    //Set the wallpaper for the Parent View
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_wash_wall.png"]];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.UITextFieldCalRed.inputAccessoryView = keyboardDoneButtonView;
    self.UITextFieldCalGreen.inputAccessoryView = keyboardDoneButtonView;
    self.UITextFieldCalBlue.inputAccessoryView = keyboardDoneButtonView;
    self.UITextFieldCalClear.inputAccessoryView = keyboardDoneButtonView;
    [self.UIActivityIndicatorBusy setHidden:true];
    //[self.UIActivityIndicatorEmail setHidden:true];
    _UIActivityIndicatorBusy.transform  = CGAffineTransformMakeScale(2.0, 2.0);
    _UIActivityIndicatorEmail.transform  = CGAffineTransformMakeScale(2.0, 2.0);
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(RefreshUI)
                                                  userInfo:nil
                                                   repeats:YES];
    
    [self UpdateDaysiLightData:pDaysiLightDevice];
}

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
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







- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            [ProgressHUD showSuccess:@"Email Sent"];
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) ConfirmActionCompleted
{
    
    
}


-(void) UpdateDaysiMotionData:(DaysiMotion *)pMotionDevice
{
    
    self.UILabelRGB.Text = [pMotionDevice GetDebugShortString];
    
}

-(void) UpdateDaysiLightData:(DaysiLight *)pLightDevice
{
  
    //Update the calibration values recieved from the device
    self.UITextFieldCalRed.Text = [NSString stringWithFormat:@"%.03f", pDaysiLightDevice.calRed];
    self.UITextFieldCalGreen.Text = [NSString stringWithFormat:@"%.03f",pDaysiLightDevice.calGreen];
    self.UITextFieldCalBlue.Text = [NSString stringWithFormat:@"%.03f",pDaysiLightDevice.calBlue];
    self.UITextFieldCalClear.Text = [NSString stringWithFormat:@"%.03f",pDaysiLightDevice.calClear];


    
    
}

-(void) RefreshUI
{
    
    // [DaysiUtilities SetLayerToGlow:self.UISegmentControlCalibrate.layer WithColor:myDaysiLight.isDevicePresent?[DaysiUtilities GetDeviceConnectedGlowColor]:[UIColor redColor]];
    bool allowedToCalibrate = [pDaysiLightDevice isDevicePresent] && !self.UIActivityIndicatorBusy.isAnimating;
    
    self.UISegmentControlCalibrate.enabled = [pDaysiLightDevice isDevicePresent];
    
    self.UIButtonSyncDaysliLightTime.enabled = [pDaysiLightDevice isDevicePresent];
    self.UIButtonSyncDaysliLightTime.titleLabel.textColor = self.UIButtonSyncDaysliLightTime.enabled?[UIColor whiteColor]:[UIColor grayColor];
    
    self.UIButtonSyncDaysiMotionTime.enabled = [pDaysiMotionDevice isDevicePresent];
    self.UIButtonSyncDaysiMotionTime.titleLabel.textColor = self.UIButtonSyncDaysiMotionTime.enabled?[UIColor whiteColor]:[UIColor grayColor];
    
    
    self.UITextFieldCalRed.enabled = allowedToCalibrate;
    self.UITextFieldCalRed.backgroundColor =  allowedToCalibrate? [UIColor whiteColor]:[UIColor grayColor];
    
    self.UITextFieldCalGreen.enabled = allowedToCalibrate;
    self.UITextFieldCalGreen.backgroundColor =  allowedToCalibrate? [UIColor whiteColor]:[UIColor grayColor];
    
    self.UITextFieldCalBlue.enabled = allowedToCalibrate;
    self.UITextFieldCalBlue.backgroundColor =  allowedToCalibrate? [UIColor whiteColor]:[UIColor grayColor];
    
    self.UITextFieldCalClear.enabled = allowedToCalibrate;
    self.UITextFieldCalClear.backgroundColor =  allowedToCalibrate? [UIColor whiteColor]:[UIColor grayColor];
    
    
    self.UIButtonClose.enabled  = !self.UIActivityIndicatorBusy.isAnimating;
    self.UIButtonReset.enabled = !self.UIActivityIndicatorBusy.isAnimating;
    self.UIButtonEmailLogFile.enabled = !self.UIActivityIndicatorBusy.isAnimating;
    self.UIButtonEmailASCII.enabled = !self.UIActivityIndicatorBusy.isAnimating;
    
    self.UIButtonReset.titleLabel.textColor = self.UIButtonReset.enabled?[UIColor whiteColor]:[UIColor grayColor];
    self.UIButtonEmailLogFile.titleLabel.textColor = self.UIButtonEmailLogFile.enabled?[UIColor whiteColor]:[UIColor grayColor];
    self.UIButtonEmailASCII.titleLabel.textColor = self.UIButtonEmailASCII.enabled?[UIColor whiteColor]:[UIColor grayColor];
    
    if (self.UIActivityIndicatorBusy.isAnimating)
    {
        [self.UISegmentControlCalibrate setEnabled:false forSegmentAtIndex:(0)];
        [self.UISegmentControlCalibrate setEnabled:true forSegmentAtIndex:(1)];
        [self.UISegmentControlCalibrate setEnabled:false forSegmentAtIndex:(2)];
    }
    else
    {
        [self.UISegmentControlCalibrate setEnabled:true forSegmentAtIndex:(0)];
        [self.UISegmentControlCalibrate setEnabled:true forSegmentAtIndex:(1)];
        [self.UISegmentControlCalibrate setEnabled:true forSegmentAtIndex:(2)];
    }
}





#pragma mark - ButtonHandlers

- (IBAction)UIButtonClearPaceMakerClicked:(id)sender {
    [CoreDataManager DeleteAllPaceMakerRecords];
    
}

- (IBAction)UIButtonSyncDaysiLightTimeClicked:(id)sender {
    
  
    [self.UIActivityIndicatorEmail startAnimating];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    pDaysiLightDevice.forceTimeSync = true;
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.UIActivityIndicatorEmail stopAnimating];
        [ProgressHUD showSuccess:@"DaysiLight Time Sync'd"];
    });
    
    
    
}

- (IBAction)UIButtonSyncDaysiMotionTimeClicked:(id)sender {
    
    [self.UIActivityIndicatorEmail startAnimating];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    pDaysiMotionDevice.forceTimeSync = true;
    [self.UIActivityIndicatorEmail stopAnimating];
    [ProgressHUD showSuccess:@"DaysiMotion Time Sync'd"];
    
}

- (IBAction)UIButtonClose:(id)sender
{
    [self.delegate OnDismissDebug:self Confirm:true];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)UIButtonReset:(id)sender {
    myViewControllerConfirmReset = [[ViewControllerConfirm alloc]init];
    myViewControllerConfirmReset.delegate = self;
    
    // self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:myViewControllerConfirmReset animated:YES completion: ^{[self ConfirmActionCompleted];}];
    
    myViewControllerConfirmReset.UILabelCaption.text = @"Delete All Records?";
    
    
}

-(void) PostFileToServer :(NSString *)fileNameWithFullPath :(NSString *)urlString
{
    
    //Bail if no connection to Internet
    if ([DaysiUtilities connectedToInternet] == false)
    {
        [ProgressHUD showError:@"No Internet Connection"];
        return;
    }
    
    //Make sure the file Exists
    //Make Sure the archive files exist
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileNameWithFullPath];
    if (fileExists == false)
    {
        [ProgressHUD showError:@"File not present"];
        return;
    }
    
    [self.UIActivityIndicatorEmail startAnimating];

    self.UIButtonEmailASCII.enabled  = false;
    
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"file";
    
    
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add file data
    //Get the documents directory:
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileNameWithFullPath];
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"archive.zip\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: multipart/form-data\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [HTTPResponse statusCode];
    NSLog(@"Rcvd Response %ld", (long)statusCode);
    if (statusCode == 200)
    {
        [ProgressHUD showSuccess:@"Data Posted"];
    }
    else
    {
        [ProgressHUD showError:[NSString stringWithFormat:@"Post Error %ld",  (long)statusCode]];
        
    }
   [self.UIActivityIndicatorEmail stopAnimating];
    self.UIButtonEmailASCII.enabled  = true;

}


- (IBAction)UIButtonEmailLogFileClicked:(id)sender {
    
    //Make sure you are connected to the internet
    if ([DaysiUtilities connectedToInternet] == false)
    {
        [ProgressHUD showError:@"No Internet Connection"];
        return;
    }
    
    // Make sure that there is an Email account setup on this device
    if (false == [MFMailComposeViewController canSendMail])
    {
        [ProgressHUD showError:@"No Email Account Setup"];
        return;
    }
    
    [self.UIActivityIndicatorEmail startAnimating];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        //Make sure that you can create an archive file
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myArchiveFileName = [NSString stringWithFormat:@"%@/archive.zip",
                                       documentsDirectory ];
        
        NSString *mySqliteFile = [NSString stringWithFormat:@"%@/HealthyHome.sqlite",
                                  documentsDirectory ];
        
        bool success =  [CoreDataManager CreateArchiveFile:myArchiveFileName];
        if (success == 0 )
        {
            [ProgressHUD showError:@"Can't Create Archive"];
            [self.UIActivityIndicatorEmail stopAnimating];
            return;
        }
        
        
        [self.view bringSubviewToFront:self.UIActivityIndicatorEmail.viewForBaselineLayout];
        

        dispatch_async(dispatch_get_main_queue(), ^{

            [self EmailFile:myArchiveFileName DatabaseFile:mySqliteFile];
            [self.UIActivityIndicatorEmail stopAnimating];
            
        });
    });
}







- (IBAction)UIButtonPostArchiveDataClicked:(id)sender
{
    
    NSString * myArchiveFileNameWithFullPath;
    
    if(k_FEATURE_POST_TEST_LOG_FILE)
    {
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        myArchiveFileNameWithFullPath = [mainBundle pathForResource: @"archive" ofType: @"zip"];
    }
    else
    {
        [self.UIActivityIndicatorEmail startAnimating];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        //Create the Archive File
        //Make sure that you can create an arcive file
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        myArchiveFileNameWithFullPath = [NSString stringWithFormat:@"%@/archive.zip",
                                               documentsDirectory ];
        
        bool result =  [CoreDataManager CreateArchiveFile:myArchiveFileNameWithFullPath];
        if (result == 0 )
        {
            [ProgressHUD showError:@"Can't Create Archive"];
            [self.UIActivityIndicatorEmail stopAnimating];
            return;
        }
       
        [self.UIActivityIndicatorEmail stopAnimating];
    }
    
    NSString *yalerAddress = [UserSettings GetControlHubId];
    NSString *urlString = [NSString stringWithFormat:@"http://lrc-%@.via.yaler.net/healthyhome/webresources/fileupload",yalerAddress ];
    [self PostFileToServer:myArchiveFileNameWithFullPath :urlString];
 
}

// Loops thru all of the records and delete them
- (IBAction)UIButtonClearLogData:(id)sender {
    
    NSFetchRequest * myFetchRequest = [[NSFetchRequest alloc] init];
    [myFetchRequest setEntity:[NSEntityDescription entityForName:@"EntityReading" inManagedObjectContext:managedObjectContext]];
    [myFetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * myArray = [managedObjectContext executeFetchRequest:myFetchRequest error:&error];
    //error handling goes here
    
    for (NSManagedObject * myObj in myArray) {
        [managedObjectContext deleteObject:myObj];
    }
    NSError *saveError = nil;
    
    //  [pMyLogList removeAllObjects];
    //  [pMySelectedRecords removeAllObjects];
    
    [managedObjectContext save:&saveError];
    //  [self RefreshAllControls];
    
}

- (IBAction)UISegmentControlCalibrateChanged:(id)sender
{
    
    if (self.UISegmentControlCalibrate.selectedSegmentIndex == 0)
    {
        
        myViewControllerConfirmCalibrate = [[ViewControllerConfirm alloc]init];
        myViewControllerConfirmCalibrate.delegate = self;
        
        // self.view.backgroundColor = [UIColor clearColor];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        [self presentViewController:myViewControllerConfirmCalibrate animated:YES completion: ^{[self ConfirmActionCompleted];}];
        
        myViewControllerConfirmCalibrate.UILabelCaption.text = @"Delete all Records \r\nAnd Calibrate?";
        
    }
    else if (self.UISegmentControlCalibrate.selectedSegmentIndex == 1)
    {
        [self.UIActivityIndicatorBusy stopAnimating];
        [self.UIActivityIndicatorBusy setHidden:true];
        // [self.UITextFieldCalRed setHidden:FALSE];
        self.UITextFieldCalRed.enabled  = true;
        self.UITextFieldCalGreen.enabled  = true;
        self.UITextFieldCalBlue.enabled  = true;
        self.UITextFieldCalClear.enabled  = true;
        
        //Send a command to stop calibrating
        [pDaysiLightDevice StopCalibration];
        
        
    }
    else if (self.UISegmentControlCalibrate.selectedSegmentIndex == 2)
    {
        [self UIButtonCalibrateClick:self];
        
    }
    [self RefreshUI];
}

- (IBAction)UIButtonCalibrateClick:(id)sender
{
    // Write to the command characteristic of the DaysiLight Device
    float red = [self.UITextFieldCalRed.text floatValue];
    float green = [self.UITextFieldCalGreen.text floatValue];
    float blue = [self.UITextFieldCalBlue.text floatValue];
    float clear = [self.UITextFieldCalClear.text floatValue];
    
    [pDaysiLightDevice WriteCalibrationDataRed:red Green:green Blue:blue Clear:clear];
}


- (IBAction)UIButtonCalibrateReadClick:(id)sender

{
    
    
    
}

#pragma  mark - ViewConfirmSelectionCallback
//
- (void)addItemViewController:(ViewControllerConfirm *)controller didFinishConfirmSelection:(bool)confirmExit
{
    //Restore the background Color
    //    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grey_light.png"]];
    
    if (controller == myViewControllerConfirmCalibrate)
    {
        if (confirmExit)
        {
            [CoreDataManager DeleteAllLightRecords];
            [CoreDataManager DeleteAllMotionRecords];
            [pDaysiLightDevice StartCalibration];
            [self.UIActivityIndicatorBusy startAnimating];
            [self.UIActivityIndicatorBusy setHidden:false];
            
            
        }
        else
        {
            
        }
    }
    
    if (controller == myViewControllerConfirmReset)
    {
        if (confirmExit)
        {
            [CoreDataManager DeleteAllLightRecords];
            [CoreDataManager DeleteAllMotionRecords];
        }
        else
        {
            
        }
    }
    
    
}



-(void) EmailFile: (NSString *)archivefileNameWithZipExtensionAndFullPath DatabaseFile:(NSString *)sqliteFile
{
    
    //Make sure you are connected to the internet
    if ([DaysiUtilities connectedToInternet] == false)
    {
        [ProgressHUD showError:@"No Internet Connection"];
        return;
    }
    
    
    // Make sure that there is an Email account setup on this device
    if (false == [MFMailComposeViewController canSendMail])
    {
        [ProgressHUD showError:@"No Email Account Setup"];
        return;
    }
    
    
    //Make sure the file Exists
    //Make Sure the archive files exist
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:archivefileNameWithZipExtensionAndFullPath];
    if (fileExists == false)
    {
        [ProgressHUD showError:@"Archive File not present"];
        return;
    }
    
    //Make Sure the archive files exist
    BOOL sqliteFileExists = [[NSFileManager defaultManager] fileExistsAtPath:sqliteFile];
    if (sqliteFileExists == false)
    {
        [ProgressHUD showError:@"Sqlite File not Present"];
        return;
    }
    else
    {
        NSError *attributesError;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:sqliteFile error:&attributesError];
        
        long fileSize = [fileAttributes fileSize];
        NSLog (@"File Size id %ld", fileSize);
        
    }
    
    // Create a Mail composer
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Archive Data from HealthyHome"];
    

    
    // Extract the contents of the file into a NSData object and add it as an attachment
    NSURL *storeUrl = [NSURL fileURLWithPath: archivefileNameWithZipExtensionAndFullPath];
    NSLog(@"Store URL is %@", storeUrl);
    NSData *myData = [NSData dataWithContentsOfURL:storeUrl];
    [mailComposer addAttachmentData:myData mimeType:@"application/zip" fileName:[archivefileNameWithZipExtensionAndFullPath lastPathComponent]];
    
    storeUrl = [NSURL fileURLWithPath: sqliteFile];
    NSLog(@"Store URL is %@", storeUrl);
    myData = [NSData dataWithContentsOfURL:storeUrl];
    
    [mailComposer addAttachmentData:myData mimeType:@"application/x-sqlite3" fileName:[sqliteFile lastPathComponent]];

    
    
    NSString * emailBody = [NSString stringWithFormat:@"There are %ld Light records and %ld Activity records attached.", [CoreDataManager GetLightReadingCount],   [CoreDataManager GetMotionReadingCount]];
    
    [mailComposer setMessageBody:emailBody isHTML:NO];

    
    // Present the mail composer to the user
    [self presentViewController:mailComposer animated:YES completion:nil];
    
    
    
}


@end
