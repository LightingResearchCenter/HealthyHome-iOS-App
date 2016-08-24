/*
 * createlightschedule.h
 *
 * Code generation for function 'createlightschedule'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __CREATELIGHTSCHEDULE_H__
#define __CREATELIGHTSCHEDULE_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "rtwtypes.h"
#include "blackbox_types.h"
#include "config.h"

/* Function Declarations */
extern void createlightschedule(double t0, double x0, double xc0, double targetReferencePhaseTime, const double unavailability_startTimeUTC[4], const double unavailability_durationSecs[4], double *scheduleStruct_n, double c_scheduleStruct_startTimeUTC_d[LRCtreatmentSize], int c_scheduleStruct_startTimeUTC_s[1], double c_scheduleStruct_durationMins_d[LRCtreatmentSize+1], int c_scheduleStruct_durationMins_s[1]);
#endif
/* End of code generation (createlightschedule.h) */
