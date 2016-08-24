
//
//  CoreDataManager.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/12/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import "CoreDataManager.h"
#import <Foundation/Foundation.h>

#include "AppDelegate.h"
#include "GlobalConfig.h"
#include "DaysiUtilities.h"
#include "UserSettings.h"

#include "EntityLightReading.h"
#include "EntityMotionReading.h"
#include "EntityModel.h"
#include "EntityTreatment.h"
#include "EntityDevice.h"
#include "SSZipArchive.h"
#include "ProgressHud.h"


typedef enum WhichTime
{
    E_FIRST_TIME,
    E_LAST_TIME
} E_TIME_TYPE_T;

@implementation CoreDataManager

#pragma mark - CORE DATA Handlers


+(void) LogTreatmentRecord:(NSString *) strDeviceId
                 StartTimeUTC:(NSDate *) startTimeUTC
                  DurationMins:(int32_t) durationMins

{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Add Entry to Reading Database and reset all fields
    
    //  1 = Instantiate a newEntry
    EntityTreatment * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"EntityTreatment"
                                                                   inManagedObjectContext:context];
    //  2 - Log the Data
    newEntry.timeUTC =  [NSDate date];
    
    newEntry.duration = [NSNumber numberWithInteger:durationMins];

    newEntry.startTimeUTC  = startTimeUTC;

    
    
    //  3 - Save the context and verify that it succeeded
    NSError *error;
    if (![context  save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        //Todo - throw Exception
    }
    
 
    
}


+(void) LogPacemakerRecord:(NSDate *) _runTime
             runTimeOffset:(double) _runTimeOffset
                     model:(NSString *) _model
                   version: (double) _version
                        t0:(double) _t0
                        tn:(double) _tn
                        x0:(double) _x0
                        xn:(double) _xn
                       xc0:(double) _xc0
                       xcn:(double) _xcn;
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Add Entry to Reading Database and reset all fields
    
    //  1 = Instantiate a newEntry
    EntityModel * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"EntityModel"
                                                                  inManagedObjectContext:context];
    //  2 - Log the Data

    newEntry.model  = _model;
    newEntry.version = [NSNumber numberWithDouble:_version];
    newEntry.t0 = [NSNumber numberWithDouble:_t0];
    newEntry.tn = [NSNumber numberWithDouble:_tn];
    newEntry.x0 = [NSNumber numberWithDouble:_x0];
    

    newEntry.xc0 = [NSNumber numberWithDouble:_xc0];
    
    if (isnan(_xcn))
    {
        newEntry.xcn = [NSNumber numberWithDouble:0.0f];
    }
    else
    {
        newEntry.xcn= [NSNumber numberWithDouble:_xcn];
    }
    
    
    if (isnan(_xn))
    {
        newEntry.xn =[NSNumber numberWithDouble:0.0f];
    }
    else
    {
        newEntry.xn= [NSNumber numberWithDouble:_xn];
    }

    newEntry.runTimeUTC = _runTime;
    newEntry.runTimeOffset = [NSNumber numberWithDouble:_runTimeOffset];
    
    //  3 - Save the context and verify that it succeeded
    NSError *error;
    if (![context  save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        //Todo - throw Exception
    }
}

+(void) LogDaysiLightRecord:(NSString *) strDeviceId
                   DateTime:(NSDate *) pDateTime
                   RedValue:(float) red
                 GreenValue:(float) green
                  BlueValue:(float) blue
                  ClearValue:(float) clear

                   CLAValue:(float) cla
                    CSValue:(float) cs


{
    
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Add Entry to Reading Database and reset all fields
    
    //  1 = Instantiate a newEntry
    EntityLightReading * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"EntityLightReading"
                                                                  inManagedObjectContext:context];
    //  2 - Log the Data
    newEntry.timeUTC =  pDateTime;

    newEntry.deviceId = strDeviceId;
    newEntry.timeZone = [NSNumber numberWithInt:[DaysiUtilities GetGMTOffset]];
    
    newEntry.redValue = [NSNumber numberWithFloat:red];
    newEntry.greenValue = [NSNumber numberWithFloat:green];
    newEntry.blueValue = [NSNumber numberWithFloat:blue];
    newEntry.clearValue = [NSNumber numberWithFloat:clear];
    
    newEntry.claValue = [NSNumber numberWithFloat:cla];
    newEntry.csValue = [NSNumber numberWithFloat:cs];
    
    //  3 - Save the context and verify that it succeeded
    NSError *error;
    if (![context  save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        //Todo - throw Exception
    }
    
}


