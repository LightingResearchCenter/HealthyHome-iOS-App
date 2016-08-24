//
//  EntityLightReading.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 8/20/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityLightReading : NSManagedObject

@property (nonatomic, retain) NSNumber * blueValue;
@property (nonatomic, retain) NSNumber * claValue;
@property (nonatomic, retain) NSNumber * csValue;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * greenValue;
@property (nonatomic, retain) NSNumber * redValue;
@property (nonatomic, retain) NSDate * timeUTC;
@property (nonatomic, retain) NSNumber * timeZone;
@property (nonatomic, retain) NSNumber * clearValue;

@end
