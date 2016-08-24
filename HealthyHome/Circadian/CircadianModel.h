/*
* CircadianModel.h
* This is the main model header file
*
*/

#ifndef __CIRCADIANMODEL_H__
#define __CIRCADIANMODEL_H__
/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "profile.h"
#include "blackbox_types.h"



/* Function Declarations */

int CircadianModel_Initialize( PROFILE_T pUserProfile, GOAL_T pUserGoals, double ptimeUTC, double pOffest);

int CircadianModelRun(FILE *pActivityReading, FILE *pLightReading, FILE *pfPacemaker, d_struct_T* pTreatment, c_struct_T  *pPacemaker, double  *pDistanceToGoal);

char *CircadianModelGetVersion(void);


#define ERROR_CODE_NONE                   (0x0000)
#define ERROR_CODE_INVALID_SLEEP_TIME (0x8001)//
#define ERROR_CODE_INVALID_WAKE_TIME (0x8002) //
#define ERROR_CODE_INVALID_TIME_OFFSET (0x8003) //
#define ERROR_CODE_NO_LIGHT_DATA (0x8004) //
#define ERROR_CODE_NO_ACTIVITY_DATA (0x8005) //
#define ERROR_CODE_LIGHT_LESS_THAN_ADAY (0x8006) //
#define ERROR_CODE_ACTIVITY_LESS_THAN_ADAY (0x8007) //
#define ERROR_PACEMAKER_MEMORY_ALLOCATION (0x8008)//
#define ERROR_LIGHT_MEMORY_ALLOCATION (0x8009)//
#define ERROR_ACTIVITY_MEMORY_ALLOCATION (0x8800)//
#define ERROR_TREATMENT_STRUCTURE_CREATION (0x8801)//
#define ERROR_NOT_VALID_ACTIMETRY_DATA_TOBYPASS_PACEMAKER (0x8802)// 
#define ERROR_NOT_VALID_LIGHT_DATA_FOR_PACEMAKER (0x8803)// 


#endif