+(void) LogDaysiMotionRecord:(NSString *) strDaysiMotionId
                    DateTime:(NSDate *) pDateTime
               ActivityCount:(float) activityCount
               ActivityIndex:(float) activityIndex
              BatteryVoltage:(int32_t) battery

{
    
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Add Entry to Reading Database and reset all fields
    
    //  1 = Instantiate a newEntry
    EntityMotionReading * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"EntityMotionReading"
                                                                   inManagedObjectContext:context];
    //  2 - Log the Data
    newEntry.timeUTC =  pDateTime;
    newEntry.timeZone = [NSNumber numberWithInt:[DaysiUtilities GetGMTOffset]];
    newEntry.deviceId = strDaysiMotionId;
    newEntry.activityCount  = [NSNumber numberWithFloat:activityCount];
    newEntry.activityIndex = [NSNumber numberWithFloat:activityIndex];
    
    newEntry.batteryVoltage = [NSNumber numberWithInt:battery];
    
    
    //  3 - Save the context and verify that it succeeded
    NSError *error;
    if (![context  save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        //Todo - throw Exception
    }
    
}


+(void) LogCalibrationRecordRed:(float ) calRed
                    Green:(float ) calGreen
               Blue:(float) calBlue
               Clear:(float) calClear

{
    
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Add Entry to Reading Database and reset all fields
    
    //  1 = Instantiate a newEntry
    EntityDevice * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"EntityDevice"
                                                                   inManagedObjectContext:context];
    //  2 - Log the Data
    NSString *strCalData  = [NSString stringWithFormat:@"%3.3f::%3.3f::%3.3f::%3.3f", calRed, calGreen, calBlue, calClear];
    newEntry.calibration = strCalData;

    
    
    //  3 - Save the context and verify that it succeeded
    NSError *error;
    if (![context  save:&error]) {
        NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
        //Todo - throw Exception
    }
    
}


+(long) GetMotionReadingCSArray:(NSMutableArray *)pArray Count:(int)countValue
{
    
    long count = 0;
        int startingIndex, endingIndex =0;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"EntityMotionReading" inManagedObjectContext:managedContext]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeUTC" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *array = [managedContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        count = 0;
    }
    else
    {
        count = [array count];
    }
    
    if (count <= countValue)
    {
        startingIndex = 0;
        endingIndex = (int)count;
        
    }
    else
    {
        startingIndex = (int)count - countValue;
        endingIndex = (int)count -1;
        
    }
    
    // For each object in the results - create a String which will be written to the Log file
    for (int i=startingIndex; i<endingIndex; i++)
    {
        
        EntityMotionReading *myReading = (EntityMotionReading*)array[i];
        // Figure out this result's info
        NSNumber *myActivityIndex = myReading.activityIndex;
        [pArray addObject:myActivityIndex];
    }
    
    return [pArray count];
    
}

+(long) GetLightReadingCSArray:(NSMutableArray *)pArray Count:(int)countValue
{
    
    long count = 0;
    int startingIndex, endingIndex =0;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"EntityLightReading" inManagedObjectContext:managedContext]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeUTC" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *array = [managedContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        count = 0;
    }
    else
    {
        count = [array count];
    }
    
    if (count <= countValue)
    {
        startingIndex = 0;
        endingIndex = (int)count;
        
    }
    else
    {
        startingIndex = (int)count - countValue;
        endingIndex = (int)count -1;
        
    }
        
    
    
    // For each object in the results - create a String which will be written to the Log file
    for (int i=startingIndex; i<endingIndex; i++)
    {
        
        @try {
            EntityLightReading *myReading = (EntityLightReading*)array[i];
            // Figure out this result's info
            NSNumber *myCSValue = myReading.csValue;
            [pArray addObject:myCSValue];
        }
        @catch (NSException *exception) {
            
            NSLog( @"Exception reading Light Data from Data Base Index %d", i);
            
            
        }
        @finally {
            
        }

    }
    return [pArray count];
    
}

