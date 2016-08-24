/*
 * bedWakeTimes2TargetPhase.c
 *
 * Code generation for function 'bedWakeTimes2TargetPhase'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "bedWakeTimes2TargetPhase.h"

/* Function Definitions */
double bedWakeTimes2TargetPhase(double bedTime, double wakeTime)
{
  double targetPhase;
  double x;
  x = wakeTime - bedTime;
  x = bedTime + (x - floor(x / 24.0) * 24.0) / 2.0;
  targetPhase = ((x - floor(x / 24.0) * 24.0) + 1.5) * 3600.0;

  /*  seconds, 0 <= targetPhase < 86400 */
  return targetPhase;
}

/* End of code generation (bedWakeTimes2TargetPhase.c) */
