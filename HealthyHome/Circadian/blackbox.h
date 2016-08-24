/*
 * blackbox.h
 *
 * Code generation for function 'blackbox'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __BLACKBOX_H__
#define __BLACKBOX_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "rtwtypes.h"
#include "blackbox_types.h"

/* Function Declarations */
extern int blackbox(double runTimeUTC, double runTimeOffset, double bedTime, double riseTime, const struct_T *lightReading, const b_struct_T *activityReading, const c_struct_T *lastPacemaker, d_struct_T *treatment, c_struct_T *pacemaker, double distanceToGoal_data[1], int distanceToGoal_size[2]);
extern void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y);
#endif
/* End of code generation (blackbox.h) */
