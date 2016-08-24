#ifndef __PREPARE_LIGHT_STRUCT_H__
#define __PREPARE_LIGHT_STRUCT_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "lightreading.h"

#include "rtwtypes.h"
#include "blackbox.h"

/* Function Definition */
extern void prepare_light_struct(LIGHTREADING_T * myLightreading, emxArray_real_T *timeUTC, emxArray_real_T *timeOffset, emxArray_real_T *red,
									emxArray_real_T *green, emxArray_real_T *blue , emxArray_real_T *clear, emxArray_real_T *cla , emxArray_real_T *cs,int dataLength);
#endif

