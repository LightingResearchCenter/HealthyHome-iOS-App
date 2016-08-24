/*
 * blackbox.c
 *
 * Code generation for function 'blackbox'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

/* Include files */
#include "blackbox.h"
#include "blackbox_emxutil.h"
#include "createlightschedule.h"
#include "pacemakerModelRun.h"
#include "LRCphaseDifference.h"
#include "refPhaseTime2StateAtTime.h"
#include "mod.h"
#include "LRCabs2relTime.h"
#include "LRCacrophaseAngle2Time.h"
#include "LRCcosinorFit.h"
#include "bedWakeTimes2TargetPhase.h"
#include "LRCgapFill.h"
#include "LRCtruncate_activityReading.h"
#include "LRCtruncate_lightReading.h"
#include "config.h"
#include <stdio.h>
#include <math.h>
#include "CircadianModel.h"

/* Function Definitions */
int blackbox(double runTimeUTC, double runTimeOffset, double bedTime, double
              riseTime, const struct_T *lightReading, const b_struct_T
              *activityReading, const c_struct_T *lastPacemaker, d_struct_T
              *treatment, c_struct_T *pacemaker, double distanceToGoal_data[1],
              int distanceToGoal_size[2])
{
  int idx, return_value;
  static const char cv0[5] = { '0', '.', '1', '.', '1' };

  emxArray_real_T *CS;
  emxArray_real_T *b_CS;
  emxArray_real_T *lightReading_timeUTC;
  emxArray_real_T *lightReading_cs;
  emxArray_real_T *activityReading_timeUTC;
  emxArray_real_T *activityReading_timeOffset;
  emxArray_real_T *activityReading_activityIndex;
  emxArray_boolean_T *x;
  emxArray_real_T *timeLocal;
  emxArray_real_T *y;
  emxArray_int32_T *r0;
  emxArray_real_T *expl_temp;
  emxArray_real_T *b_expl_temp;
  emxArray_real_T *c_expl_temp;
  emxArray_real_T *d_expl_temp;
  emxArray_real_T *e_expl_temp;
  emxArray_real_T *e1_expl_temp;
    
  emxArray_real_T *f_expl_temp;
  emxArray_boolean_T *c_CS;
  emxArray_real_T *b_activityReading_timeUTC;
  double targetPhase;
  int loop_ub;
  double arccosine;
  double t0LocalRel, t0Local,temptn;
  double acrophaseTime;
  double x0;
  double xc0;
  double xcn;
  double xn;
  double tnLocalRel;
  double xcAcrophase;
  double xAcrophase;
  int k;
  int ii_data[1];
  boolean_T exitg1;
  int b_ii_data[1];
  double idx_data[1];
  double startTimeNewDataLocal_data[1];
  signed char unnamed_idx_0;
  double startTimeNewDataRel_data[1];
  double tn;
  double bedDurationHrs;
  double t0_startTimeUTC[4];
  double t0_durationSecs[4];
  int noPastData;
  int return_from_pacemaker;

  /* BLACKBOX Create light treatment schedule and measure progress toward goal. */
  /*  */
  /*    Inputs: */
  /*    RUNTIMEUTC      time wrapper was called in UTC UNIX format */
  /*    RUNTIMEOFFSET	offset of local time from UTC in hours at runtime */
  /*    BEDTIME         time day in hours in local time */
  /*    RISETIME        time day in hours in local time */
  /*    LIGHTREADING	lightReading struct */
  /*    ACTIVITYREADING	activityReading struct */
  /*    PACEMAKERARRAY	pacemaker struct, with all entries */
  /*  */
  /*    Outputs: */
  /*    TREATMENT       treatment struct */
  /*    PACEMAKER       pacemaker struct, single new entry */
  /*    DISTANCETOGOAL	hours between current phase angle and target */
  /*  */
  /*    See also LRCREAD_ACTIVITYREADING, LRCREAD_LIGHTREADING, */
  /*    LRCREAD_PACEMAKER. */
  /*    Author(s): G. Jones,    2015-05-21 */
  /*    	       A. Bierman,  2015-05-26 */
  /*    Copyright 2015 Rensselaer Polytechnic Institute. All rights reserved. */
  /*  Initialize outputs */
  /* coder.varsize('t0LocalRel','x0','xc0') */
  /*  treatment = struct(                         ... */
  /*      'n',            0,                      ... */
  /*      'startTimeUTC', double.empty(LRCtreatmentSize),	... */
  /*      'durationMins', double.empty(LRCtreatmentSize)	... */
  /*      ); */
  return_value=0;
  treatment->n = 0.0;
  treatment->startTimeUTC.size[0] = LRCtreatmentSizeOrig;
  for (idx = 0; idx < LRCtreatmentSizeOrig; idx++) {
    treatment->startTimeUTC.data[idx] = 0.0;
  }

  treatment->durationMins.size[0] = LRCtreatmentSizeOrig;
  for (idx = 0; idx < LRCtreatmentSizeOrig; idx++) {
    treatment->durationMins.data[idx] = 0.0;
  }

  pacemaker->runTimeUTC = runTimeUTC;
  pacemaker->runTimeOffset = runTimeOffset;
  pacemaker->version = 1.0;
  for (idx = 0; idx < 5; idx++) {
    pacemaker->model[idx] = cv0[idx];
  }

  pacemaker->x0 = 0.0;
  pacemaker->xc0 = 0.0;
  pacemaker->t0 = 0.0;
  pacemaker->xn = 0.0;
  pacemaker->xcn = 0.0;
  pacemaker->tn = 0.0;
  distanceToGoal_size[0] = 0;
  distanceToGoal_size[1] = 0;

  /*  Return empty results and exit if either data is empty */
  emxInit_real_T(&CS, 1);
  emxInit_real_T(&b_CS, 1);
  emxInit_real_T(&lightReading_timeUTC, 1);
  emxInit_real_T(&lightReading_cs, 1);
  emxInit_real_T(&activityReading_timeUTC, 1);
  emxInit_real_T(&activityReading_timeOffset, 1);
  emxInit_real_T(&activityReading_activityIndex, 1);
  emxInit_boolean_T(&x, 1);
  emxInit_real_T(&timeLocal, 1);
  emxInit_real_T(&y, 1);
  emxInit_int32_T(&r0, 1);
  emxInit_real_T(&expl_temp, 1);
  emxInit_real_T(&b_expl_temp, 1);
  emxInit_real_T(&c_expl_temp, 1);
  emxInit_real_T(&d_expl_temp, 1);
  emxInit_real_T(&e_expl_temp, 1);
  emxInit_real_T(&e1_expl_temp, 1);
    
  emxInit_real_T(&f_expl_temp, 1);
  emxInit_boolean_T(&c_CS, 1);
  emxInit_real_T(&b_activityReading_timeUTC, 1);
  /* test to see if condition holds
  printf("lightReading->timeUTC->size[0] would be %d\n", lightReading->timeUTC->size[0] );
  printf("activityReading->timeUTC->size[0] would be %d\n", activityReading->timeUTC->size[0] );
  printf("3rd statement value would be %lf\n", (lightReading->timeUTC->data[lightReading->timeUTC->size[0] - 1]
                 - lightReading->timeUTC->data[0]));
  printf("4th statement value would be %lf\n", activityReading->timeUTC->data[activityReading->timeUTC->size[0] - 1] -
       activityReading->timeUTC->data[0]);

  printf("1st condition would be %d\n", (lightReading->timeUTC->size[0] == 0)  );
  printf("2nd condition would be %d\n", (activityReading->timeUTC->size[0] == 0) );
  printf("3rd condition would be %d\n", (lightReading->timeUTC->data[lightReading->timeUTC->size[0] - 1]
                 - lightReading->timeUTC->data[0] < 86400.0) );
  printf("4th condition would be %d\n", (activityReading->timeUTC->data[activityReading->timeUTC->size[0] - 1] -
       activityReading->timeUTC->data[0] < 86400.0) );*/
  if ((lightReading->timeUTC->size[0] == 0) || (activityReading->timeUTC->size[0]
       == 0) || (lightReading->timeUTC->data[lightReading->timeUTC->size[0] - 1]
                 - lightReading->timeUTC->data[0] < 86400.0) ||
      (activityReading->timeUTC->data[activityReading->timeUTC->size[0] - 1] -
       activityReading->timeUTC->data[0] < 86400.0)) {

		    emxFree_real_T(&b_activityReading_timeUTC);
			emxFree_boolean_T(&c_CS);
			emxFree_real_T(&f_expl_temp);
            emxFree_real_T(&e1_expl_temp);
            emxFree_real_T(&e_expl_temp);
			emxFree_real_T(&d_expl_temp);
			emxFree_real_T(&c_expl_temp);
			emxFree_real_T(&b_expl_temp);
			emxFree_real_T(&expl_temp);
			emxFree_int32_T(&r0);
			emxFree_real_T(&y);
			emxFree_real_T(&timeLocal);
			emxFree_boolean_T(&x);
			emxFree_real_T(&activityReading_activityIndex);
			emxFree_real_T(&activityReading_timeOffset);
			emxFree_real_T(&activityReading_timeUTC);
			emxFree_real_T(&lightReading_cs);
			emxFree_real_T(&lightReading_timeUTC);
			emxFree_real_T(&b_CS);
			emxFree_real_T(&CS);
	
		   if (lightReading->timeUTC->size[0] == 0){
			   return_value=ERROR_CODE_NO_LIGHT_DATA;
			   return(return_value);
		   }
		   if (activityReading->timeUTC->size[0]== 0){
			   return_value=ERROR_CODE_NO_ACTIVITY_DATA;
			   return(return_value);
		   }
		   if (lightReading->timeUTC->data[lightReading->timeUTC->size[0] - 1]
                 - lightReading->timeUTC->data[0] < 86400.0){
			   return_value=ERROR_CODE_LIGHT_LESS_THAN_ADAY;
			   return(return_value);
		   }

		   if (activityReading->timeUTC->data[activityReading->timeUTC->size[0] - 1] -
					activityReading->timeUTC->data[0] < 86400.0){
			   return_value=ERROR_CODE_ACTIVITY_LESS_THAN_ADAY;
			   return(return_value);
		   }

  } else {
    /*  Return empty results and exit if less than 24 hours of data */
    /*  Truncate data to most recent */
    LRCtruncate_lightReading(lightReading->timeUTC,
                             lightReading->timeOffset,
                             lightReading->red,
                             lightReading->green,
                             lightReading->blue,
                             lightReading->clear,
                             lightReading->cla,
                             lightReading->cs,
                             lightReading_timeUTC,
                             b_expl_temp,
                             c_expl_temp,
                             d_expl_temp,
                             e_expl_temp,
                             e1_expl_temp,
                             f_expl_temp,
                             lightReading_cs);
    
      LRCtruncate_activityReading(activityReading->timeUTC,
      activityReading->timeOffset, activityReading->activityIndex,
      activityReading->activityCount, activityReading_timeUTC,
      activityReading_timeOffset, activityReading_activityIndex, expl_temp);

    /*  Fill in any gaps in CS */
    LRCgapFill(lightReading_timeUTC, lightReading_cs, CS, b_CS);

    /*  Calculate target phase */
    targetPhase = bedWakeTimes2TargetPhase(bedTime, riseTime);

    /*  Calculate activity acrophase */
    /* LRCUTC2LOCAL Convert from UTC time to local time */
    /*    timeUTC and timeLocal is in seconds from January 1, 1970. */
    /*    timeOffset is in hours. */
    /*  Fit activity data with cosine function */
    idx = b_activityReading_timeUTC->size[0];
    b_activityReading_timeUTC->size[0] = activityReading_timeUTC->size[0];
    emxEnsureCapacity((emxArray__common *)b_activityReading_timeUTC, idx, (int)
                      sizeof(double));
    loop_ub = activityReading_timeUTC->size[0];
    for (idx = 0; idx < loop_ub; idx++) {
      b_activityReading_timeUTC->data[idx] = activityReading_timeUTC->data[idx]
        + activityReading_timeOffset->data[idx] * 60.0 * 60.0;
    }

    LRCcosinorFit(b_activityReading_timeUTC, activityReading_activityIndex,
                  &acrophaseTime, &t0LocalRel, &arccosine);
    acrophaseTime = LRCacrophaseAngle2Time(arccosine);

    /*  Check if the pacemakerStruct has previous values */
	if (lastPacemaker->t0 == 0)
	{
		noPastData = 1;
		t0LocalRel = b_mod(b_activityReading_timeUTC->data[0], 86400.0);
        refPhaseTime2StateAtTime(acrophaseTime, &t0LocalRel, &xAcrophase,  &xcAcrophase);
		t0Local = t0LocalRel + 86400.0 * floor(b_activityReading_timeUTC->data[0]/86400.0);
		temptn =  t0Local- activityReading_timeOffset->data[0] *60.0*60.0;
		x0 = xAcrophase;
		xc0= xcAcrophase;
	}
	else{

		noPastData=0;
		temptn = lastPacemaker->tn;
		 x0 = lastPacemaker->xn;
		 xc0 = lastPacemaker->xcn;

		    /* LRCUTC2LOCAL Convert from UTC time to local time */
			/*    timeUTC and timeLocal is in seconds from January 1, 1970. */
			/*    timeOffset is in hours. */
		t0LocalRel = LRCabs2relTime(lastPacemaker->tn +
		activityReading_timeOffset->data[0] * 60.0 * 60.0);

		/*  light readings recorded since last run */
		idx = c_CS->size[0];
		c_CS->size[0] = CS->size[0];
		emxEnsureCapacity((emxArray__common *)c_CS, idx, (int)sizeof(boolean_T));
		loop_ub = CS->size[0];
		for (idx = 0; idx < loop_ub; idx++) {
			c_CS->data[idx] = (CS->data[idx] > lastPacemaker->tn);
		}

		eml_li_find(c_CS, r0);
		idx = CS->size[0];
		CS->size[0] = r0->size[0];
		emxEnsureCapacity((emxArray__common *)CS, idx, (int)sizeof(double));
		loop_ub = r0->size[0];
		for (idx = 0; idx < loop_ub; idx++) {
			CS->data[idx] = b_CS->data[r0->data[idx] - 1];
		}

	}
    /*  Advance pacemaker model solution to end of light data */
	if (noPastData){
		return_from_pacemaker= pacemakerModelRun(t0LocalRel, x0, xc0, b_CS,
			&tnLocalRel, &xn, &xcn);
		if (return_from_pacemaker == ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER){
		   pacemaker->x0 = lastPacemaker->x0;
           pacemaker->xc0 = lastPacemaker->xc0;
           pacemaker->t0 = lastPacemaker->t0;
           pacemaker->xn = lastPacemaker->xn;
           pacemaker->xcn = lastPacemaker-> xcn;
           pacemaker->tn = lastPacemaker->tn;

			emxFree_real_T(&b_activityReading_timeUTC);
			emxFree_boolean_T(&c_CS);
			emxFree_real_T(&f_expl_temp);
            emxFree_real_T(&e1_expl_temp);
			emxFree_real_T(&e_expl_temp);
			emxFree_real_T(&d_expl_temp);
			emxFree_real_T(&c_expl_temp);
			emxFree_real_T(&b_expl_temp);
			emxFree_real_T(&expl_temp);
			emxFree_int32_T(&r0);
			emxFree_real_T(&y);
			emxFree_real_T(&timeLocal);
			emxFree_boolean_T(&x);
			emxFree_real_T(&activityReading_activityIndex);
			emxFree_real_T(&activityReading_timeOffset);
			emxFree_real_T(&activityReading_timeUTC);
			emxFree_real_T(&lightReading_cs);
			emxFree_real_T(&lightReading_timeUTC);
			emxFree_real_T(&b_CS);
			emxFree_real_T(&CS);
			return_value= ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER;
	        return(return_value);
	  }


	}
	else
	{// Change b_CS ->CS i.e. new values only to take care of the problem large tn observed by LRC
			return_from_pacemaker= pacemakerModelRun(t0LocalRel, x0, xc0, CS,
			&tnLocalRel, &xn, &xcn);
			if (return_from_pacemaker == ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER){

				pacemaker->x0 = lastPacemaker->x0;
                pacemaker->xc0 = lastPacemaker->xc0;
                pacemaker->t0 = lastPacemaker->t0;
                pacemaker->xn = lastPacemaker->xn;
                pacemaker->xcn = lastPacemaker-> xcn;
                pacemaker->tn = lastPacemaker->tn;

			    emxFree_real_T(&b_activityReading_timeUTC);
				emxFree_boolean_T(&c_CS);
				emxFree_real_T(&f_expl_temp);
				emxFree_real_T(&e1_expl_temp);
				emxFree_real_T(&e_expl_temp);
				emxFree_real_T(&d_expl_temp);
				emxFree_real_T(&c_expl_temp);
				emxFree_real_T(&b_expl_temp);
				emxFree_real_T(&expl_temp);
				emxFree_int32_T(&r0);
				emxFree_real_T(&y);
				emxFree_real_T(&timeLocal);
				emxFree_boolean_T(&x);
				emxFree_real_T(&activityReading_activityIndex);
				emxFree_real_T(&activityReading_timeOffset);
				emxFree_real_T(&activityReading_timeUTC);
				emxFree_real_T(&lightReading_cs);
				emxFree_real_T(&lightReading_timeUTC);
				emxFree_real_T(&b_CS);
				emxFree_real_T(&CS);
				return_value= ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER;
	            return(return_value);
	  }
			
	}

    /*  Calculate pacemaker state from activity acrophase */
    arccosine = b_mod(tnLocalRel, 86400.0);
    refPhaseTime2StateAtTime(acrophaseTime, &arccosine, &xAcrophase,
      &xcAcrophase);

    /*  Calculate phase difference from pacemaker state variables */
    /*  If phase difference between activity acrophase and the pacemaker model is */
    /*  greater than phaseDiffMax then reset model to activity acrophase */
    if (fabs(LRCphaseDifference(xcn, xn, xcAcrophase, xAcrophase)) > LRCphaseDiffMax) {
      idx = x->size[0];
      x->size[0] = activityReading_timeUTC->size[0];
      emxEnsureCapacity((emxArray__common *)x, idx, (int)sizeof(boolean_T));
      loop_ub = activityReading_timeUTC->size[0];
      for (idx = 0; idx < loop_ub; idx++) {
        x->data[idx] = (activityReading_timeUTC->data[idx] >= lastPacemaker->tn);
      }
	  
      if (1 <= x->size[0]) {
        k = 1;
      } else {
        k = x->size[0];
      }

      idx = 0;
      loop_ub = 1;
      exitg1 = FALSE;
      while ((exitg1 == FALSE) && (loop_ub <= x->size[0])) {
        if (x->data[loop_ub - 1]) {
          idx = 1;
          ii_data[0] = loop_ub;
          exitg1 = TRUE;
        } else {
          loop_ub++;
        }
      }
	  if (idx==0){
          
//	  //printf("No new activity value since previous reading");//added by Pedram for debug
//	  //exit(EXITMINUS2);
		    pacemaker->x0 = lastPacemaker->x0;
            pacemaker->xc0 = lastPacemaker->xc0;
            pacemaker->t0 = lastPacemaker->t0;
            pacemaker->xn = lastPacemaker->xn;
            pacemaker->xcn = lastPacemaker-> xcn;
            pacemaker->tn = lastPacemaker->tn;
			emxFree_real_T(&b_activityReading_timeUTC);
			emxFree_boolean_T(&c_CS);
			emxFree_real_T(&f_expl_temp);
            emxFree_real_T(&e1_expl_temp);
			emxFree_real_T(&e_expl_temp);
			emxFree_real_T(&d_expl_temp);
			emxFree_real_T(&c_expl_temp);
			emxFree_real_T(&b_expl_temp);
			emxFree_real_T(&expl_temp);
			emxFree_int32_T(&r0);
			emxFree_real_T(&y);
			emxFree_real_T(&timeLocal);
			emxFree_boolean_T(&x);
			emxFree_real_T(&activityReading_activityIndex);
			emxFree_real_T(&activityReading_timeOffset);
			emxFree_real_T(&activityReading_timeUTC);
			emxFree_real_T(&lightReading_cs);
			emxFree_real_T(&lightReading_timeUTC);
			emxFree_real_T(&b_CS);
			emxFree_real_T(&CS);
	        return_value= ERROR_NOT_VALID_ACTIMETRY_DATA_TOBYPASS_PACEMAKER;
	        return(return_value);
	  }
      if (k == 1) {
        if (idx == 0) {
          k = 0;
        }
      } else {
        if (1 > idx) {
          loop_ub = -1;
        } else {
          loop_ub = 0;
        }

        idx = 0;
        while (idx <= loop_ub) {
          b_ii_data[0] = ii_data[0];
          idx = 1;
        }

        k = loop_ub + 1;
        loop_ub++;
        idx = 0;
        while (idx <= loop_ub - 1) {
          ii_data[0] = b_ii_data[0];
          idx = 1;
        }
      }

      for (idx = 0; idx < k; idx++) {
        idx_data[idx] = ii_data[idx];
      }

      /*  first activity reading recorded since last run */
      /* LRCUTC2LOCAL Convert from UTC time to local time */
      /*    timeUTC and timeLocal is in seconds from January 1, 1970. */
      /*    timeOffset is in hours. */
      idx = y->size[0];
      y->size[0] = k;
      emxEnsureCapacity((emxArray__common *)y, idx, (int)sizeof(double));
      for (idx = 0; idx < k; idx++) {
        y->data[idx] = activityReading_timeOffset->data[(int)idx_data[idx] - 1] *
          60.0;
      }

      idx = timeLocal->size[0];
      timeLocal->size[0] = k;
      emxEnsureCapacity((emxArray__common *)timeLocal, idx, (int)sizeof(double));
      for (idx = 0; idx < k; idx++) {
        timeLocal->data[idx] = activityReading_timeUTC->data[(int)idx_data[idx]
          - 1] + y->data[idx] * 60.0;
      }

      for (idx = 0; idx < k; idx++) {
        startTimeNewDataLocal_data[idx] = activityReading_timeUTC->data[(int)
          idx_data[idx] - 1] + y->data[idx] * 60.0;
      }

      /* LRCABS2RELTIME Convert absolute time to time of day */
      /*    Input and output are in units of seconds */
      unnamed_idx_0 = (signed char)timeLocal->size[0];
      k = 0;
      while (k <= unnamed_idx_0 - 1) {
        startTimeNewDataRel_data[0] = timeLocal->data[0] - floor
          (startTimeNewDataLocal_data[0] / 86400.0) * 86400.0;
        k = 1;
      }

      /*  REFPHASETIME2STATEATTIME Converts the state of the oscilator from the time of the referece phase */
      /*  to the state at a particular time t. The function approximates the oscillator as a harmonic oscilator, */
      /*  that is, x = -cos(2*pi*t/86400 + phi), xc = sin(2*pi*t/86400 + phi) */
      /*   */
      /*  */
      /*    Inputs: */
      /*        refPhaseTime: time in units of seconds when the oscilator is at the  */
      /*        reference phase condition (x,xc) = (-1,0). */
      /*        t: relative time of day in units of seconds */
      /*        phaseMarker: one of these values: 'CBTmin','DLMO','bedtime', */
      /*                    'waketime','activityAcrophase' */
      /*  */
      /*    Outputs: */
      /*        t: time in units of seconds */
      /*        x: state variable #1 of the oscillator */
      /*        xc: state vaiables #2 of the oscillator */
      /* % Phase marker reference switch */
      /* disp('activityAcrophase'); */
      /* % Calculate phase state variables */
      acrophaseTime = (acrophaseTime - 36000.0) * 3.1415926535897931 / 43200.0;

      /*  convert from 24-hour time to radians */
      idx = y->size[0];
      y->size[0] = unnamed_idx_0;
      emxEnsureCapacity((emxArray__common *)y, idx, (int)sizeof(double));
      loop_ub = unnamed_idx_0;
      for (idx = 0; idx < loop_ub; idx++) {
        y->data[idx] = 6.2831853071795862 * startTimeNewDataRel_data[idx] /
          86400.0 - acrophaseTime;
      }

      idx = timeLocal->size[0];
      timeLocal->size[0] = y->size[0];
      emxEnsureCapacity((emxArray__common *)timeLocal, idx, (int)sizeof(double));
      loop_ub = y->size[0];
      for (idx = 0; idx < loop_ub; idx++) {
        timeLocal->data[idx] = y->data[idx];
      }

      k = 0;
      while (k <= y->size[0] - 1) {
        timeLocal->data[0] = cos(timeLocal->data[0]);
        k = 1;
      }

      loop_ub = timeLocal->size[0];
      for (idx = 0; idx < loop_ub; idx++) {
        idx_data[idx] = -timeLocal->data[idx];
      }

      idx = y->size[0];
      y->size[0] = unnamed_idx_0;
      emxEnsureCapacity((emxArray__common *)y, idx, (int)sizeof(double));
      loop_ub = unnamed_idx_0;
      for (idx = 0; idx < loop_ub; idx++) {
        y->data[idx] = 6.2831853071795862 * startTimeNewDataRel_data[idx] /
          86400.0 - acrophaseTime;
      }

      idx = timeLocal->size[0];
      timeLocal->size[0] = y->size[0];
      emxEnsureCapacity((emxArray__common *)timeLocal, idx, (int)sizeof(double));
      loop_ub = y->size[0];
      for (idx = 0; idx < loop_ub; idx++) {
        timeLocal->data[idx] = y->data[idx];
      }

      k = 0;
      while (k <= y->size[0] - 1) {
        timeLocal->data[0] = sin(timeLocal->data[0]);
        k = 1;
      }

      t0LocalRel = startTimeNewDataRel_data[0];
      x0 = idx_data[0];
      xc0 = timeLocal->data[0];
      return_from_pacemaker= pacemakerModelRun(startTimeNewDataRel_data[0], idx_data[0],
                        timeLocal->data[0], CS, &tnLocalRel, &xn, &xcn);
	  if (return_from_pacemaker == ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER){
				pacemaker->x0 = lastPacemaker->x0;
                pacemaker->xc0 = lastPacemaker->xc0;
                pacemaker->t0 = lastPacemaker->t0;
                pacemaker->xn = lastPacemaker->xn;
                pacemaker->xcn = lastPacemaker-> xcn;
                pacemaker->tn = lastPacemaker->tn;

			    emxFree_real_T(&b_activityReading_timeUTC);
				emxFree_boolean_T(&c_CS);
				emxFree_real_T(&f_expl_temp);
				emxFree_real_T(&e1_expl_temp);
				emxFree_real_T(&e_expl_temp);
				emxFree_real_T(&d_expl_temp);
				emxFree_real_T(&c_expl_temp);
				emxFree_real_T(&b_expl_temp);
				emxFree_real_T(&expl_temp);
				emxFree_int32_T(&r0);
				emxFree_real_T(&y);
				emxFree_real_T(&timeLocal);
				emxFree_boolean_T(&x);
				emxFree_real_T(&activityReading_activityIndex);
				emxFree_real_T(&activityReading_timeOffset);
				emxFree_real_T(&activityReading_timeUTC);
				emxFree_real_T(&lightReading_cs);
				emxFree_real_T(&lightReading_timeUTC);
				emxFree_real_T(&b_CS);
				emxFree_real_T(&CS);	   
				return_value= ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER;
				return(return_value);
	  }


    }

    /*  convert to absoulute Unix time (seconds since Jan 1, 1970) */
    //tn = lastPacemaker->tn + (tnLocalRel - t0LocalRel);
	tn = temptn + (tnLocalRel - t0LocalRel);

    /*  STATEATTIME2REFPHASETIME Converts the state of the oscilator from a phase at a particular time */
    /*  to the time of the referece phase. The function approximates the oscillator as a harmonic oscilator */
    /*   */
    /*    Inputs: */
    /*        t: time in units of seconds */
    /*        x: state variable #1 of the oscillator */
    /*        xc: state vaiables #2 of the oscillator */
    /*  */
    /*    Output: */
    /*        refPhaseTime: time in units of seconds when the oscilator is at the  */
    /*        reference phase condition (x,xc) = (-1,0). */
    /* % Normalize state variables */
    /*  x and xc must be between -1 and 1 */
    if (xAcrophase > 1.0) {
      xAcrophase = 1.0;
    } else {
      if (xAcrophase < -1.0) {
        xAcrophase = -1.0;
      }
    }

    if (xcAcrophase > 1.0) {
      xcAcrophase = 1.0;
    } else {
      if (xcAcrophase < -1.0) {
        xcAcrophase = -1.0;
      }
    }

    /* % Calculate phase angle and time */
    /*  */
    /*  four quadrant arccosine with range 0 to 2pi */
    if ((xAcrophase >= 0.0) && (xcAcrophase >= 0.0)) {
      /*  Quadrant I */
      arccosine = acos(-xAcrophase);

      /*  negative cosine because the model evolves clockwise */
    } else if ((xAcrophase < 0.0) && (xcAcrophase >= 0.0)) {
      /*  Quadrant II */
      arccosine = acos(-xAcrophase);
    } else if ((xAcrophase < 0.0) && (xcAcrophase < 0.0)) {
      /*  Quadrant III */
      arccosine = 6.2831853071795862 - acos(-xAcrophase);
    } else {
      /*  Quadrant IV (x>=0 && xc<0) */
      arccosine = 6.2831853071795862 - acos(-xAcrophase);
    }

    /*  relative time in radians, negative because the model evolves clockwise */
    t0LocalRel = 13750.987083139758 * -(arccosine - tnLocalRel *
      3.1415926535897931 / 43200.0);

    /*  relative time in hours */
    /*  Adjust if referencing previous day */
    if (t0LocalRel < 0.0) {
      t0LocalRel += 86400.0;
    }

    /*  */
    /* % Create return value */
    t0LocalRel -= floor(t0LocalRel / 86400.0) * 86400.0;

    /*  convert values > 24 to principle values */
    /* % alternate method */
    /* { */
    /* arcTangent = atan2(xc,-x); % negative cosine because the model evolves clockwise */
    /* refPhaseTimeRadians2 = -(arcTangent - t*pi/12); % relative time in radians, negative because the model evolves clockwise */
    /* refPhaseTime2 = 12/pi*refPhaseTimeRadians2; % relative time in hours */
    /*  */
    /*  Adjust if referencing previous day */
    /* if (refPhaseTime2<0) */
    /*     refPhaseTime2 = 24+refPhaseTime2; */
    /* end */
    /* refPhaseTime2 = mod(refPhaseTime2,24); % convert values > 24 to principle values */
    /* } */
    /*  Calculate distance to goal phase from current phase */
    /* LRCDISTANCETOGOAL Summary of this function goes here */
    /*    Detailed explanation goes here */
    arccosine = (t0LocalRel - floor(t0LocalRel / 86400.0) * 86400.0) -
      (targetPhase - floor(targetPhase / 86400.0) * 86400.0);

    /*  seconds */
    if (arccosine < -43200.0) {
      arccosine += 86400.0;
    } else {
      if (arccosine >= 43200.0) {
        arccosine -= 86400.0;
      }
    }

    distanceToGoal_size[0] = 1;
    distanceToGoal_size[1] = 1;
    distanceToGoal_data[0] = arccosine;

    /*  Find unavailable times */
    /* LRCBED2UNAVAIL Summary of this function goes here */
    /*    Detailed explanation goes here */
    /*  Calculate the duration of time in bed in hours */
    if (bedTime > riseTime) {
      bedDurationHrs = (24.0 - bedTime) + riseTime;
    } else {
      if (bedTime < riseTime) {
        bedDurationHrs = riseTime - bedTime;
      }
    }

    /*  Convert local bed time in hours to UTC time in seconds */
    /* LRCLOCAL@UTC Convert from local time to UTC time */
    /*    timeUTC and timeLocal is in seconds from January 1, 1970. */
    /*    timeOffset is in hours. */
    arccosine = bedTime * 60.0 * 60.0 - runTimeOffset * 60.0 * 60.0;
    t0LocalRel = arccosine - floor(arccosine / 86400.0) * 86400.0;

    /*  Create bed date and times for several days in the future */
    arccosine = runTimeUTC - (runTimeUTC - floor(runTimeUTC / 86400.0) * 86400.0);

    /*  Convert duration to seconds and replicate */
    acrophaseTime = bedDurationHrs * 60.0 * 60.0;
    for (idx = 0; idx < 4; idx++) {
      t0_startTimeUTC[idx] = (arccosine + 86400.0 * (double)idx) + t0LocalRel;
      t0_durationSecs[idx] = acrophaseTime;
    }

    /*  Calculate light treatment schedule */
    createlightschedule(tn, xn, xcn, targetPhase, t0_startTimeUTC,
                        t0_durationSecs, &treatment->n,
                        treatment->startTimeUTC.data,
                        treatment->startTimeUTC.size,
                        treatment->durationMins.data,
                        treatment->durationMins.size);

    /*  Assign values to output */
    pacemaker->x0 = x0;
    pacemaker->xc0 = xc0;
    pacemaker->t0 = temptn;
    pacemaker->xn = xn;
    pacemaker->xcn = xcn;
    pacemaker->tn = tn;
  }

  emxFree_real_T(&b_activityReading_timeUTC);
  emxFree_boolean_T(&c_CS);
  emxFree_real_T(&f_expl_temp);
  emxFree_real_T(&e1_expl_temp);
  emxFree_real_T(&e_expl_temp);
  emxFree_real_T(&d_expl_temp);
  emxFree_real_T(&c_expl_temp);
  emxFree_real_T(&b_expl_temp);
  emxFree_real_T(&expl_temp);
  emxFree_int32_T(&r0);
  emxFree_real_T(&y);
  emxFree_real_T(&timeLocal);
  emxFree_boolean_T(&x);
  emxFree_real_T(&activityReading_activityIndex);
  emxFree_real_T(&activityReading_timeOffset);
  emxFree_real_T(&activityReading_timeUTC);
  emxFree_real_T(&lightReading_cs);
  emxFree_real_T(&lightReading_timeUTC);
  emxFree_real_T(&b_CS);
  emxFree_real_T(&CS);
  return(return_value);
}

void eml_li_find(const emxArray_boolean_T *x, emxArray_int32_T *y)
{
  int k;
  int i;
  int j;
  k = 0;
  for (i = 1; i <= x->size[0]; i++) {
    if (x->data[i - 1]) {
      k++;
    }
  }

  j = y->size[0];
  y->size[0] = k;
  emxEnsureCapacity((emxArray__common *)y, j, (int)sizeof(int));
  j = 0;
  for (i = 1; i <= x->size[0]; i++) {
    if (x->data[i - 1]) {
      y->data[j] = i;
      j++;
    }
  }
}

/* End of code generation (blackbox.c) */
