/*
 * mod.c
 *
 * Code generation for function 'mod'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "mod.h"
#include "blackbox_rtwutil.h"

/* Function Definitions */
double b_mod(double x, double y)
{
  double r;
  if (y == floor(y)) {
    r = x - floor(x / y) * y;
  } else {
    r = x / y;
    if (fabs(r - rt_roundd(r)) <= 2.2204460492503131E-16 * fabs(r)) {
      r = 0.0;
    } else {
      r = (r - floor(r)) * y;
    }
  }

  return r;
}

/* End of code generation (mod.c) */
