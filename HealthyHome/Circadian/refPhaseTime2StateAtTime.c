/*
 * refPhaseTime2StateAtTime.c
 *
 * Code generation for function 'refPhaseTime2StateAtTime'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "refPhaseTime2StateAtTime.h"

/* Function Definitions */
void refPhaseTime2StateAtTime(double refPhaseTime, const double *t, double *x,
  double *xc)
{
  double phi;

  /*  REFPHASETIME2STATEATTIME Converts the state of the oscilator from the time of the referece phase */
  /*  to the state at a particular time t. The function approximates the oscillator as a harmonic oscilator, */
  /*  that is, x = -cos(2*pi*t/86400 + phi), xc = sin(2*pi*t/86400 + phi) */
  /*   */
  /*  */
  /*    Inputs: */
  /*        refPhaseTime: time in units of seconds when the oscilator is at the  */
  /*        reference phase condition (x,xc) = (-1,0). */
  /*        t: relative time of day in units of seconds */
  /*        phaseMarker: one of these values: 'CBTmin','DLMO','bedtime', */
  /*                    'waketime','activityAcrophase' */
  /*  */
  /*    Outputs: */
  /*        t: time in units of seconds */
  /*        x: state variable #1 of the oscillator */
  /*        xc: state vaiables #2 of the oscillator */
  /* % Phase marker reference switch */
  /* disp('activityAcrophase'); */
  /* % Calculate phase state variables */
  phi = (refPhaseTime - 36000.0) * 3.1415926535897931 / 43200.0;

  /*  convert from 24-hour time to radians */
  *x = -cos(6.2831853071795862 * *t / 86400.0 - phi);
  *xc = sin(6.2831853071795862 * *t / 86400.0 - phi);
}

/* End of code generation (refPhaseTime2StateAtTime.c) */
