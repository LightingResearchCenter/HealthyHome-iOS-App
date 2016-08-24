/*
 * diff.c
 *
 * Code generation for function 'diff'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "diff.h"
#include "blackbox_emxutil.h"

/* Function Definitions */
void b_diff(const double x[LRCtreatmentSize+2], double y[LRCtreatmentSize+1])
{
  int ixLead;
  int iyLead;
  double work;
  int m;
  double tmp2;
  ixLead = 1;
  iyLead = 0;
  work = x[0];
  for (m = 0; m < LRCtreatmentSize+1; m++) {
    tmp2 = work;
    work = x[ixLead];
    tmp2 = x[ixLead] - tmp2;
    ixLead++;
    y[iyLead] = tmp2;
    iyLead++;
  }
}

void diff(const emxArray_real_T *x, emxArray_real_T *y)
{
  int iyLead;
  int orderForDim;
  emxArray_real_T *b_y1;
  double work_data_idx_0;
  int m;
  double tmp1;
  double tmp2;
  if (x->size[0] == 0) {
    iyLead = y->size[0] * y->size[1];
    y->size[0] = 0;
    y->size[1] = 1;
    emxEnsureCapacity((emxArray__common *)y, iyLead, (int)sizeof(double));
  } else {
    if (x->size[0] - 1 <= 1) {
      orderForDim = x->size[0] - 1;
    } else {
      orderForDim = 1;
    }

    if (orderForDim < 1) {
      iyLead = y->size[0] * y->size[1];
      y->size[0] = 0;
      y->size[1] = 0;
      emxEnsureCapacity((emxArray__common *)y, iyLead, (int)sizeof(double));
    } else {
      emxInit_real_T(&b_y1, 1);
      iyLead = b_y1->size[0];
      b_y1->size[0] = x->size[0] - 1;
      emxEnsureCapacity((emxArray__common *)b_y1, iyLead, (int)sizeof(double));
      orderForDim = x->size[0] - 1;
      if (!(orderForDim == 0)) {
        orderForDim = 1;
        iyLead = 0;
        work_data_idx_0 = x->data[0];
        for (m = 2; m <= x->size[0]; m++) {
          tmp1 = x->data[orderForDim];
          tmp2 = work_data_idx_0;
          work_data_idx_0 = tmp1;
          tmp1 -= tmp2;
          orderForDim++;
          b_y1->data[iyLead] = tmp1;
          iyLead++;
        }
      }

      orderForDim = b_y1->size[0];
      iyLead = y->size[0] * y->size[1];
      y->size[0] = orderForDim;
      emxEnsureCapacity((emxArray__common *)y, iyLead, (int)sizeof(double));
      iyLead = y->size[0] * y->size[1];
      y->size[1] = 1;
      emxEnsureCapacity((emxArray__common *)y, iyLead, (int)sizeof(double));
      orderForDim = b_y1->size[0];
      for (iyLead = 0; iyLead < orderForDim; iyLead++) {
        y->data[iyLead] = b_y1->data[iyLead];
      }

      emxFree_real_T(&b_y1);
    }
  }
}

/* End of code generation (diff.c) */
