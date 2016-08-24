#ifndef __CONFIG_H_
#define __CONFIG_H_

/*This header file includes "defines directory" contents */
#define LRCk (0.15) //no detail
#define LRCmodel ("0.1.1")
#define LRCversion (1.0)
#define LRCmu (0.13)
#define LRCphaseDiffMax (5.0*60.0*60.0 ) //5 hours in seconds, max allowed difference between activity acrophase and pacemaker
#define LRCq (0.66666666666666663)
#define LRCreadingDuration (10.0*24.0*60.0*60.0) //10 days in seconds, duration of time to keep from readings
#define LRCrk4StepSize (3.0) //Number of steps for rk4stepperSec loop
#define LRCsampleInc (30) //Nominal sampling increment size in seconds of the data loggers
#define LRCactivitySampleInc (180) //Nominal sampling increment size in seconds of the activity logger
#define LRClightSampleInc (180.0) //Nominal sampling increment size in seconds of the light logger
#define LRCtau (24.2)
#define LRCtreatmentCS (0.4) //Nominal level of treatment CS
#define LRCtreatmentInc (900) //15 minutes
#define LRCtreatmentPlanLength (2) //Number of days to calculate a schedule for
#define LRCtreatmentSize (LRCtreatmentPlanLength*24*60*60/LRCtreatmentInc)
#define LRCtreatmentSizeOrig (24*60*60/LRCtreatmentInc)
//#define EXITMINUS2 (-2) //Error message. program wants to read new activity data to coorect the phase difference between activity acrophase and the pacemaker model;but activity data is not available
#define SECONDSinHOUR (3600.0)
#endif