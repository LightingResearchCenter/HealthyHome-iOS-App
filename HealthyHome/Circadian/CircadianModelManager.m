//
//  CircadianModelManager.m
//  Daysimeter
//
//  Created by Rajeev Bhalla on 12/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircadianModelManager.h"
#import "UserSettings.h"
#import "CoreDataManager.h"
#import "GlobalConfig.h"
#include "DaysiUtilities.h"



#define kNUMBER_OF_GOALS (1)
#define maxNUMBER_OF_DAYS (10)
#define maxNUMBER_OF_DATA (65500)
#define minREQ_DATALENGTH (4)
#define HOURS_IN_DAY (24)

@interface CircadianModelManager ()

@end

@implementation CircadianModelManager

void PrintTreatments(d_struct_T *pTreatments);
char * UnixTimeToString (long unixTime);

PROFILE_T myProfile;
GOAL_T myGoal;
c_struct_T myPaceMaker;
d_struct_T Treatments;
double distanceToGoal;
d_struct_T *pMyTreatments;

int lastErrorCode = 0;

FILE  *pFileActivityReading, *pFileLightReading, *pFilePacemaker;


// VERSION_T myCircadianModelVersion;

unsigned long unixTimeLogStart, unixTimeNow;



-(id)init
{
    //Set the profile by reading user preferences
    self = [super init];
    if (self) {
        lastErrorCode = 0;
    }
    
    return self;
}

-(d_struct_T *) GetTreatments
{
    return &Treatments;
}

-(double ) GetDistanceToGoalInHrs
{
    return distanceToGoal;
}

-(int)GetLastStatus
{
    
    return lastErrorCode;
}

-(int) RecomputeAlgorithm
{

    NSString *pathToLightDataFile, *pathToMotionDataFile, *pathToPacemakerDataFile;
    
    long lightReadingCount  = [CoreDataManager GetLightReadingCount];
    long activityReadingCount = [CoreDataManager GetMotionReadingCount];
    
    bool dataAvailableToCompute =  lightReadingCount > 0 && activityReadingCount > 0;

    #define MAX_TEST_ITERATIONS (4)
    static int countRecompute = 0;

    int runTimeArray[MAX_TEST_ITERATIONS] =
    {1446437114,
        1446441885,
        1446451488,
        1446474304
    };

    if (k_FEATURE_USE_TEST_LOG_FILE == /* DISABLES CODE */ (1))
    {
    
        countRecompute++;
        if (countRecompute > MAX_TEST_ITERATIONS)
        {
            NSException *e = [NSException
                              exceptionWithName:@"EmptyInventoryException"
                              reason:@"Recompute Under Test Scenario Can Only Be Run 4 times"
                              userInfo:nil];
            @throw e;
        
        }
        pathToLightDataFile = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"lightReading_%d",countRecompute] ofType: @"csv"];
        pathToMotionDataFile = [[NSBundle mainBundle] pathForResource:  [NSString stringWithFormat:@"activityReading_%d",countRecompute] ofType: @"csv"];
        pathToPacemakerDataFile = [[NSBundle mainBundle] pathForResource:  @"pacemaker" ofType: @"csv"];
    }
    else
    {

        if (dataAvailableToCompute == false)
        {
            return ERROR_CODE_LIGHT_LESS_THAN_ADAY;
        }
        
        //Save the Data from CoreData To File
        
        //Get the documents directory:
        NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        long result;
        pathToLightDataFile = [NSString stringWithFormat:@"%@/lightReading.csv", documentsDirectory];
        result = [CoreDataManager SaveLightDataToFile:pathToLightDataFile ForId:0 MaxRecordCount:-1];
        
        pathToMotionDataFile = [NSString stringWithFormat:@"%@/activityReading.csv", documentsDirectory];
        result = [CoreDataManager SaveMotionDataToFile:pathToMotionDataFile ForId:0 MaxRecordCount:-1];

        pathToPacemakerDataFile = [NSString stringWithFormat:@"%@/pacemaker.csv", documentsDirectory];
        result = [CoreDataManager SavePacemakerDataToFile:pathToPacemakerDataFile ForId:0];
    }
    
    //Make Sure the files exist
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathToLightDataFile];
    if (fileExists == false)
    {
        NSLog(@"Light Data File does not exist");
        lastErrorCode = -1;
        return (lastErrorCode);
        
    }
    
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathToMotionDataFile];
    if (fileExists == false)
    {
        NSLog(@"Motion Data File does not exist");
        lastErrorCode = -1;
        return (lastErrorCode);
        
    }

    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pathToPacemakerDataFile];
    if (fileExists == false)
    {
        NSLog(@"PaceMaker Data File does not exist");
        lastErrorCode = -1;
        return (lastErrorCode);
        
    }
    
    

    //Open the File and get the File Pointers
    pFileLightReading = fopen([pathToLightDataFile cStringUsingEncoding:1],"r");
    if (pFileLightReading == NULL)
    {
        printf ("Exception - Error Opening Light Data file\r\n");
        lastErrorCode = -1;
        return (lastErrorCode);
    }
    
    pFileActivityReading = fopen([pathToMotionDataFile cStringUsingEncoding:1],"r");
    if (pFileActivityReading == NULL)
    {
        printf ("Exception - Error Opening Motion Data file\r\n");
        lastErrorCode = -1;
        return (lastErrorCode);
    }
    
    pFilePacemaker = fopen([pathToPacemakerDataFile cStringUsingEncoding:1],"r");
    if (pFilePacemaker == NULL)
    {
        printf ("Exception - Error Opening PaceMaker Data file\r\n");
        lastErrorCode = -1;
        return (lastErrorCode);
    }
    
    
    /*Initialize Variables*/
    //Todo - Replace with Current Time
    unixTimeLogStart=1397652960;
    unixTimeNow = (unsigned)time(NULL);
    
    
    //Todo - Get the Bed/Rise time from UI
    // Set up the User Profile settings
    myProfile.age =  [UserSettings GetProfileAge];
    myProfile.sex=E_MALE;
 
    myGoal.bedTime=   [UserSettings GetProfileNormalSleepAt] * HOURS_IN_DAY * 0.999f;
    myGoal.riseTime=  [UserSettings GetProfileNormalWakeAt] * HOURS_IN_DAY * 0.999f;

    time_t  currentUnixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    int currentGMTOffset = [DaysiUtilities GetGMTOffset];

    
    //Todo - Remove this before Release
