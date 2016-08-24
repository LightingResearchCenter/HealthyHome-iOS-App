/*
 * blackbox_emxutil.h
 *
 * Code generation for function 'blackbox_emxutil'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __BLACKBOX_EMXUTIL_H__
#define __BLACKBOX_EMXUTIL_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "rtwtypes.h"
#include "blackbox_types.h"

/* Function Declarations */
extern void b_emxInit_boolean_T(emxArray_boolean_T **pEmxArray, int numDimensions);
extern void b_emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);
extern void emxEnsureCapacity(emxArray__common *emxArray, int oldNumel, int elementSize);
extern void emxFree_boolean_T(emxArray_boolean_T **pEmxArray);
extern void emxFree_int32_T(emxArray_int32_T **pEmxArray);
extern void emxFree_real_T(emxArray_real_T **pEmxArray);
extern void emxInit_boolean_T(emxArray_boolean_T **pEmxArray, int numDimensions);
extern void emxInit_int32_T(emxArray_int32_T **pEmxArray, int numDimensions);
extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);
#endif
/* End of code generation (blackbox_emxutil.h) */
