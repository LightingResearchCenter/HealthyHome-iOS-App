//
//  CoreDataManager.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/12/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#ifndef Daysimeter_CoreDataManager_h
#define Daysimeter_CoreDataManager_h

@interface CoreDataManager : NSObject


+(void) LogDaysiMotionRecord:(NSString *) strDaysiMotionId
                    DateTime:(NSDate *) pDateTime
               ActivityCount:(float) activityCount
               ActivityIndex:(float) activityIndex
              BatteryVoltage:(int32_t) battery;

+(void) LogCalibrationRecordRed:(float ) calRed
                          Green:(float ) calGreen
                           Blue:(float) calBlue
                          Clear:(float) calClear;

+(void) LogDaysiLightRecord:(NSString *) strDeviceId
                   DateTime:(NSDate *) pDateTime
                   RedValue:(float) red
                 GreenValue:(float) green
                  BlueValue:(float) blue
                  ClearValue:(float) clear
                   CLAValue:(float) cla
                    CSValue:(float) cs;



+(void) LogTreatmentRecord:(NSString *) strDeviceId
              StartTimeUTC:(NSDate *) startTimeUTC
              DurationMins:(int32_t) durationMins;



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


+(long) GetLightReadingCount;
+(long) GetMotionReadingCount;

+(void) DeleteAllLightRecords;
+(void) DeleteAllMotionRecords;
+(void) DeleteAllTreatmentRecords;
+(void) DeleteAllPaceMakerRecords;


+(long) SaveLightDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId MaxRecordCount: (int)maxCount;
+(long) SaveDeviceDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId;

+(long) SaveMotionDataToFile:(NSString *)strFileName ForId: (NSString *)watchId MaxRecordCount: (int)maxCount;
+(long) SavePacemakerDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId;
+(long) SaveTreatmentDataToFile:(NSString *)strFileName ForId: (NSString *)deviceId;
+(long) SaveSubjectDataToFile:(NSString *)strFileName;
+(int) CreateArchiveFile:(NSString *) pArchiveFileName;

+ (NSDate *)GetOldestSyncTimeForDaysiLightId:(int)deviceId;
+ (NSDate *)GetLatestSyncTimeForDaysiLightId:(int)deviceId;

+ (NSDate *)GetOldestSyncTimeForDaysiMotionId:(int)deviceId;
+ (NSDate *)GetLatestSyncTimeForDaysiMotionId:(int)deviceId;

+(long) GetLightReadingCSArray:(NSMutableArray *)pArray Count:(int)countValue;
+(long) GetMotionReadingCSArray:(NSMutableArray *)pArray Count:(int)countValue;
@end

#endif