+(long) GetLightReadingCount
{
    
    long count = 0;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"EntityLightReading" inManagedObjectContext:managedContext]];
    
    NSError *error;
    count = [managedContext countForFetchRequest: request error: &error];
    
    return count;
    
}

+(long) GetMotionReadingCount
{
    
    long count = 0;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"EntityMotionReading" inManagedObjectContext:managedContext]];
    
    NSError *error;
    count = [managedContext countForFetchRequest: request error: &error];
    
    return count;
    
}

+(NSDate *)GetSyncTimeForDeviceId: (int)deviceId EntityType:(NSString *)strType ForTime: (E_TIME_TYPE_T)whichTime
{
    int count = 0;
    NSDate *myTime;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setFetchBatchSize:100];
    [request setEntity:[NSEntityDescription entityForName:strType inManagedObjectContext:managedContext]];
    
    
   // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeUTC" ascending:YES];
    
   // [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *array = [managedContext executeFetchRequest:request error:&error];
    if (array == nil || array.count == 0)
    {
        count = 0;
        myTime = nil;
    }
    else
    {
        EntityLightReading *myReading = [array objectAtIndex:(whichTime == E_FIRST_TIME?0:array.count-1)];
        myTime = myReading.timeUTC;
    }
    
    
    return myTime;
    
    
    
    
}

+ (NSDate *)GetOldestSyncTimeForDaysiLightId:(int)deviceId
{
    return [self GetSyncTimeForDeviceId:deviceId EntityType:@"EntityLightReading" ForTime:E_FIRST_TIME];
}

+ (NSDate *)GetLatestSyncTimeForDaysiLightId:(int)deviceId
{
    
    return [self GetSyncTimeForDeviceId:deviceId EntityType:@"EntityLightReading" ForTime:E_LAST_TIME];
}

+ (NSDate *)GetOldestSyncTimeForDaysiMotionId:(int)deviceId
{
    return [self GetSyncTimeForDeviceId:deviceId EntityType:@"EntityMotionReading" ForTime:E_FIRST_TIME];
}

+ (NSDate *)GetLatestSyncTimeForDaysiMotionId:(int)deviceId
{
    
    return [self GetSyncTimeForDeviceId:deviceId EntityType:@"EntityMotionReading" ForTime:E_LAST_TIME];
}
+(void) deleteOldRecordsIfNecessary_Dep
{
    
    // Process the results
    NSString * strDateTime;
    NSString * strDuration;
    NSString * strMaxPressure;
    NSString * strSyringeId;
    NSString *strComplete;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"EntityReading" inManagedObjectContext:managedContext]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *array = [managedContext executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        // Deal with error...
    }
    else
    {
        NSLog(@"Count is %lu", (unsigned long)[array count]);
        long recordsAvailable = [array count];
        if (array)
        {
            
            if (recordsAvailable >= k_MAX_RECORDS_LOGGED_IN_CORE_DATA)
            {
                for (int i=0; i<recordsAvailable - (k_MAX_RECORDS_LOGGED_IN_CORE_DATA-1); i++)
                {
                    NSManagedObject *obj = [array objectAtIndex:i];
                    
                    // Figure out this result's info
                    strDateTime = [obj valueForKey:@"dateTime"];
                    strDuration = [obj valueForKey:@"duration"];
                    strMaxPressure = [obj valueForKey:@"maxPressure"];
                    strSyringeId   = [obj valueForKey:@"syringeId"];
                    strComplete = [NSString stringWithFormat:@"%@, %@, %@, %@\r\n", strDateTime, strDuration, strMaxPressure, strSyringeId];
                    NSLog(@"Deleting Object %@", strComplete);
                    
                    [managedContext deleteObject:obj];
                }
                
            }
            
            
            if (![managedContext  save:&error]) {
                NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
            }
            
            
            
        }
    }
}


