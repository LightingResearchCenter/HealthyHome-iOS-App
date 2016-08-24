/*
 * rk4stepperSec.c
 *
 * Code generation for function 'rk4stepperSec'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "rk4stepperSec.h"
#include "config.h"

/* Function Definitions */
void rk4stepperSec(double x0, double xc0, double lightDrive, double ti, double
                   tf, double *xf, double *xcf)
{
  double Bdrive;
  double hInterval;
  int iStep;
  double xprime1;
  double xcprime1;
  double x1;
  double xc1;
  double xprime2;
  double xcprime2;
  double xprime3;
  double xc3;

  /*  RK4STEPPERSEC is an ODE solver used to determine state variable values */
  /*  of the pacemaker model at the desired point in time */
  /*  Create local variables */
  Bdrive = 0.56 * lightDrive;
  hInterval = (tf - ti) / LRCrk4StepSize;

  /*  Initialize loop variables */
  /*  Loop */
  for (iStep = 0; iStep < LRCrk4StepSize; iStep++) {
    /*  Calculate values per step */
    /*  RK4SEC calculates the derivatives of the pacemaker model at each step */
    /*  Calculate derivatives */
    /*  XPRIMESEC */
    /*  Model */
    xprime1 = 7.27220521664304E-5 * ((LRCmu * ((x0 / 3.0 + 1.3333333333333333 *
      pow(x0, 3.0)) - 2.4380952380952383 * pow(x0, 7.0)) + xc0) + Bdrive);
    xcprime1 = 7.27220521664304E-5 * ((LRCq * Bdrive * xc0 -
      (24/(0.99729*LRCtau))*(24/(0.99729*LRCtau)) * x0) + 0.15 * Bdrive * x0);
    x1 = hInterval / 2.0 * xprime1 + x0;
    xc1 = hInterval / 2.0 * xcprime1 + xc0;

    /*  XPRIMESEC */
    /*  Model */
    xprime2 = 7.27220521664304E-5 * ((LRCmu * ((x1 / 3.0 + 1.3333333333333333 *
      pow(x1, 3.0)) - 2.4380952380952383 * pow(x1, 7.0)) + xc1) + Bdrive);
    xcprime2 = 7.27220521664304E-5 * ((LRCq * Bdrive * xc1 -
      (24/(0.99729*LRCtau))*(24/(0.99729*LRCtau)) * x1) + 0.15 * Bdrive * x1);
    x1 = hInterval / 2.0 * xprime2 + x0;
    xc1 = hInterval / 2.0 * xcprime2 + xc0;

    /*  XPRIMESEC */
    /*  Model */
    xprime3 = 7.27220521664304E-5 * ((LRCmu * ((x1 / 3.0 + 1.3333333333333333 *
      pow(x1, 3.0)) - 2.4380952380952383 * pow(x1, 7.0)) + xc1) + Bdrive);
    x1 = 7.27220521664304E-5 * ((LRCq * Bdrive * xc1 -
      (24/(0.99729*LRCtau))*(24/(0.99729*LRCtau)) * x1) + 0.15 * Bdrive * x1);
    xc1 = hInterval * xprime3 + x0;
    xc3 = hInterval * x1 + xc0;

    /*  XPRIMESEC */
    /*  Model */
    /*  Create output valriables */
    x0 += hInterval / 6.0 * ((xprime1 + 7.27220521664304E-5 * ((LRCmu * ((xc1 /
      3.0 + 1.3333333333333333 * pow(xc1, 3.0)) - 2.4380952380952383 * pow(xc1,
      7.0)) + xc3) + Bdrive)) + 2.0 * (xprime3 + xprime2));
    xc0 += hInterval / 6.0 * ((xcprime1 + 7.27220521664304E-5 *
      ((LRCq * Bdrive * xc3 - (24/(0.99729*LRCtau))*(24/(0.99729*LRCtau)) * xc1) + 0.15 *
       Bdrive * xc1)) + 2.0 * (x1 + xcprime2));

    /*  Update loop variable */
  }

  /*  Create return values */
  *xf = x0;
  *xcf = xc0;
}

/* End of code generation (rk4stepperSec.c) */
