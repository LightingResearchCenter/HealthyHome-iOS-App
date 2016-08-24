//
//  EntityReading.h
//  RaptorReal
//
//  Created by Rajeev Bhalla on 4/9/14.
//  Copyright (c) 2014 Rajeev Bhalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityReading : NSManagedObject

@property (nonatomic, retain) NSString * dateTime;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSString * maxPressure;
@property (nonatomic, retain) NSString * syringeId;
@property (nonatomic, retain) NSNumber * isSelected;

@end