+(void) DeleteAllLightRecords
{
   [self DeleteAllRecordsForEntity:@"EntityLightReading"];
    
}
+(void) DeleteAllMotionRecords
{
    [self DeleteAllRecordsForEntity:@"EntityMotionReading"];
}
+(void) DeleteAllTreatmentRecords
{
    [self DeleteAllRecordsForEntity:@"EntityTreatment"];
}

+(void) DeleteAllPaceMakerRecords
{
    [self DeleteAllRecordsForEntity:@"EntityModel"];
}

+(void) DeleteAllRecordsForEntity:(NSString *)entityName
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:managedContext]];
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeUTC" ascending:YES];
    
    //[request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    
    NSArray *array = [managedContext executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        // Deal with error...
    }
    else
    {
        NSLog(@"Count is %lu", (unsigned long)[array count]);
        long recordsAvailable = [array count];
        if (array)
        {
            for (int i=0; i<recordsAvailable; i++)
            {
                NSManagedObject *obj = [array objectAtIndex:i];
                [managedContext deleteObject:obj];
            }
            
            if (![managedContext  save:&error]) {
                NSLog(@"Error, couldn't save: %@", [error localizedDescription]);
            }
            
        }
    }
}




+(long) SaveLightDataToFile:(NSString *)strFileName ForId: (NSString *)watchId MaxRecordCount:(int)maxCount
{
    
    //Get a reference to the Application's delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Get a reference to the managed Context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // Create the fetch request
    NSFetchRequest * myFetchRequest = [[NSFetchRequest alloc] init];
    [myFetchRequest setEntity:[NSEntityDescription entityForName:@"EntityLightReading" inManagedObjectContext:context]];
    
    //Create a filter using predicate if the caller has specified a id
    if (watchId != nil)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId == %@", watchId ];
        [myFetchRequest setPredicate:predicate];
    }
    
    // Execute the fetch request
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:myFetchRequest error:&error];
    
    
    if (results)
    {
        // Process the results
        NSString * strDateTime;
        NSString * strTimeOffset;
        NSString * strRed;
        NSString * strGreen;
        NSString * strBlue;
        NSString * strClear;
        NSString * strCLA;
        NSString * strCS;
        

        NSString * strAllRecords = @"timeUTC, timeOffset, red, green, blue, clear, cla, cs\r\n";
        NSString *strComplete;
        NSDate *myDate;
        
        // For each object in the results - create a String which will be written to the Log file
        for (id result in results)
        {
            
            // Figure out this result's info
            myDate = [result valueForKey:@"timeUTC"];
            time_t unixTime = (time_t) [myDate timeIntervalSince1970];
            
            strDateTime = [NSDateFormatter localizedStringFromDate:myDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
            strTimeOffset = [result valueForKey:@"timeZone"];

            float redValue = [[result valueForKey:@"redValue"] floatValue];
            float greenValue = [[result valueForKey:@"greenValue"] floatValue];
            float blueValue = [[result valueForKey:@"blueValue"] floatValue];
            float clearValue = [[result valueForKey:@"clearValue"] floatValue];
            
            strRed = [NSString stringWithFormat:@"%.02f", redValue]; ;
            strGreen = [NSString stringWithFormat:@"%.02f", greenValue];
            strBlue = [NSString stringWithFormat:@"%.02f", blueValue];
            strClear = [NSString stringWithFormat:@"%.02f", clearValue];
            
            strCLA = [result valueForKey:@"claValue"];
            strCS = [result valueForKey:@"csValue"];

            strComplete = [NSString stringWithFormat:@"%ld, %@, %@, %@, %@, %@, %@, %@\r\n", unixTime, strTimeOffset, strRed, strGreen, strBlue, strClear, strCLA, strCS ];
            strAllRecords = [strAllRecords stringByAppendingString:strComplete];
            
        }
        
        
        [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
        
        
    } else {
        
    }
    
    return [results count];
}

+(long) SaveMotionDataToFile:(NSString *)strFileName ForId: (NSString *)watchId MaxRecordCount: (int)maxCount
{
    
    //Get a reference to the Application's delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Get a reference to the managed Context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // Create the fetch request
    NSFetchRequest * myFetchRequest = [[NSFetchRequest alloc] init];
    [myFetchRequest setEntity:[NSEntityDescription entityForName:@"EntityMotionReading" inManagedObjectContext:context]];
    
    //Create a filter using predicate if the caller has specified a id
    if (watchId != nil)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId == %@", watchId ];
        [myFetchRequest setPredicate:predicate];
    }
    
    // Execute the fetch request
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:myFetchRequest error:&error];
    
    
    if (results)
    {
        // Process the results
        NSString * strDateTime;
        NSString * strTimeOffset;
        NSString * strActivityIndex;
        NSString * strActivityCount;

        
        
        NSString * strAllRecords = @"timeUTC, timeOffset, activityIndex, activityCount\r\n";
        NSString *strComplete;
        NSDate *myDate;
        
        // For each object in the results - create a String which will be written to the Log file
        for (id result in results)
        {
            
            // Figure out this result's info
            myDate = [result valueForKey:@"timeUTC"];
            time_t unixTime = (time_t) [myDate timeIntervalSince1970];
            
            strDateTime = [NSDateFormatter localizedStringFromDate:myDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
            strTimeOffset = [result valueForKey:@"timeZone"];
            strActivityIndex = [NSString stringWithFormat:@"%03.8f", [[result valueForKey:@"activityIndex"] floatValue]];
            strActivityCount = [NSString stringWithFormat:@"%03.8f", [[result valueForKey:@"activityCount"] floatValue]];

            strComplete = [NSString stringWithFormat:@"%ld, %@, %@, %@\r\n", unixTime, strTimeOffset, strActivityIndex, strActivityCount];
            strAllRecords = [strAllRecords stringByAppendingString:strComplete];
            
        }
        
        
        [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
        
        
    } else {
        
    }
    
    return [results count];
}

+(long) SavePacemakerDataToFile:(NSString *)strFileName ForId: (NSString *)watchId
{
    
    //Get a reference to the Application's delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Get a reference to the managed Context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // Create the fetch request
    NSFetchRequest * myFetchRequest = [[NSFetchRequest alloc] init];
    [myFetchRequest setEntity:[NSEntityDescription entityForName:@"EntityModel" inManagedObjectContext:context]];
    
    //Create a filter using predicate if the caller has specified a id
    if (watchId != nil)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId == %@", watchId ];
        [myFetchRequest setPredicate:predicate];
    }
    
    // Execute the fetch request
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:myFetchRequest error:&error];
    
    
    if (results)
    {
        // Process the results
        NSString * strRunTimeUTC;
        NSString * strTimeOffset;
        NSString * strVersion;
        NSString * strModel;
        NSString * strx0;
        NSString * strxc0;
        NSString * strt0;
        NSString * strxn;
        NSString * strxcn;
        NSString * strtn;

        NSString * strAllRecords = @"runTimeUTC,runTimeOffset,version,model,x0,xc0,t0,xn,xcn,tn\r\n";
        NSString *strComplete;
        NSDate *myDate;
        
        // For each object in the results - create a String which will be written to the Log file
        for (id result in results)
        {
            
            // Figure out this result's info
            myDate = [result valueForKey:@"runTimeUTC"];
            time_t unixTime = (time_t) [myDate timeIntervalSince1970];
            
            strRunTimeUTC = [NSDateFormatter localizedStringFromDate:myDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
            strTimeOffset = [[result valueForKey:@"runTimeOffset"] stringValue];
            
            strVersion = [result valueForKey:@"version"];
            strModel = [result valueForKey:@"model"];
            

            NSNumber *pNumber;
            
            pNumber = [result valueForKey:@"x0"];
            strx0 =  [NSString stringWithFormat:@"%2.2f", [pNumber floatValue]];
            
            pNumber = [result valueForKey:@"xc0"];
            strxc0= [NSString stringWithFormat:@"%2.2f", [pNumber floatValue]];

            
            strt0 = [result valueForKey:@"t0"];
            
            pNumber = [result valueForKey:@"xn"];
            strxn =  [NSString stringWithFormat:@"%2.2f", [pNumber floatValue]];
            
            pNumber = [result valueForKey:@"xcn"];
            strxcn =  [NSString stringWithFormat:@"%2.2f", [pNumber floatValue]];

            
            strtn = [result valueForKey:@"tn"];
            
            
            
            strComplete = [NSString stringWithFormat:@"%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@\r\n", unixTime, strTimeOffset, strVersion ,strModel, strx0, strxc0, strt0, strxn, strxcn, strtn];
            strAllRecords = [strAllRecords stringByAppendingString:strComplete];
            
        }
        
        
        [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
        
        
    } else {
        
    }
    
    return [results count];
   
    
}

+(long) SaveSubjectDataToFile:(NSString *)strFileName
{
    
    // Process the results
    NSString * strSubjectId;
    NSString * strNickName;
    NSString * strSex;
    NSString * strDateOfBirth;
    
    NSString * strAllRecords = @"subjectId, nickName, sex, dateOfBirth\r\n";
    NSString *strComplete;
    
    // Figure out this result's info
#if TARGET_IPHONE_SIMULATOR
    strSubjectId = @"UUID-STRING-VALUE";
#else
    strSubjectId = [DaysiUtilities identifierForAdvertising];
#endif

    
    strNickName = [[UIDevice currentDevice] name];
    strSex = [UserSettings GetProfileGender];
    strDateOfBirth  = [UserSettings GetProfileDateOfBirth];
    

    strComplete = [NSString stringWithFormat:@"%@, %@, %@, %@\r\n", strSubjectId, strNickName, strSex, strDateOfBirth];
    strAllRecords = [strAllRecords stringByAppendingString:strComplete];
    
    
    
    [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
    
    return 0;
    
}

+(long) SaveTreatmentDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId
{
    
    //Get a reference to the Application's delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Get a reference to the managed Context
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    // Create the fetch request
    NSFetchRequest * myFetchRequest = [[NSFetchRequest alloc] init];
    [myFetchRequest setEntity:[NSEntityDescription entityForName:@"EntityTreatment" inManagedObjectContext:context]];
    
    //Create a filter using predicate if the caller has specified a id
    if (deviceId != nil)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId == %@", deviceId ];
        [myFetchRequest setPredicate:predicate];
    }
    
    // Execute the fetch request
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:myFetchRequest error:&error];
    
    
    if (results)
    {
        // Process the results
        NSString * strSubjectId;
        NSString * strHubId;
        NSString * strStartTimeUTC;
        NSString * strDurationMins;
        
        NSString * strAllRecords = @"startTime , durationMins, subjectId, hubId\r\n";
        NSString *strComplete;
        
        strSubjectId = [[NSUUID UUID] UUIDString];
        strHubId = [UserSettings GetControlHubId];
        
        // For each object in the results - create a String which will be written to the Log file
        for (id result in results)
        {
            
            NSDate *myDate = [result valueForKey:@"startTimeUTC"];
            
            strStartTimeUTC = [NSString stringWithFormat:@"%f", [myDate timeIntervalSince1970]];
            strDurationMins = [result valueForKey:@"duration"];

            strComplete = [NSString stringWithFormat:@"%@, %@, %@, %@\r\n", strStartTimeUTC, strDurationMins, strSubjectId, strHubId];
            strAllRecords = [strAllRecords stringByAppendingString:strComplete];
            
            
        }
        [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
        
        
    } else {
        
    }
    
    return [results count];
    

    
}

+(long) SaveDeviceDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId
{
    // Process the results
    NSString * strDeviceType;
    NSString * strSerialNumber;
    NSString * strModelNumber;
    NSString * strFirmwareRevision;
    NSString * strCalibrationArray;
    
    NSString * strAllRecords = @"deviceType,serialNumber,modelNumber,firmwareVersion,calibrationArray\r\n";
    NSString *strComplete;
    
    
    //Create the data for DaysiMotion
    strDeviceType = @"DaysiMotion";
    strSerialNumber = [UserSettings GetDaysiMotionId];
    strModelNumber  = @"1";
    strFirmwareRevision = @"1";
    strCalibrationArray = @"null";
    strComplete = [NSString stringWithFormat:@"%@, %@, %@, %@, %@\r\n", strDeviceType, strSerialNumber, strModelNumber, strFirmwareRevision, strCalibrationArray];
    strAllRecords = [strAllRecords stringByAppendingString:strComplete];
    
    
    //Create the data for DaysiLight
    strDeviceType = @"DaysiLight";
    strSerialNumber = [UserSettings GetDaysiLightId];
    strModelNumber  = @"2";
    strFirmwareRevision = @"5";
    //Todo - Read calibration values
    strCalibrationArray = [UserSettings GetCalibrationStr];
    strComplete = [NSString stringWithFormat:@"%@, %@, %@, %@, %@\r\n", strDeviceType, strSerialNumber, strModelNumber, strFirmwareRevision, strCalibrationArray];
    strAllRecords = [strAllRecords stringByAppendingString:strComplete];
    
    [strAllRecords writeToFile:strFileName atomically:NO encoding:(NSStringEncodingConversionAllowLossy) error:nil];
    
    return 0;

}

+(int) CreateArchiveFile:(NSString *) pArchiveFileNameFullPath
{
    NSString *myLightReadingFileName, *myMotionReadingFileName, *mySubjectFileName, *myPacemakerFileName, *myTreatmentFileName, *myDeviceFileName;
    
    
    long recordCountLight = 0;
    long recordCountMotion = 0;
    long recordCountPacemaker = 0;
    long recordCountTreatment = 0;
    long recordCountDevice = 0;
    
    
    // Serialize the Core data objects to a txt file
    
    //Get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    

    myLightReadingFileName = [NSString stringWithFormat:@"%@/lightReading.csv",
                              documentsDirectory];
    myMotionReadingFileName = [NSString stringWithFormat:@"%@/activityReading.csv",
                               documentsDirectory];
    mySubjectFileName = [NSString stringWithFormat:@"%@/subject.csv",
                         documentsDirectory];
    
    myPacemakerFileName = [NSString stringWithFormat:@"%@/pacemaker.csv",
                           documentsDirectory];
    
    myTreatmentFileName = [NSString stringWithFormat:@"%@/treatment.csv",
                           documentsDirectory];
    
    myDeviceFileName = [NSString stringWithFormat:@"%@/device.csv",
                        documentsDirectory];
    
    // Save the Core data Entities to the specified file
    recordCountLight = [CoreDataManager SaveLightDataToFile: myLightReadingFileName ForId:nil MaxRecordCount:-1];
    
    recordCountMotion = [CoreDataManager SaveMotionDataToFile: myMotionReadingFileName ForId:nil MaxRecordCount:-1];
    
    [CoreDataManager SaveSubjectDataToFile:mySubjectFileName];
    
    recordCountPacemaker = [CoreDataManager SavePacemakerDataToFile:myPacemakerFileName ForId:0];
    
    recordCountTreatment = [CoreDataManager SaveTreatmentDataToFile:myTreatmentFileName ForId:0];
    
    
    recordCountDevice = [CoreDataManager SaveDeviceDataToFile:myDeviceFileName ForId:0];
    
    
    //Zip the file
    NSString * myZippedFileName = pArchiveFileNameFullPath;
    
    
    NSArray *inputPaths = [NSArray arrayWithObjects:
                           myLightReadingFileName,
                           myMotionReadingFileName,
                           mySubjectFileName,
                           myPacemakerFileName,
                           myTreatmentFileName,
                           myDeviceFileName,
                           nil];
    
    
    bool success = [SSZipArchive createZipFileAtPath:myZippedFileName withFilesAtPaths:inputPaths];
    if (success == 0)
    {
        NSLog(@"Error Creating Zip file\r\n");
    }
 
    return success;
    
    
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
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://lrc-3a5k-1554.via.yaler.net/healthyhome/webresources/fileupload"];
    
    
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
}



@end
