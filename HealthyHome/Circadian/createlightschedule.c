/*
 * createlightschedule.c
 *
 * Code generation for function 'createlightschedule'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "createlightschedule.h"
#include "mod.h"
#include "rk4stepperSec.h"
#include "LRCisAvail.h"
#include "diff.h"
#include "blackbox_emxutil.h"
#include "config.h"

/* Function Definitions */
void createlightschedule(double t0, double x0, double xc0, double
  targetReferencePhaseTime, const double unavailability_startTimeUTC[4], const
  double unavailability_durationSecs[4], double *scheduleStruct_n, double
  c_scheduleStruct_startTimeUTC_d[LRCtreatmentSize], int c_scheduleStruct_startTimeUTC_s[1],
  double c_scheduleStruct_durationMins_d[LRCtreatmentSize+1], int
  c_scheduleStruct_durationMins_s[1])
{
  double lightScheduleArray[LRCtreatmentSize];
  double t1;
  double t2;
  int idx;
  double xcfDark;
  double xfDark;
  double xcfLight;
  double xfLight;
  double time[LRCtreatmentSize];
  int i1;
  unsigned char ii_data[LRCtreatmentSize];
  int ii;
  boolean_T exitg4;
  boolean_T guard4 = FALSE;
  int loop_ub;
  unsigned char b_ii_data[LRCtreatmentSize];
  int q_size[1];
  double q_data[LRCtreatmentSize];
  emxArray_real_T *r8;
  emxArray_real_T b_q_data;
  double qdiff_data[LRCtreatmentSize-1];
  boolean_T x_data[LRCtreatmentSize-1];
  int nx;
  int c_ii_data[LRCtreatmentSize-1];
  boolean_T exitg3;
  boolean_T guard3 = FALSE;
  int d_ii_data[LRCtreatmentSize-1];
  double startTimes_data[LRCtreatmentSize];
  double dv0[LRCtreatmentSize+2];
  double dv1[LRCtreatmentSize+1];
  boolean_T x[LRCtreatmentSize+1];
  unsigned char e_ii_data[LRCtreatmentSize+1];
  boolean_T exitg2;
  boolean_T guard2 = FALSE;
  unsigned char f_ii_data[LRCtreatmentSize+1];
  double dv2[LRCtreatmentSize+2];
  boolean_T exitg1;
  boolean_T guard1 = FALSE;
  unsigned char g_ii_data[LRCtreatmentSize+1];

  /*  CREATELIGHTSCHEDULE creates a schedule of light treatment times based on */
  /*  the current state of the pacemaker and a target phase. */
  /*  */
  /*    Input: */
  /*        t0: The relative time in hours corresponding to the state variable */
  /*        values (0 <= t0 < 24) */
  /*        x0: Pacemaker state variable #1 (x-axis) */
  /*        xc0: Pacemaker state variable #2 (y-axis) */
  /*        increment: The shortest light treatment time interval (seconds) */
  /*        targetReferencePhaseTime: The target time for the reference phase */
  /*        lightLevel: The level of light used for the perscription pulse(CS) */
  /*        nDaysPlan: The number of days covered by the light schedule */
  /*         */
  /*    Output: */
  /*        treatmentStartTimes: An array of treatment start times */
  /*        treatDurations: An array of treatment durations corresponding to  */
  /*        the treatmentStartTimes */
  /*  Create loop variables */
  memset(&lightScheduleArray[0], 0, (unsigned int) LRCtreatmentSize * sizeof(double));

  /*  Force the start time to be on the increment */
  t1 = floor(t0 / 900.0) * 900.0;
  t2 = t1 + 900.0;

  /*  Loop */
  for (idx = 0; idx < LRCtreatmentSize; idx++) {
    /*  Create Target sinosoid */
    if (LRCisAvail(unavailability_startTimeUTC, unavailability_durationSecs, t1,
                   t2)) {
      /*  Simulate increment of time by running the model with no light */
      rk4stepperSec(x0, xc0, 0.0, t1, t2, &xfDark, &xcfDark);

      /*  Simulate increment of time by running the model with light at the */
      /*  prescribed light level */
      rk4stepperSec(x0, xc0, LRCtreatmentCS, t1, t2, &xfLight, &xcfLight);

      /*  Create phasor angles */
      t1 = b_mod(atan2(sin(6.2831853071795862 * (t1 / 86400.0 -
        targetReferencePhaseTime / 86400.0)), -cos(6.2831853071795862 * (t1 /
        86400.0 - targetReferencePhaseTime / 86400.0))) + 3.1415926535897931,
                 6.2831853071795862);

      /* Angle at target point */
      /* Angle at predicted light point */
      /* Angle at predicted without light point */
      /*  Determine phase difference with and without light */
      /*  Choose best plan */
      if (3.1415926535897931 - fabs(fabs(t1 - b_mod(atan2(xcfLight, xfLight) +
             3.1415926535897931, 6.2831853071795862)) - 3.1415926535897931) <
          3.1415926535897931 - fabs(fabs(t1 - b_mod(atan2(xcfDark, xfDark) +
             3.1415926535897931, 6.2831853071795862)) - 3.1415926535897931)) {
        lightScheduleArray[idx] = 0.4;
        x0 = xfLight;
        xc0 = xcfLight;
      } else {
        lightScheduleArray[idx] = 0.0;
        x0 = xfDark;
        xc0 = xcfDark;
      }
    } else {
      /*  Simulate increment of time by running the model with no light */
      rk4stepperSec(x0, xc0, 0.0, t1, t2, &xfDark, &xcfDark);
      lightScheduleArray[idx] = 0.0;
      x0 = xfDark;
      xc0 = xcfDark;
    }

    /*  Update loop variables */
    t1 = t2;
    t2 += 900.0;
  }

  /*  Convert lightScheduleArray to treatment start times and durations */
  for (i1 = 0; i1 < LRCtreatmentSize; i1++) {
    time[i1] = 900.0 * (double)i1 + t0;
  }

  idx = 0;
  ii = 1;
  exitg4 = FALSE;
  while ((exitg4 == FALSE) && (ii < LRCtreatmentSize+1)) {
    guard4 = FALSE;
    if (lightScheduleArray[ii - 1] != 0.0) {
      idx++;
      ii_data[idx - 1] = (unsigned char)ii;
      if (idx >= LRCtreatmentSize) {
        exitg4 = TRUE;
      } else {
        guard4 = TRUE;
      }
    } else {
      guard4 = TRUE;
    }

    if (guard4 == TRUE) {
      ii++;
    }
  }

  if (1 > idx) {
    loop_ub = 0;
  } else {
    loop_ub = idx;
  }

  for (i1 = 0; i1 < loop_ub; i1++) {
    b_ii_data[i1] = ii_data[i1];
  }

  for (i1 = 0; i1 < loop_ub; i1++) {
    ii_data[i1] = b_ii_data[i1];
  }

  q_size[0] = loop_ub;
  for (i1 = 0; i1 < loop_ub; i1++) {
    q_data[i1] = ii_data[i1];
  }

  if (!(q_size[0] == 0)) {
    b_emxInit_real_T(&r8, 2);
    b_q_data.data = (double *)&q_data;
    b_q_data.size = (int *)&q_size;
    b_q_data.allocatedSize = LRCtreatmentSize;
    b_q_data.numDimensions = 1;
    b_q_data.canFreeData = FALSE;
    diff(&b_q_data, r8);
    idx = r8->size[0];
    ii = r8->size[1];
    loop_ub = r8->size[0] * r8->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      qdiff_data[i1] = r8->data[i1];
    }

    emxFree_real_T(&r8);
    loop_ub = idx * ii;
    for (i1 = 0; i1 < loop_ub; i1++) {
      x_data[i1] = (qdiff_data[i1] > 1.0);
    }

    nx = idx * ii;
    idx = 0;
    ii = 1;
    exitg3 = FALSE;
    while ((exitg3 == FALSE) && (ii <= nx)) {
      guard3 = FALSE;
      if (x_data[ii - 1]) {
        idx++;
        c_ii_data[idx - 1] = ii;
        if (idx >= nx) {
          exitg3 = TRUE;
        } else {
          guard3 = TRUE;
        }
      } else {
        guard3 = TRUE;
      }

      if (guard3 == TRUE) {
        ii++;
      }
    }

    if (nx == 1) {
      if (idx == 0) {
        nx = 0;
      }
    } else {
      if (1 > idx) {
        nx = 0;
      } else {
        nx = idx;
      }

      for (i1 = 0; i1 < nx; i1++) {
        d_ii_data[i1] = c_ii_data[i1];
      }

      for (i1 = 0; i1 < nx; i1++) {
        c_ii_data[i1] = d_ii_data[i1];
      }
    }

    for (i1 = 0; i1 < nx; i1++) {
      startTimes_data[i1] = time[(int)q_data[c_ii_data[i1]] - 1];
    }

    time[0] = time[(int)q_data[0] - 1];
    for (i1 = 0; i1 < nx; i1++) {
      time[i1 + 1] = startTimes_data[i1];
    }

    loop_ub = 1 + nx;
    for (i1 = 0; i1 < loop_ub; i1++) {
      startTimes_data[i1] = time[i1];
    }

    /*  pad lightScheduleArray with zeros at start and end in order to find */
    /*  treatment durations that start (or end) at first (last) array element. */
    dv0[0] = 0.0;
    memcpy(&dv0[1], &lightScheduleArray[0], (unsigned int) LRCtreatmentSize * sizeof(double));
    dv0[LRCtreatmentSize] = 0.0;
    b_diff(dv0, dv1);
    for (idx = 0; idx < LRCtreatmentSize+1; idx++) {
      x[idx] = (dv1[idx] < 0.0);
    }

    idx = 0;
    ii = 1;
    exitg2 = FALSE;
    while ((exitg2 == FALSE) && (ii < LRCtreatmentSize+2)) {
      guard2 = FALSE;
      if (x[ii - 1]) {
        idx++;
        e_ii_data[idx - 1] = (unsigned char)ii;
        if (idx >= LRCtreatmentSize+1) {
          exitg2 = TRUE;
        } else {
          guard2 = TRUE;
        }
      } else {
        guard2 = TRUE;
      }

      if (guard2 == TRUE) {
        ii++;
      }
    }

    if (1 > idx) {
      loop_ub = 0;
    } else {
      loop_ub = idx;
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      f_ii_data[i1] = e_ii_data[i1];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      e_ii_data[i1] = f_ii_data[i1];
    }

    dv2[0] = 0.0;
    memcpy(&dv2[1], &lightScheduleArray[0], (unsigned int) LRCtreatmentSize * sizeof(double));
    dv2[LRCtreatmentSize+1] = 0.0;
    b_diff(dv2, dv1);
    for (idx = 0; idx < LRCtreatmentSize+1; idx++) {
      x[idx] = (dv1[idx] > 0.0);
    }

    idx = 0;
    ii = 1;
    exitg1 = FALSE;
    while ((exitg1 == FALSE) && (ii < LRCtreatmentSize+2)) {
      guard1 = FALSE;
      if (x[ii - 1]) {
        idx++;
        f_ii_data[idx - 1] = (unsigned char)ii;
        if (idx >= LRCtreatmentSize+1) {
          exitg1 = TRUE;
        } else {
          guard1 = TRUE;
        }
      } else {
        guard1 = TRUE;
      }

      if (guard1 == TRUE) {
        ii++;
      }
    }

    if (1 > idx) {
      idx = 0;
    }

    for (i1 = 0; i1 < idx; i1++) {
      g_ii_data[i1] = f_ii_data[i1];
    }

    for (i1 = 0; i1 < idx; i1++) {
      f_ii_data[i1] = g_ii_data[i1];
    }

    *scheduleStruct_n = 1 + nx;
    c_scheduleStruct_startTimeUTC_s[0] = 1 + nx;
    idx = 1 + nx;
    for (i1 = 0; i1 < idx; i1++) {
      c_scheduleStruct_startTimeUTC_d[i1] = startTimes_data[i1];
    }

    c_scheduleStruct_durationMins_s[0] = loop_ub;
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_scheduleStruct_durationMins_d[i1] = 900.0 * (double)(e_ii_data[i1] -
        f_ii_data[i1]) / 60.0;
    }
  } else {
    /*      scheduleStruct.startTimeUTC = []; */
    /*      scheduleStruct.durationMins = []; */
    *scheduleStruct_n = 0.0;
    c_scheduleStruct_startTimeUTC_s[0] = 1;
    c_scheduleStruct_startTimeUTC_d[0] = 0.0;
    c_scheduleStruct_durationMins_s[0] = 1;
    c_scheduleStruct_durationMins_d[0] = 0.0;
  }
}

/* End of code generation (createlightschedule.c) */
