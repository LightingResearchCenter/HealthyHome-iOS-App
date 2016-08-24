/*
 * LRCtruncate_activityReading.c
 *
 * Code generation for function 'LRCtruncate_activityReading'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCtruncate_activityReading.h"
#include "blackbox_emxutil.h"
#include "config.h"

/* Function Definitions */
void LRCtruncate_activityReading(const emxArray_real_T *acyivityReading_timeUTC,
  const emxArray_real_T *acyivityReading_timeOffset, const emxArray_real_T
  *acyivityReading_activityIndex, const emxArray_real_T
  *acyivityReading_activityCount, emxArray_real_T *activityReadingTrunc_timeUTC,
  emxArray_real_T *activityReadingTrunc_timeOffset, emxArray_real_T
  *c_activityReadingTrunc_activity, emxArray_real_T
  *d_activityReadingTrunc_activity)
{
  double mtmp;
  int ix;
  emxArray_boolean_T *idx;
  int loop_ub;
  emxArray_int32_T *r2;

  /* LRCTRUNCATE_ACTIVITYREADING Truncate activityReading */
  /*    Discards readings older than the specified duration. One of the fields */
  /*    must be timeUTC. All fields must be vectors of equal length. */
  mtmp = acyivityReading_timeUTC->data[0];
  if ((acyivityReading_timeUTC->size[0] > 1) && (1 <
       acyivityReading_timeUTC->size[0])) {
    for (ix = 1; ix + 1 <= acyivityReading_timeUTC->size[0]; ix++) {
      if (acyivityReading_timeUTC->data[ix] > mtmp) {
        mtmp = acyivityReading_timeUTC->data[ix];
      }
    }
  }

  emxInit_boolean_T(&idx, 1);
  ix = idx->size[0];
  idx->size[0] = acyivityReading_timeUTC->size[0];
  emxEnsureCapacity((emxArray__common *)idx, ix, (int)sizeof(boolean_T));
  loop_ub = acyivityReading_timeUTC->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    idx->data[ix] = (acyivityReading_timeUTC->data[ix] >= mtmp - LRCreadingDuration);
  }

  emxInit_int32_T(&r2, 1);
  eml_li_find(idx, r2);
  ix = activityReadingTrunc_timeUTC->size[0];
  activityReadingTrunc_timeUTC->size[0] = r2->size[0];
  emxEnsureCapacity((emxArray__common *)activityReadingTrunc_timeUTC, ix, (int)
                    sizeof(double));
  loop_ub = r2->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    activityReadingTrunc_timeUTC->data[ix] = acyivityReading_timeUTC->data
      [r2->data[ix] - 1];
  }

  eml_li_find(idx, r2);
  ix = activityReadingTrunc_timeOffset->size[0];
  activityReadingTrunc_timeOffset->size[0] = r2->size[0];
  emxEnsureCapacity((emxArray__common *)activityReadingTrunc_timeOffset, ix,
                    (int)sizeof(double));
  loop_ub = r2->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    activityReadingTrunc_timeOffset->data[ix] = acyivityReading_timeOffset->
      data[r2->data[ix] - 1];
  }

  eml_li_find(idx, r2);
  ix = c_activityReadingTrunc_activity->size[0];
  c_activityReadingTrunc_activity->size[0] = r2->size[0];
  emxEnsureCapacity((emxArray__common *)c_activityReadingTrunc_activity, ix,
                    (int)sizeof(double));
  loop_ub = r2->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    c_activityReadingTrunc_activity->data[ix] =
      acyivityReading_activityIndex->data[r2->data[ix] - 1];
  }

  eml_li_find(idx, r2);
  ix = d_activityReadingTrunc_activity->size[0];
  d_activityReadingTrunc_activity->size[0] = r2->size[0];
  emxEnsureCapacity((emxArray__common *)d_activityReadingTrunc_activity, ix,
                    (int)sizeof(double));
  loop_ub = r2->size[0];
  emxFree_boolean_T(&idx);
  for (ix = 0; ix < loop_ub; ix++) {
    d_activityReadingTrunc_activity->data[ix] =
      acyivityReading_activityCount->data[r2->data[ix] - 1];
  }

  emxFree_int32_T(&r2);
}

/* End of code generation (LRCtruncate_activityReading.c) */
