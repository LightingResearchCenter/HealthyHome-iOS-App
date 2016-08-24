/*
 * LRCtruncate_lightReading.h
 *
 * Code generation for function 'LRCtruncate_lightReading'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __LRCTRUNCATE_LIGHTREADING_H__
#define __LRCTRUNCATE_LIGHTREADING_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "rtwtypes.h"
#include "blackbox_types.h"

/* Function Declarations */
extern void LRCtruncate_lightReading(const emxArray_real_T *lightReading_timeUTC,
                              const emxArray_real_T *lightReading_timeOffset,
                              const emxArray_real_T *lightReading_red,
                              const emxArray_real_T *lightReading_green,
                              const emxArray_real_T *lightReading_blue,
                              const emxArray_real_T *lightReading_clear,
                              const emxArray_real_T *lightReading_cla,
                              const emxArray_real_T *lightReading_cs,
                              emxArray_real_T *lightReadingTrunc_timeUTC,
                              emxArray_real_T *lightReadingTrunc_timeOffset,
                              emxArray_real_T *lightReadingTrunc_red,
                              emxArray_real_T *lightReadingTrunc_green,
                              emxArray_real_T *lightReadingTrunc_blue,
                              emxArray_real_T *lightReadingTrunc_clear,
                              emxArray_real_T *lightReadingTrunc_cla,
                              emxArray_real_T *lightReadingTrunc_cs);

//extern void LRCtruncate_lightReading(const emxArray_real_T *lightReading_timeUTC, const emxArray_real_T *lightReading_timeOffset, const emxArray_real_T *lightReading_red, const emxArray_real_T *lightReading_green, const emxArray_real_T *lightReading_blue, emxArray_real_T *lightReading_clear, const emxArray_real_T *lightReading_cla, const emxArray_real_T *lightReading_cs, emxArray_real_T *lightReadingTrunc_timeUTC, emxArray_real_T *lightReadingTrunc_timeOffset, emxArray_real_T *lightReadingTrunc_red, emxArray_real_T *lightReadingTrunc_green, emxArray_real_T *lightReadingTrunc_blue, emxArray_real_T *lightReadingTrunc_clear, emxArray_real_T *lightReadingTrunc_cla, emxArray_real_T *lightReadingTrunc_cs);
#endif
/* End of code generation (LRCtruncate_lightReading.h) */
