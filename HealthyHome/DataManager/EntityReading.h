//
//  EntityReading.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/12/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityReading : NSManagedObject

@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * redValue;
@property (nonatomic, retain) NSNumber * blueValue;
@property (nonatomic, retain) NSNumber * greenValue;
@property (nonatomic, retain) NSNumber * activityValue;
@property (nonatomic, retain) NSNumber * batteryVoltage;

@end
