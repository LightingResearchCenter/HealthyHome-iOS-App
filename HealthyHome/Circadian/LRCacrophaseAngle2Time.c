/*
 * LRCacrophaseAngle2Time.c
 *
 * Code generation for function 'LRCacrophaseAngle2Time'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCacrophaseAngle2Time.h"

/* Function Definitions */
double LRCacrophaseAngle2Time(double acrophaseAngle)
{
  double y;

  /* LRCACROPHASEANGLE2TIME Summary of this function goes here */
  /*    Detailed explanation goes here */
  /*  Time of day, in seconds, when acrophase occurs */
  y = -acrophaseAngle / 3.1415926535897931 * 43200.0;
  return y - floor(y / 86400.0) * 86400.0;
}

/* End of code generation (LRCacrophaseAngle2Time.c) */
