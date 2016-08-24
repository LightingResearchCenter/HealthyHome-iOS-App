/*
 * blackbox_emxAPI.h
 *
 * Code generation for function 'blackbox_emxAPI'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __BLACKBOX_EMXAPI_H__
#define __BLACKBOX_EMXAPI_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "rtwtypes.h"
#include "blackbox_types.h"

/* Function Declarations */
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapperND_real_T(double *data, int numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows, int cols);
extern emxArray_real_T *emxCreate_real_T(int rows, int cols);
extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);
#endif
/* End of code generation (blackbox_emxAPI.h) */