//    if (k_FEATURE_USE_TEST_LOG_FILE)
//    {
//        currentUnixTime = runTimeArray[countRecompute-1];
//        
//        currentGMTOffset = -5;
//        myGoal.bedTime=   22.5;
//        myGoal.riseTime=  7.5;
//    }
    
    lastErrorCode = CircadianModel_Initialize( myProfile, myGoal, currentUnixTime, currentGMTOffset);

    if (lastErrorCode !=ERROR_CODE_NONE)
    {
        printf ("Error Initializing the Circadian Model %x\r\n", lastErrorCode);
    }
    else
    {
        lastErrorCode = CircadianModelRun(pFileActivityReading, pFileLightReading, pFilePacemaker, &Treatments, &myPaceMaker,  &distanceToGoal );

        if (lastErrorCode == 0)
        {
            //Todo Save Data only if Circadian Model returns a success
            //myPaceMaker.runTimeOffset = currentGMTOffset;
            //myPaceMaker.runTimeUTC = currentUnixTime;
            [CoreDataManager LogPacemakerRecord:[NSDate dateWithTimeIntervalSince1970:myPaceMaker.runTimeUTC]
                                  runTimeOffset:myPaceMaker.runTimeOffset
                                          model:[NSString stringWithFormat:@"%s", myPaceMaker.model]
                                        version:myPaceMaker.version
                                             t0:myPaceMaker.t0
                                             tn:myPaceMaker.tn
                                             x0:myPaceMaker.x0
                                             xn:myPaceMaker.xn
                                            xc0:myPaceMaker.xc0
                                            xcn:myPaceMaker.xcn];
            
            NSLog(@"PaceMaker RuntimeUTC:%f Offset:%f  x0:%3.2f xc0:%3.2f t0:%f xn:%3.2f xcn:%3.2f tn:%f", myPaceMaker.runTimeUTC, myPaceMaker.runTimeOffset, myPaceMaker.x0, myPaceMaker.xc0, myPaceMaker.t0, myPaceMaker.xn, myPaceMaker.xcn, myPaceMaker.tn);
            
            // Purge All old Treatment Records from the database
            [CoreDataManager DeleteAllTreatmentRecords];
            
            for (int i=0; i<Treatments.n; i++)
            {
                  int durationMins = Treatments.durationMins.data[i];
                NSTimeInterval interval = Treatments.startTimeUTC.data[i];
                NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:interval];
                NSLog (@"Now %@", myDate);
                
                [CoreDataManager LogTreatmentRecord:@"0" StartTimeUTC:myDate DurationMins:durationMins];
            }
        }

        PrintTreatments(&Treatments);
    }
    
    return lastErrorCode;
    

}


void PrintTreatments(d_struct_T *pTreatments)
{
    
/*
    int i;

    
    TREATMENT_ELEMENT_T *myTreatment;
    
    printf("User Profile:\r\n");
    printf(" Age: %d\r\n WakeUpTime: %5.2f\r\n SleepTime: %5.2f\r\n LightInterval: %5.2f\r\n lightLevel %5.2f\r\n PhaseMarker %c\r\n", myProfile.age, myProfile.wakeupTime, myProfile.sleepTime, myPreferences.lightIntervals, myPreferences.lightLevel, myPreferences.phMarker);
    
    printf("User Goals:\r\n");
    printf(" Target Wake Up: %5.2f\r\n Target Number Of Days: %5.2f\r\n ", myGoalCollection.pGoals[0].targetRefPhaseTime, myGoalCollection.pGoals[0].targetDayPlan);
    
    
    printf("Current time is :[%d] %s\r\n", unixTimeNow, UnixTimeToString(unixTimeNow));
    printf("File Log time is:[%d] %s\r\n", unixTimeLogStart, UnixTimeToString(unixTimeLogStart));
    
    

    for (i=0; i<pTreatments->count; i++)
    {
        myTreatment = pTreatments->pTreatmentElementCollection+i;
        
        //Convert Treatment Time to a human readable format
        printf("%d: Start: (%d)[%s] Duration: %i Intensity: %5.2f\r\n",i+1, myTreatment->startTime,UnixTimeToString(myTreatment->startTime), myTreatment->duration, myTreatment->intensity);
    }
*/
    printf("\r\nThere are %f Treatments available\r\n", pTreatments->n);
    printf("---------------------------------------------------------------------\r\n\n\n\n\n");
    
}

char * UnixTimeToString (long unixTime)
{
    static char buf[100];
    struct tm * timeInfo;
    time_t myTime;
    //Convert Treatment Time to a human readable format
    myTime = unixTime;
    timeInfo = localtime(&myTime);
    strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S", timeInfo);
    return buf;
    
    
}

@end