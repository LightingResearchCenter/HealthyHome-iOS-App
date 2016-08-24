/*
 * ActivityMetricScaling.c
 *
 *  Created on: August 17, 2015
 *      Author: Andrew Bierman
 */

#include "stdint.h"
#include "ActivityMetricScaling.h"
#include <math.h>

int32_t Accelerometer_MetricScaling(uint16_t ActivityIndex, uint16_t ActivityCount, float *AI, float *AC){
	*AI = 0.016*sqrt((float)ActivityIndex); 	// 0.016 = 0.004*4
	*AC = 0.016*sqrt((float)ActivityCount); 	// 0.016 = 0.004*4
	return 0; 	// success
}
