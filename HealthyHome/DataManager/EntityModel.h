//
//  EntityModel.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 10/9/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityModel : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * runTimeOffset;
@property (nonatomic, retain) NSDate * runTimeUTC;
@property (nonatomic, retain) NSNumber * t0;
@property (nonatomic, retain) NSNumber * tn;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * x0;
@property (nonatomic, retain) NSNumber * xc0;
@property (nonatomic, retain) NSNumber * xcn;
@property (nonatomic, retain) NSNumber * xn;

@end
