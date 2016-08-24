/*
 * LRCcosinorFit.c
 *
 * Code generation for function 'LRCcosinorFit'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCcosinorFit.h"
#include "sum.h"
#include "blackbox_emxutil.h"
#include "mldivide.h"
#include "sin.h"
#include "cos.h"

/* Function Definitions */
void LRCcosinorFit(const emxArray_real_T *timeArraySec, const emxArray_real_T
                   *valueArray, double *mesor, double *amplitude, double *phi)
{
  double C[9];
  double D[3];
  int i0;
  emxArray_real_T *xj;
  int loop_ub;
  emxArray_real_T *zj;
  emxArray_real_T *r5;
  emxArray_real_T *r6;
  int unnamed_idx_0;
  int b_unnamed_idx_0;
  emxArray_real_T *r7;
  emxArray_real_T *yj;
  emxArray_real_T *b_xj;
  emxArray_real_T *c_xj;
  emxArray_real_T *b_zj;
  emxArray_real_T *c_zj;
  emxArray_real_T *b_yj;
  emxArray_real_T *c_yj;
  double x[3];

  /*  LRCCOSINORFIT Simplified cosinor fit */
  /*    time is the timestamps in seconds */
  /*    value is the set of values you're fitting */
  /*  preallocate variables */
  memset(&C[0], 0, 9U * sizeof(double));
  for (i0 = 0; i0 < 3; i0++) {
    D[i0] = 0.0;
  }

  emxInit_real_T(&xj, 1);
  i0 = xj->size[0];
  xj->size[0] = timeArraySec->size[0];
  emxEnsureCapacity((emxArray__common *)xj, i0, (int)sizeof(double));
  loop_ub = timeArraySec->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    xj->data[i0] = 0.0;
  }

  emxInit_real_T(&zj, 1);
  i0 = zj->size[0];
  zj->size[0] = timeArraySec->size[0];
  emxEnsureCapacity((emxArray__common *)zj, i0, (int)sizeof(double));
  loop_ub = timeArraySec->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    zj->data[i0] = 0.0;
  }

  emxInit_real_T(&r5, 1);

  /* yj=zeros(ll,2); */
  i0 = r5->size[0];
  r5->size[0] = timeArraySec->size[0];
  emxEnsureCapacity((emxArray__common *)r5, i0, (int)sizeof(double));
  loop_ub = timeArraySec->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    r5->data[i0] = 7.27220521664304E-5 * timeArraySec->data[i0];
  }

  b_cos(r5);
  loop_ub = r5->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    xj->data[i0] = r5->data[i0];
  }

  i0 = r5->size[0];
  r5->size[0] = timeArraySec->size[0];
  emxEnsureCapacity((emxArray__common *)r5, i0, (int)sizeof(double));
  loop_ub = timeArraySec->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    r5->data[i0] = 7.27220521664304E-5 * timeArraySec->data[i0];
  }

  b_sin(r5);
  loop_ub = r5->size[0];
  for (i0 = 0; i0 < loop_ub; i0++) {
    zj->data[i0] = r5->data[i0];
  }

  emxFree_real_T(&r5);
  emxInit_real_T(&r6, 1);
  unnamed_idx_0 = xj->size[0];
  b_unnamed_idx_0 = xj->size[0];
  i0 = r6->size[0];
  r6->size[0] = unnamed_idx_0;
  emxEnsureCapacity((emxArray__common *)r6, i0, (int)sizeof(double));
  for (i0 = 0; i0 < unnamed_idx_0; i0++) {
    r6->data[i0] = 0.0;
  }

  emxInit_real_T(&r7, 1);
  i0 = r7->size[0];
  r7->size[0] = b_unnamed_idx_0;
  emxEnsureCapacity((emxArray__common *)r7, i0, (int)sizeof(double));
  for (i0 = 0; i0 < b_unnamed_idx_0; i0++) {
    r7->data[i0] = 0.0;
  }

  b_emxInit_real_T(&yj, 2);
  i0 = yj->size[0] * yj->size[1];
  yj->size[0] = unnamed_idx_0;
  yj->size[1] = 2;
  emxEnsureCapacity((emxArray__common *)yj, i0, (int)sizeof(double));
  for (i0 = 0; i0 < unnamed_idx_0; i0++) {
    yj->data[i0] = r6->data[i0];
  }

  emxFree_real_T(&r6);
  for (i0 = 0; i0 < b_unnamed_idx_0; i0++) {
    yj->data[i0 + yj->size[0]] = r7->data[i0];
  }

  emxFree_real_T(&r7);
  loop_ub = xj->size[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    yj->data[i0] = xj->data[i0];
  }

  loop_ub = zj->size[0] - 1;
  for (i0 = 0; i0 <= loop_ub; i0++) {
    yj->data[i0 + yj->size[0]] = zj->data[i0];
  }

  emxInit_real_T(&b_xj, 1);
  C[0] = timeArraySec->size[0];
  loop_ub = xj->size[0];
  i0 = b_xj->size[0];
  b_xj->size[0] = loop_ub;
  emxEnsureCapacity((emxArray__common *)b_xj, i0, (int)sizeof(double));
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_xj->data[i0] = xj->data[i0];
  }

  emxInit_real_T(&c_xj, 1);
  C[3] = sum(b_xj);
  loop_ub = xj->size[0];
  i0 = c_xj->size[0];
  c_xj->size[0] = loop_ub;
  emxEnsureCapacity((emxArray__common *)c_xj, i0, (int)sizeof(double));
  emxFree_real_T(&b_xj);
  for (i0 = 0; i0 < loop_ub; i0++) {
    c_xj->data[i0] = xj->data[i0];
  }

  emxFree_real_T(&xj);
  emxInit_real_T(&b_zj, 1);
  C[1] = sum(c_xj);
  loop_ub = zj->size[0];
  i0 = b_zj->size[0];
  b_zj->size[0] = loop_ub;
  emxEnsureCapacity((emxArray__common *)b_zj, i0, (int)sizeof(double));
  emxFree_real_T(&c_xj);
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_zj->data[i0] = zj->data[i0];
  }

  emxInit_real_T(&c_zj, 1);
  C[6] = sum(b_zj);
  loop_ub = zj->size[0];
  i0 = c_zj->size[0];
  c_zj->size[0] = loop_ub;
  emxEnsureCapacity((emxArray__common *)c_zj, i0, (int)sizeof(double));
  emxFree_real_T(&b_zj);
  for (i0 = 0; i0 < loop_ub; i0++) {
    c_zj->data[i0] = zj->data[i0];
  }

  emxFree_real_T(&zj);
  C[2] = sum(c_zj);
  emxFree_real_T(&c_zj);
  emxInit_real_T(&b_yj, 1);
  for (unnamed_idx_0 = 0; unnamed_idx_0 < 2; unnamed_idx_0++) {
    for (b_unnamed_idx_0 = 0; b_unnamed_idx_0 < 2; b_unnamed_idx_0++) {
      loop_ub = yj->size[0];
      i0 = b_yj->size[0];
      b_yj->size[0] = loop_ub;
      emxEnsureCapacity((emxArray__common *)b_yj, i0, (int)sizeof(double));
      for (i0 = 0; i0 < loop_ub; i0++) {
        b_yj->data[i0] = yj->data[i0 + yj->size[0] * unnamed_idx_0] * yj->
          data[i0 + yj->size[0] * b_unnamed_idx_0];
      }

      C[(unnamed_idx_0 + 3 * (b_unnamed_idx_0 + 1)) + 1] = sum(b_yj);
    }
  }

  emxFree_real_T(&b_yj);
  D[0] = sum(valueArray);
  emxInit_real_T(&c_yj, 1);
  for (unnamed_idx_0 = 0; unnamed_idx_0 < 2; unnamed_idx_0++) {
    loop_ub = yj->size[0];
    i0 = c_yj->size[0];
    c_yj->size[0] = loop_ub;
    emxEnsureCapacity((emxArray__common *)c_yj, i0, (int)sizeof(double));
    for (i0 = 0; i0 < loop_ub; i0++) {
      c_yj->data[i0] = yj->data[i0 + yj->size[0] * unnamed_idx_0] *
        valueArray->data[i0];
    }

    D[unnamed_idx_0 + 1] = sum(c_yj);
  }

  emxFree_real_T(&c_yj);
  emxFree_real_T(&yj);
  mldivide(C, D, x);
  *mesor = x[0];
  *amplitude = sqrt(x[1] * x[1] + x[2] * x[2]);
  *phi = -atan2(x[2], x[1]);
}

/* End of code generation (LRCcosinorFit.c) */
