/*
 * sin.c
 *
 * Code generation for function 'sin'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "sin.h"

/* Function Definitions */
void b_sin(emxArray_real_T *x)
{
  int i3;
  int k;
  i3 = x->size[0];
  for (k = 0; k < i3; k++) {
    x->data[k] = sin(x->data[k]);
  }
}

/* End of code generation (sin.c) */
