/*
 * LRCgapFill.c
 *
 * Code generation for function 'LRCgapFill'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "LRCgapFill.h"
#include "mod.h"
#include "blackbox_emxutil.h"
#include "diff.h"
#include "blackbox_rtwutil.h"
#include "config.h"

/* Function Definitions */
void LRCgapFill(const emxArray_real_T *timeUTC, const emxArray_real_T *cs,
                emxArray_real_T *newTimeUTC, emxArray_real_T *newCs)
{
  emxArray_real_T *sampleDiff;
  int high_i;
  int nm1d2;
  int ixright;
  int k;
  emxArray_boolean_T *gap;
  emxArray_boolean_T *b_gap;
  emxArray_real_T *gapStart;
  emxArray_int32_T *r3;
  emxArray_boolean_T *r4;
  emxArray_real_T *gapEnd;
  double anew;
  double apnd;
  double ndbl;
  double cdiff;
  double absa;
  double absb;
  emxArray_real_T *y;
  emxArray_real_T *b_y;
  emxArray_real_T *x;
  unsigned int outsize_idx_0;
  int mid_i;
  emxArray_boolean_T *b_newTimeUTC;
  b_emxInit_real_T(&sampleDiff, 2);

  /* LRCGAPFILL Resample data to evenly spaced increments filling gaps with 0s. */
  /*    expectedInc must be in the same units as timeUTC */
  /*    timeUTC and cs must be vertical vectors with at least 2 entries */
  /*  Find the time between samples */
  diff(timeUTC, sampleDiff);
  high_i = sampleDiff->size[0] * sampleDiff->size[1];
  emxEnsureCapacity((emxArray__common *)sampleDiff, high_i, (int)sizeof(double));
  nm1d2 = sampleDiff->size[0];
  ixright = sampleDiff->size[1];
  nm1d2 *= ixright;
  for (high_i = 0; high_i < nm1d2; high_i++) {
    sampleDiff->data[high_i] /= LRClightSampleInc;
  }

  high_i = sampleDiff->size[0] * sampleDiff->size[1];
  for (k = 0; k < high_i; k++) {
    sampleDiff->data[k] = rt_roundd(sampleDiff->data[k]);
  }

  b_emxInit_boolean_T(&gap, 2);

  /*  Multiples of increment */
  /*  Find large gaps between samples */
  high_i = gap->size[0] * gap->size[1];
  gap->size[0] = sampleDiff->size[0];
  gap->size[1] = sampleDiff->size[1];
  emxEnsureCapacity((emxArray__common *)gap, high_i, (int)sizeof(boolean_T));
  nm1d2 = sampleDiff->size[0] * sampleDiff->size[1];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    gap->data[high_i] = (sampleDiff->data[high_i] > 1.0);
  }

  emxFree_real_T(&sampleDiff);
  emxInit_boolean_T(&b_gap, 1);

  /*  Effectively true if sampleDiff is 2 or greater */
  high_i = b_gap->size[0];
  b_gap->size[0] = gap->size[0] + 1;
  emxEnsureCapacity((emxArray__common *)b_gap, high_i, (int)sizeof(boolean_T));
  nm1d2 = gap->size[0];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    b_gap->data[high_i] = gap->data[high_i];
  }

  emxInit_real_T(&gapStart, 1);
  emxInit_int32_T(&r3, 1);
  b_gap->data[gap->size[0]] = FALSE;
  eml_li_find(b_gap, r3);
  high_i = gapStart->size[0];
  gapStart->size[0] = r3->size[0];
  emxEnsureCapacity((emxArray__common *)gapStart, high_i, (int)sizeof(double));
  nm1d2 = r3->size[0];
  emxFree_boolean_T(&b_gap);
  for (high_i = 0; high_i < nm1d2; high_i++) {
    gapStart->data[high_i] = timeUTC->data[r3->data[high_i] - 1];
  }

  emxInit_boolean_T(&r4, 1);

  /*  Start time of each gap */
  high_i = r4->size[0];
  r4->size[0] = 1 + gap->size[0];
  emxEnsureCapacity((emxArray__common *)r4, high_i, (int)sizeof(boolean_T));
  r4->data[0] = FALSE;
  nm1d2 = gap->size[0];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    r4->data[high_i + 1] = gap->data[high_i];
  }

  emxFree_boolean_T(&gap);
  emxInit_real_T(&gapEnd, 1);
  eml_li_find(r4, r3);
  high_i = gapEnd->size[0];
  gapEnd->size[0] = r3->size[0];
  emxEnsureCapacity((emxArray__common *)gapEnd, high_i, (int)sizeof(double));
  nm1d2 = r3->size[0];
  emxFree_boolean_T(&r4);
  for (high_i = 0; high_i < nm1d2; high_i++) {
    gapEnd->data[high_i] = timeUTC->data[r3->data[high_i] - 1];
  }

  /*  End time of each gap */
  /*  Number of gaps */
  /*  Create evenly spaced time array */
  if (timeUTC->data[timeUTC->size[0] - 1] < timeUTC->data[0]) {
    ixright = -1;
    anew = timeUTC->data[0];
    apnd = timeUTC->data[timeUTC->size[0] - 1];
  } else {
    anew = timeUTC->data[0];
    ndbl = floor((timeUTC->data[timeUTC->size[0] - 1] - timeUTC->data[0]) / LRClightSampleInc
                 + 0.5);
    apnd = timeUTC->data[0] + ndbl * LRClightSampleInc;
    cdiff = apnd - timeUTC->data[timeUTC->size[0] - 1];
    absa = fabs(timeUTC->data[0]);
    absb = fabs(timeUTC->data[timeUTC->size[0] - 1]);
    if (absa >= absb) {
      absb = absa;
    }

    if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
      ndbl++;
      apnd = timeUTC->data[timeUTC->size[0] - 1];
    } else if (cdiff > 0.0) {
      apnd = timeUTC->data[0] + (ndbl - 1.0) * LRClightSampleInc;
    } else {
      ndbl++;
    }

    if (ndbl >= 0.0) {
      ixright = (int)ndbl - 1;
    } else {
      ixright = -1;
    }
  }

  b_emxInit_real_T(&y, 2);
  high_i = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = ixright + 1;
  emxEnsureCapacity((emxArray__common *)y, high_i, (int)sizeof(double));
  if (ixright + 1 > 0) {
    y->data[0] = anew;
    if (ixright + 1 > 1) {
      y->data[ixright] = apnd;
      nm1d2 = ixright / 2;
      for (k = 1; k < nm1d2; k++) {
        cdiff = (double)k * LRClightSampleInc;
        y->data[k] = anew + cdiff;
        y->data[ixright - k] = apnd - cdiff;
      }

      if (nm1d2 << 1 == ixright) {
        y->data[nm1d2] = (anew + apnd) / 2.0;
      } else {
        cdiff = (double)nm1d2 * LRClightSampleInc;
        y->data[nm1d2] = anew + cdiff;
        y->data[nm1d2 + 1] = apnd - cdiff;
      }
    }
  }

  high_i = newTimeUTC->size[0];
  newTimeUTC->size[0] = y->size[1];
  emxEnsureCapacity((emxArray__common *)newTimeUTC, high_i, (int)sizeof(double));
  nm1d2 = y->size[1];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    newTimeUTC->data[high_i] = y->data[y->size[0] * high_i];
  }

  emxFree_real_T(&y);
  emxInit_real_T(&b_y, 1);

  /*  Resample the data to evenly spaced increments */
  high_i = b_y->size[0];
  b_y->size[0] = cs->size[0];
  emxEnsureCapacity((emxArray__common *)b_y, high_i, (int)sizeof(double));
  nm1d2 = cs->size[0];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    b_y->data[high_i] = cs->data[high_i];
  }

  emxInit_real_T(&x, 1);
  high_i = x->size[0];
  x->size[0] = timeUTC->size[0];
  emxEnsureCapacity((emxArray__common *)x, high_i, (int)sizeof(double));
  nm1d2 = timeUTC->size[0];
  for (high_i = 0; high_i < nm1d2; high_i++) {
    x->data[high_i] = timeUTC->data[high_i];
  }

  outsize_idx_0 = (unsigned int)newTimeUTC->size[0];
  high_i = newCs->size[0];
  newCs->size[0] = (int)outsize_idx_0;
  emxEnsureCapacity((emxArray__common *)newCs, high_i, (int)sizeof(double));
  nm1d2 = (int)outsize_idx_0;
  for (high_i = 0; high_i < nm1d2; high_i++) {
    newCs->data[high_i] = 0.0;
  }

  if (newTimeUTC->size[0] == 0) {
  } else {
    if (timeUTC->data[1] < timeUTC->data[0]) {
      high_i = timeUTC->size[0] >> 1;
      for (nm1d2 = 1; nm1d2 <= high_i; nm1d2++) {
        cdiff = x->data[nm1d2 - 1];
        x->data[nm1d2 - 1] = x->data[timeUTC->size[0] - nm1d2];
        x->data[timeUTC->size[0] - nm1d2] = cdiff;
      }

      if ((!(cs->size[0] == 0)) && (cs->size[0] > 1)) {
        nm1d2 = 0;
        for (ixright = cs->size[0]; nm1d2 + 1 < ixright; ixright--) {
          cdiff = b_y->data[nm1d2];
          b_y->data[nm1d2] = b_y->data[ixright - 1];
          b_y->data[ixright - 1] = cdiff;
          nm1d2++;
        }
      }
    }

    for (k = 0; k + 1 <= newTimeUTC->size[0]; k++) {
      if ((newTimeUTC->data[k] > x->data[x->size[0] - 1]) || (newTimeUTC->data[k]
           < x->data[0])) {
      } else {
        ixright = 1;
        nm1d2 = 2;
        high_i = x->size[0];
        while (high_i > nm1d2) {
          mid_i = (ixright >> 1) + (high_i >> 1);
          if (((ixright & 1) == 1) && ((high_i & 1) == 1)) {
            mid_i++;
          }

          if (newTimeUTC->data[k] >= x->data[mid_i - 1]) {
            ixright = mid_i;
            nm1d2 = mid_i + 1;
          } else {
            high_i = mid_i;
          }
        }

        if (ixright == 0) {
        } else {
          cdiff = (newTimeUTC->data[k] - x->data[ixright - 1]) / (x->
            data[ixright] - x->data[ixright - 1]);
          if (b_y->data[ixright - 1] == b_y->data[ixright]) {
            newCs->data[k] = b_y->data[ixright - 1];
          } else {
            newCs->data[k] = (1.0 - cdiff) * b_y->data[ixright - 1] + cdiff *
              b_y->data[ixright];
          }
        }
      }
    }
  }

  emxFree_real_T(&x);
  emxFree_real_T(&b_y);

  /*  If there were large gaps replace the interpolated values with 0 */
  if (gapStart->size[0] > 0) {
    ixright = 0;
    emxInit_boolean_T(&b_newTimeUTC, 1);
    while (ixright <= gapStart->size[0] - 1) {
      cdiff = gapStart->data[ixright];
      ndbl = gapEnd->data[ixright];
      high_i = b_newTimeUTC->size[0];
      b_newTimeUTC->size[0] = newTimeUTC->size[0];
      emxEnsureCapacity((emxArray__common *)b_newTimeUTC, high_i, (int)sizeof
                        (boolean_T));
      nm1d2 = newTimeUTC->size[0];
      for (high_i = 0; high_i < nm1d2; high_i++) {
        b_newTimeUTC->data[high_i] = ((newTimeUTC->data[high_i] > cdiff) &&
          (newTimeUTC->data[high_i] < ndbl));
      }

      eml_li_find(b_newTimeUTC, r3);
      nm1d2 = r3->size[0];
      for (high_i = 0; high_i < nm1d2; high_i++) {
        newCs->data[r3->data[high_i] - 1] = 0.0;
      }

      ixright++;
    }

    emxFree_boolean_T(&b_newTimeUTC);
  }

  emxFree_int32_T(&r3);
  emxFree_real_T(&gapEnd);
  emxFree_real_T(&gapStart);
}

/* End of code generation (LRCgapFill.c) */
