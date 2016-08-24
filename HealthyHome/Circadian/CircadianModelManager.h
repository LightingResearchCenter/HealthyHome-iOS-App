//
//  CircadianModelManager.h
//  Daysimeter
//
//  Created by Rajeev Bhalla on 12/11/14.
//  Copyright (c) 2014 RAJEEV BHALLA. All rights reserved.
//

#ifndef Daysimeter_CircadianModelManager_h
#define Daysimeter_CircadianModelManager_h


#import "CircadianModel.h"
@class CircadianModelManager;

@interface CircadianModelManager : NSObject
-(int) RecomputeAlgorithm;
-(d_struct_T *) GetTreatments;
-(double ) GetDistanceToGoalInHrs;
-(int)GetLastStatus;

@end

#endif
