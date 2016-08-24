/*
 * cos.c
 *
 * Code generation for function 'cos'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "cos.h"

/* Function Definitions */
void b_cos(emxArray_real_T *x)
{
  int i2;
  int k;
  i2 = x->size[0];
  for (k = 0; k < i2; k++) {
    x->data[k] = cos(x->data[k]);
  }
}

/* End of code generation (cos.c) */
