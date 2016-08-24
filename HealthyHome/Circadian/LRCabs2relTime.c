/*
 * LRCabs2relTime.c
 *
 * Code generation for function 'LRCabs2relTime'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCabs2relTime.h"

/* Function Definitions */
double LRCabs2relTime(double absTime)
{
  /* LRCABS2RELTIME Convert absolute time to time of day */
  /*    Input and output are in units of seconds */
  return absTime - floor(absTime / 86400.0) * 86400.0;
}

/* End of code generation (LRCabs2relTime.c) */
