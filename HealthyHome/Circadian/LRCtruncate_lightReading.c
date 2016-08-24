/*
 * LRCtruncate_lightReading.c
 *
 * Code generation for function 'LRCtruncate_lightReading'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCtruncate_lightReading.h"
#include "blackbox_emxutil.h"
#include "config.h"

/* Function Definitions */
void LRCtruncate_lightReading(const emxArray_real_T *lightReading_timeUTC,
                              const emxArray_real_T *lightReading_timeOffset,
                              const emxArray_real_T *lightReading_red,
                              const emxArray_real_T *lightReading_green,
                              const emxArray_real_T *lightReading_blue,
                              const emxArray_real_T *lightReading_clear,
                              const emxArray_real_T *lightReading_cla,
                              const emxArray_real_T *lightReading_cs,
                              emxArray_real_T *lightReadingTrunc_timeUTC,
                              emxArray_real_T *lightReadingTrunc_timeOffset,
                              emxArray_real_T *lightReadingTrunc_red,
                              emxArray_real_T *lightReadingTrunc_green,
                              emxArray_real_T *lightReadingTrunc_blue,
                              emxArray_real_T *lightReadingTrunc_clear,
                              emxArray_real_T *lightReadingTrunc_cla,
                              emxArray_real_T *lightReadingTrunc_cs)
{
  double mtmp;
  int ix;
  emxArray_boolean_T *idx;
  int loop_ub;
  emxArray_int32_T *r1;

  /* LRCTRUNCATE_LIGHTREADING Truncate lightReading */
  /*    Discards readings older than the specified duration. One of the fields */
  /*    must be timeUTC. All fields must be vectors of equal length. */
  mtmp = lightReading_timeUTC->data[0];
  if ((lightReading_timeUTC->size[0] > 1) && (1 < lightReading_timeUTC->size[0]))
  {
    for (ix = 1; ix + 1 <= lightReading_timeUTC->size[0]; ix++) {
      if (lightReading_timeUTC->data[ix] > mtmp) {
        mtmp = lightReading_timeUTC->data[ix];
      }
    }
  }

  emxInit_boolean_T(&idx, 1);
  ix = idx->size[0];
  idx->size[0] = lightReading_timeUTC->size[0];
  emxEnsureCapacity((emxArray__common *)idx, ix, (int)sizeof(boolean_T));
  loop_ub = lightReading_timeUTC->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    idx->data[ix] = (lightReading_timeUTC->data[ix] >= mtmp - LRCreadingDuration);
  }

  emxInit_int32_T(&r1, 1);
  eml_li_find(idx, r1);
  ix = lightReadingTrunc_timeUTC->size[0];
  lightReadingTrunc_timeUTC->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_timeUTC, ix, (int)
                    sizeof(double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_timeUTC->data[ix] = lightReading_timeUTC->data[r1->data[ix]
      - 1];
  }

  eml_li_find(idx, r1);
  ix = lightReadingTrunc_timeOffset->size[0];
  lightReadingTrunc_timeOffset->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_timeOffset, ix, (int)
                    sizeof(double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_timeOffset->data[ix] = lightReading_timeOffset->data
      [r1->data[ix] - 1];
  }

  eml_li_find(idx, r1);
  ix = lightReadingTrunc_red->size[0];
  lightReadingTrunc_red->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_red, ix, (int)sizeof
                    (double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_red->data[ix] = lightReading_red->data[r1->data[ix] - 1];
  }

  eml_li_find(idx, r1);
  ix = lightReadingTrunc_green->size[0];
  lightReadingTrunc_green->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_green, ix, (int)sizeof
                    (double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_green->data[ix] = lightReading_green->data[r1->data[ix] -
      1];
  }

  eml_li_find(idx, r1);
  ix = lightReadingTrunc_blue->size[0];
  lightReadingTrunc_blue->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_blue, ix, (int)sizeof
                    (double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_blue->data[ix] = lightReading_blue->data[r1->data[ix] - 1];
  }

   
  eml_li_find(idx, r1);
  ix = lightReadingTrunc_clear->size[0];
  lightReadingTrunc_clear->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_clear, ix, (int)sizeof
                      (double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_clear->data[ix] = lightReading_clear->data[r1->data[ix] - 1];
  }
    
  eml_li_find(idx, r1);
  ix = lightReadingTrunc_cla->size[0];
  lightReadingTrunc_cla->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_cla, ix, (int)sizeof
                    (double));
  loop_ub = r1->size[0];
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_cla->data[ix] = lightReading_cla->data[r1->data[ix] - 1];
  }

  eml_li_find(idx, r1);
  ix = lightReadingTrunc_cs->size[0];
  lightReadingTrunc_cs->size[0] = r1->size[0];
  emxEnsureCapacity((emxArray__common *)lightReadingTrunc_cs, ix, (int)sizeof
                    (double));
  loop_ub = r1->size[0];
  emxFree_boolean_T(&idx);
  for (ix = 0; ix < loop_ub; ix++) {
    lightReadingTrunc_cs->data[ix] = lightReading_cs->data[r1->data[ix] - 1];
  }

  emxFree_int32_T(&r1);
}

/* End of code generation (LRCtruncate_lightReading.c) */
