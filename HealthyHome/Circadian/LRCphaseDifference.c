/*
 * LRCphaseDifference.c
 *
 * Code generation for function 'LRCphaseDifference'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCphaseDifference.h"

/* Function Definitions */
double LRCphaseDifference(double xcn, double xn, double xcAcrophase, double
  xAcrophase)
{
  double phaseDiff;
  double pacemakerPhase;
  double activityPhase;

  /* LRCPHASEDIFFERENCE Summary of this function goes here */
  /*    Detailed explanation goes here */
  pacemakerPhase = atan2(xcn, xn) * 43200.0 / 3.1415926535897931;
  pacemakerPhase -= floor(pacemakerPhase / 86400.0) * 86400.0;
  activityPhase = atan2(xcAcrophase, xAcrophase) * 43200.0 / 3.1415926535897931;
  activityPhase -= floor(activityPhase / 86400.0) * 86400.0;
  phaseDiff = pacemakerPhase - activityPhase;
  if (phaseDiff > 43200.0) {
    phaseDiff = 43200.0 - phaseDiff;
  } else {
    if (phaseDiff < -43200.0) {
      phaseDiff = -43200.0 - phaseDiff;
    }
  }

  return phaseDiff;
}

/* End of code generation (LRCphaseDifference.c) */
