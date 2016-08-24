//
//  EntityHub.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 4/14/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityHub : NSManagedObject

@property (nonatomic, retain) NSString * hubId;
@property (nonatomic, retain) NSString * hubURL;

@end
