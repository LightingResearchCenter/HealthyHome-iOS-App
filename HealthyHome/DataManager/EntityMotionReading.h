//
//  EntityMotionReading.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 8/19/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityMotionReading : NSManagedObject

@property (nonatomic, retain) NSNumber * activityCount;
@property (nonatomic, retain) NSNumber * activityIndex;
@property (nonatomic, retain) NSNumber * batteryVoltage;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSDate * timeUTC;
@property (nonatomic, retain) NSNumber * timeZone;

@end
