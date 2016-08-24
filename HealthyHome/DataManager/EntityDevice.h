//
//  EntityDevice.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 10/20/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityDevice : NSManagedObject

@property (nonatomic, retain) NSString * calibration;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSNumber * deviceType;
@property (nonatomic, retain) NSString * firmwareRev;
@property (nonatomic, retain) NSNumber * lastSync;
@property (nonatomic, retain) NSNumber * modelNumber;
@property (nonatomic, retain) NSString * serialNumber;

@end
