//
//  EntityConfig.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 11/7/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityConfig : NSManagedObject

@property (nonatomic, retain) NSNumber * logStatus;
@property (nonatomic, retain) NSNumber * firmwareVersion;
@property (nonatomic, retain) NSNumber * deviceModel;
@property (nonatomic, retain) NSNumber * deviceId;
@property (nonatomic, retain) NSNumber * hoursLogging;
@property (nonatomic, retain) NSNumber * downloadFlag;
@property (nonatomic, retain) NSNumber * logInterval;

@end
