/*
 * LRCisAvail.c
 *
 * Code generation for function 'LRCisAvail'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCisAvail.h"

/* Function Definitions */
boolean_T LRCisAvail(const double unavailability_startTimeUTC[4], const double
                     unavailability_durationSecs[4], double t1, double t2)
{
  boolean_T tf;
  double unavailEnd[4];
  int i;
  boolean_T exitg1;

  /* LRCISAVAIL Summary of this function goes here */
  /*    Detailed explanation goes here */
  for (i = 0; i < 4; i++) {
    unavailEnd[i] = unavailability_startTimeUTC[i] +
      unavailability_durationSecs[i];
  }

  /*  Test that t1 and t2 do not overlap with any unavailable times */
  tf = TRUE;
  i = 0;
  exitg1 = FALSE;
  while ((exitg1 == FALSE) && (i < 4)) {
    if (((unavailEnd[i] <= t1) || (unavailability_startTimeUTC[i] >= t2)) == 0)
    {
      tf = FALSE;
      exitg1 = TRUE;
    } else {
      i++;
    }
  }

  return tf;
}

/* End of code generation (LRCisAvail.c) */
