/*
 * pacemakerModelRun.c
 *
 * Code generation for function 'pacemakerModelRun'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "pacemakerModelRun.h"
#include "rk4stepperSec.h"
#include "blackbox_emxutil.h"
#include "config.h"
#include "CircadianModel.h"

/* Function Definitions */
int pacemakerModelRun(double t0, double x0, double xc0, const emxArray_real_T
  *lightArray, double *tn, double *xn, double *xcn)
{
  double kd;
  int n;
  double apnd;
  double ndbl;
  double cdiff;
  double absa;
  double absb;
  emxArray_real_T *t1;
  int k;
  int nm1d2;
  emxArray_real_T *t2;

  /*    PACEMAKERMODELRUN runs the LRC's version of the circadian pacemaker  */
  /*    model (based on Kronauer's 1999 paper) using the given light data. */
  /*  */
  /*    Input: */
  /*        t0: The initial relative time of the data in seconds (0.0<=t0<86400) */
  /*        x0: Pacemaker state variable #1 (x-axis) initial value */
  /*        xc0: Pacemaker state variable #2 (y-axis) initial value */
  /*        increment: The time between sequencial lightArray data points in */
  /*        seconds */
  /*        lightArray: an array of CS values */
  /*  */
  /*    Ouput: */
  /*        tf: The final relative time of the data in seconds (0.0<=tf<86400) */
  /*        xf: Pacemaker state variable #1 (x-axix) final value */
  /*        xcf: Pacemaker state variable #2 (y-axix) final value */
  /*  */
  /*  Number of readings */
  /*  Initial loop values */
  kd = LRClightSampleInc * ((double)lightArray->size[0] - 2.0) + t0;
  if (kd < t0) {
    n = -1;
    apnd = kd;
  } else {
    ndbl = floor((kd - t0) / LRClightSampleInc + 0.5);
    apnd = t0 + ndbl * LRClightSampleInc;
    cdiff = apnd - kd;
    absa = fabs(t0);
    absb = fabs(kd);
    if (absa >= absb) {
      absb = absa;
    }

    if (fabs(cdiff) < 4.4408920985006262E-16 * absb) {
      ndbl++;
      apnd = kd;
    } else if (cdiff > 0.0) {
      apnd = t0 + (ndbl - 1.0) * LRClightSampleInc;
    } else {
      ndbl++;
    }

    if (ndbl >= 0.0) {
      n = (int)ndbl - 1;
    } else {
      n = -1;
    }
  }
  if (n < 0)
  {
  return(ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER); 
  }

  b_emxInit_real_T(&t1, 2);
  k = t1->size[0] * t1->size[1];
  t1->size[0] = 1;
  t1->size[1] = n + 1;
  emxEnsureCapacity((emxArray__common *)t1, k, (int)sizeof(double));
  if (n + 1 > 0) {
    t1->data[0] = t0;
    if (n + 1 > 1) {
      t1->data[n] = apnd;
      nm1d2 = n / 2;
      for (k = 1; k < nm1d2; k++) {
        kd = (double)k * LRClightSampleInc;
        t1->data[k] = t0 + kd;
        t1->data[n - k] = apnd - kd;
      }

      if (nm1d2 << 1 == n) {
        t1->data[nm1d2] = (t0 + apnd) / 2.0;
      } else {
        kd = (double)nm1d2 * LRClightSampleInc;
        t1->data[nm1d2] = t0 + kd;
        t1->data[nm1d2 + 1] = apnd - kd;
      }
    }
  }

  b_emxInit_real_T(&t2, 2);
  k = t2->size[0] * t2->size[1];
  t2->size[0] = 1;
  t2->size[1] = t1->size[1];
  emxEnsureCapacity((emxArray__common *)t2, k, (int)sizeof(double));
  nm1d2 = t1->size[0] * t1->size[1];
  for (k = 0; k < nm1d2; k++) {
    t2->data[k] = t1->data[k] + LRClightSampleInc;
  }

  *xn = x0;
  *xcn = xc0;

  /*  Loop */
  for (nm1d2 = 0; nm1d2 <= lightArray->size[0] - 2; nm1d2++) {
    /*  Set light drive */
    rk4stepperSec(*xn, *xcn, (lightArray->data[nm1d2] + lightArray->data[nm1d2 +
      1]) / 2.0, t1->data[nm1d2], t2->data[nm1d2], xn, xcn);
  }

  emxFree_real_T(&t1);
  *tn = t2->data[t2->size[1] - 1];
  emxFree_real_T(&t2);
  return (ERROR_CODE_NONE);
}

/* End of code generation (pacemakerModelRun.c) */
