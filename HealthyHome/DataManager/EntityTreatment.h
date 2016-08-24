//
//  EntityTreatment.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 8/19/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityTreatment : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * startTimeUTC;
@property (nonatomic, retain) NSDate * timeUTC;

@end
