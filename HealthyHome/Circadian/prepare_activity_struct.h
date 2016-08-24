#ifndef __PREPARE_ACTIVITY_STRUCT_H__
#define __PREPARE_ACTIVITY_STRUCT_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "lightreading.h"

#include "rtwtypes.h"
#include "blackbox.h"

/* Function Definition */
extern void prepare_activity_struct(ACTIVITYREADING_T * myActivityreading, emxArray_real_T *timeUTC, emxArray_real_T *timeOffset, emxArray_real_T *activityIndex,
									emxArray_real_T *activityCount, int dataLength);
#endif
