//
//  EntitySubject.h
//  HealthyHome
//
//  Created by Rajeev Bhalla on 4/14/15.
//  Copyright (c) 2015 RAJEEV BHALLA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntitySubject : NSManagedObject

@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * subjectId;

@end
