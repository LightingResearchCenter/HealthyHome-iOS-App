#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include "profile.h"
#include "blackbox_types.h"
#include "CircadianModel.h"		
#include "lightreading.h"
#include "blackbox_emxutil.h"
#include "prepare_light_struct.h"
#include "prepare_activity_struct.h"

#define MIN_SLEEP_TIME (0)
#define MAX_SLEEP_TIME (23.99)
#define MIN_WAKE_TIME (0)
#define MAX_WAKE_TIME (23.99)
#define _CRTDBG_MAP_ALLOC


const char* getfield(char* line, int num);
PROFILE_T myProfile;
GOAL_T myGoal;
double runTimeUTC, runTimeOffset;



int CircadianModel_Initialize( PROFILE_T pUserProfile, GOAL_T pUserGoals, double ptimeUTC, double pOffest)

{
/* Variables*/

int return_value;

/* Set up the User Profile settings*/

myGoal.bedTime = pUserGoals.bedTime;
myGoal.riseTime = pUserGoals.riseTime;
myProfile.age = pUserProfile.age;
myProfile.sex = pUserProfile.sex;
/* Set up runtime values*/

runTimeUTC = ptimeUTC;
runTimeOffset = pOffest;

/*Generating Error Codes*/
return_value=0;

if( (pUserGoals.bedTime < MIN_SLEEP_TIME) || (pUserGoals.bedTime > MAX_SLEEP_TIME) ){

		return_value=ERROR_CODE_INVALID_SLEEP_TIME;

	}

if( (pUserGoals.riseTime	 < MIN_WAKE_TIME) || (pUserGoals.riseTime > MAX_WAKE_TIME) ){

		return_value=ERROR_CODE_INVALID_WAKE_TIME;

	}
return (return_value);

}


int CircadianModelRun(FILE *pActivityReading, FILE *pLightReading, FILE *pfPacemaker, d_struct_T* pTreatment, c_struct_T  *myPacemaker, double *pDistanceToGoal)
{
	int numOfLinesInFileLight,numOfLinesInFileActivity , numOfLinesInFilePacemaker, lineNumber, i;
	int return_value;
	char line[100];
	char * tmp1, *tmp2, * tmp3, *tmp4, * tmp5, *tmp6, * tmp7, *tmp8, * tmp9, *tmp10;
	LIGHTREADING_T *myLightreading;
	ACTIVITYREADING_T * myActivityreading;
	double bedTime, riseTime,tempdouble;
	double distanceToGoal_data[1];
    int distanceToGoal_size[2];

	emxArray_real_T *intimeUTCLight;
	emxArray_real_T *intimeOffsetLight;
    emxArray_real_T *inred;
    emxArray_real_T *ingreen;
    emxArray_real_T *inblue;
    emxArray_real_T *inclear;
    
    emxArray_real_T *incla;
    emxArray_real_T *incs;
	struct_T *lightReading;

	emxArray_real_T *intimeUTCActivity;
    emxArray_real_T *intimeOffsetActivity;
    emxArray_real_T *inactivityIndex;
    emxArray_real_T *inactivityCount;
	b_struct_T *activityReading;

	double n_treat;
    emxArray_real_T_192 instartTimeUTCTreat;
    emxArray_real_T_193 indurationMinsTreat;
	d_struct_T *treatment;

	c_struct_T * myPacemaker_old;


	emxInit_real_T(&intimeUTCActivity, 2);
	emxInit_real_T(&intimeOffsetActivity, 2);
	emxInit_real_T(&inactivityIndex, 2);
	emxInit_real_T(&inactivityCount, 2);

	emxInit_real_T(&intimeUTCLight, 2);
	emxInit_real_T(&intimeOffsetLight, 2);
	emxInit_real_T(&inred, 2);
	emxInit_real_T(&ingreen, 2);
	emxInit_real_T(&inblue, 2);
    emxInit_real_T(&inclear, 2);
    
	emxInit_real_T(&incla, 2);
	emxInit_real_T(&incs, 2);

	 /* reading light data*/
	
   fgets(line, 100, pLightReading); //header
   numOfLinesInFileLight=0;
   while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
        //printf("Field 7 would be %s\n", getfield(tmp, 7));
        // NOTE strtok clobbers tmp
        free(tmp);
		numOfLinesInFileLight++;
    }

   myLightreading = (LIGHTREADING_T *) malloc(numOfLinesInFileLight*sizeof(LIGHTREADING_T));
   if (myLightreading  == NULL)
	{
		emxFree_real_T(&intimeUTCActivity);
		emxFree_real_T(&intimeOffsetActivity);
		emxFree_real_T(&inactivityIndex);
		emxFree_real_T(&inactivityCount);
		emxFree_real_T(&intimeUTCLight);
		emxFree_real_T(&intimeOffsetLight);
		emxFree_real_T(&inred);
		emxFree_real_T(&ingreen);
		emxFree_real_T(&inblue);
        emxFree_real_T(&inclear);
        
		emxFree_real_T(&incla);
		emxFree_real_T(&incs);
		//printf ("Fatal Error Allocating memory\r\n");
		return_value =ERROR_LIGHT_MEMORY_ALLOCATION;
		return(return_value);
	}
  
   tempdouble=numOfLinesInFileLight;

   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].timeUTC =atof( getfield(tmp, 1));
        free(tmp);
		lineNumber ++ ;
	 }

   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
	    myLightreading[lineNumber].timeOffset =atof( getfield(tmp, 2));
	    // NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].red =atof( getfield(tmp, 3));
		// NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
	   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].green =atof( getfield(tmp, 4));
		        // NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
    
   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].blue =atof( getfield(tmp, 5));
		// NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }

    fseek(pLightReading, 0, SEEK_SET);
    fgets(line, 100, pLightReading); //header
    lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
        myLightreading[lineNumber].clear =atof( getfield(tmp, 6));
        // NOTE strtok clobbers tmp
        free(tmp);
        lineNumber ++ ;
    }
    
    
    
   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].cla =atof( getfield(tmp, 7));
		// NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
   fseek(pLightReading, 0, SEEK_SET);
   fgets(line, 100, pLightReading); //header
   lineNumber=0;
    while (fgets(line, 100, pLightReading))
    {
        char* tmp = strdup(line);
		myLightreading[lineNumber].cs =atof( getfield(tmp, 8));
        //printf("Field 7 would be %s\n", getfield(tmp, 7));
        // NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }


     tempdouble=myLightreading[2].cs;
	 lightReading = (struct_T *) malloc(sizeof(struct_T));
	 if (lightReading  == NULL)
	 {
		emxFree_real_T(&intimeUTCActivity);
		emxFree_real_T(&intimeOffsetActivity);
		emxFree_real_T(&inactivityIndex);
		emxFree_real_T(&inactivityCount);
		emxFree_real_T(&intimeUTCLight);
		emxFree_real_T(&intimeOffsetLight);
		emxFree_real_T(&inred);
		emxFree_real_T(&ingreen);
		emxFree_real_T(&inblue);
        emxFree_real_T(&inclear);
		emxFree_real_T(&incla);
		emxFree_real_T(&incs);
		
		free(myLightreading);
		
		//printf ("Fatal Error Allocating memory\r\n");
		return_value =ERROR_LIGHT_MEMORY_ALLOCATION;
		return(return_value);
	 }

	 prepare_light_struct(myLightreading, intimeUTCLight, intimeOffsetLight, inred, ingreen, inblue , inclear, incla , incs ,numOfLinesInFileLight);
	 tempdouble = incs->data[8];
	 free(myLightreading);

/* Reading Activity Data*/

   fgets(line, 100, pActivityReading); //header
   numOfLinesInFileActivity=0;
   while (fgets(line, 100, pActivityReading))
    {
        char* tmp = strdup(line);
        //printf("Field 4 would be %s\n", getfield(tmp, 4));
        // NOTE strtok clobbers tmp
        free(tmp);
		numOfLinesInFileActivity++;
    }

   myActivityreading = (ACTIVITYREADING_T *) malloc(numOfLinesInFileActivity*sizeof(ACTIVITYREADING_T));
     if (myActivityreading  == NULL)
	 {
		emxFree_real_T(&intimeUTCActivity);
		emxFree_real_T(&intimeOffsetActivity);
		emxFree_real_T(&inactivityIndex);
		emxFree_real_T(&inactivityCount);
		emxFree_real_T(&intimeUTCLight);
		emxFree_real_T(&intimeOffsetLight);
		emxFree_real_T(&inred);
		emxFree_real_T(&ingreen);
		emxFree_real_T(&inblue);
        emxFree_real_T(&inclear);
         
		emxFree_real_T(&incla);
		emxFree_real_T(&incs);

		free(lightReading);
		//printf ("Fatal Error Allocating memory\r\n");
		return_value =ERROR_ACTIVITY_MEMORY_ALLOCATION;
		return(return_value);
	 }
  
   tempdouble=numOfLinesInFileActivity;

   fseek(pActivityReading, 0, SEEK_SET);
   fgets(line, 100, pActivityReading); //header
   lineNumber=0;
    while (fgets(line, 100, pActivityReading))
    {
        char* tmp = strdup(line);
		myActivityreading[lineNumber].timeUTC =atof( getfield(tmp, 1));
        free(tmp);
		lineNumber ++ ;
	 }

   fseek(pActivityReading, 0, SEEK_SET);
   fgets(line, 100, pActivityReading); //header
   lineNumber=0;
    while (fgets(line, 100, pActivityReading))
    {
        char* tmp = strdup(line);
	    myActivityreading[lineNumber].timeOffset =atof( getfield(tmp, 2));
	    // NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
   fseek(pActivityReading, 0, SEEK_SET);
   fgets(line, 100, pActivityReading); //header
   lineNumber=0;
    while (fgets(line, 100, pActivityReading))
    {
        char* tmp = strdup(line);
		myActivityreading[lineNumber].activityIndex =atof( getfield(tmp, 3));
		// NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
   fseek(pActivityReading, 0, SEEK_SET);
   fgets(line, 100, pActivityReading); //header
   lineNumber=0;
    while (fgets(line, 100, pActivityReading))
    {
        char* tmp = strdup(line);
		myActivityreading[lineNumber].activityCount =atof( getfield(tmp, 4));
		        // NOTE strtok clobbers tmp
        free(tmp);
		lineNumber ++ ;
	 }
   

     //tempdouble=myLightreading[20314].cs;
	 tempdouble=myActivityreading[2].activityIndex;
	 activityReading = (b_struct_T *) malloc(sizeof(b_struct_T));
	 if (activityReading  == NULL)
	  {
		    emxFree_real_T(&intimeUTCActivity);
			emxFree_real_T(&intimeOffsetActivity);
			emxFree_real_T(&inactivityIndex);
			emxFree_real_T(&inactivityCount);
			emxFree_real_T(&intimeUTCLight);
			emxFree_real_T(&intimeOffsetLight);
			emxFree_real_T(&inred);
			emxFree_real_T(&ingreen);
			emxFree_real_T(&inblue);
            emxFree_real_T(&inclear);
			emxFree_real_T(&incla);
			emxFree_real_T(&incs);

			free(myActivityreading);
			free(lightReading);
			//printf ("Fatal Error Allocating memory\r\n");
		    return_value =ERROR_ACTIVITY_MEMORY_ALLOCATION;
			return(return_value);
	  }
	 prepare_activity_struct(myActivityreading, intimeUTCActivity, intimeOffsetActivity,inactivityIndex, inactivityCount, numOfLinesInFileActivity);
	 tempdouble = inactivityIndex->data[8];

     free(myActivityreading);
	
	/*Initialize runtime Variables*/
	bedTime = myGoal.bedTime;
	riseTime = myGoal.riseTime;

	/*constructing pacemaker structure*/


	myPacemaker_old= (c_struct_T *) malloc(sizeof(c_struct_T));
	if (myPacemaker_old  == NULL)
	  {
		    emxFree_real_T(&intimeUTCActivity);
			emxFree_real_T(&intimeOffsetActivity);
			emxFree_real_T(&inactivityIndex);
			emxFree_real_T(&inactivityCount);
			emxFree_real_T(&intimeUTCLight);
			emxFree_real_T(&intimeOffsetLight);
			emxFree_real_T(&inred);
			emxFree_real_T(&ingreen);
			emxFree_real_T(&inblue);
            emxFree_real_T(&inclear);
			emxFree_real_T(&incla);
			emxFree_real_T(&incs);

			free(lightReading);
			free(activityReading);
		    //printf ("Fatal Error Allocating memory\r\n");
		    return_value =ERROR_PACEMAKER_MEMORY_ALLOCATION;
		    return(return_value);
	  }

   fgets(line, 100, pfPacemaker); //header
   numOfLinesInFilePacemaker=0;
   while (fgets(line, 100, pfPacemaker))
    {
        char* tmp = strdup(line);
        //printf("Field 7 would be %s\n", getfield(tmp, 7));
        // NOTE strtok clobmotbers tmp
        free(tmp);
		numOfLinesInFilePacemaker++;
    }

   if (numOfLinesInFilePacemaker ==0){
	
    fclose(pfPacemaker);
    myPacemaker_old->runTimeUTC = runTimeUTC;
	myPacemaker_old->runTimeOffset = runTimeOffset;
	myPacemaker_old->version = LRCversion;
	strcpy(myPacemaker_old->model,LRCmodel);
	myPacemaker_old->x0 = 0;
	myPacemaker_old->xc0 = 0;
	myPacemaker_old->t0 = 0;
	myPacemaker_old->xn = 0;
	myPacemaker_old->xcn = 0;
	myPacemaker_old->tn = 0;
   }
   else{
	   fseek(pfPacemaker, 0, SEEK_SET);
       fgets(line, 100, pfPacemaker); //header
	   for(i=0;i<numOfLinesInFilePacemaker;i++){
		     fgets(line, 100, pfPacemaker);
		   }
    fclose(pfPacemaker);

    tmp1 = strdup(line);
	tmp2 = strdup(line);
	tmp3 = strdup(line);
	tmp4 = strdup(line);
	tmp5 = strdup(line);
	tmp6 = strdup(line);
	tmp7 = strdup(line);
	tmp8 = strdup(line);
	tmp9 = strdup(line);
	tmp10 = strdup(line);

	myPacemaker_old->runTimeUTC= atof( getfield(tmp1, 1));
	myPacemaker_old->runTimeOffset = atof( getfield(tmp2, 2));
	myPacemaker_old->version = atof( getfield(tmp3, 3));
	strcpy(myPacemaker_old->model,getfield(tmp4, 4));
	myPacemaker_old->x0 = atof( getfield(tmp5, 5));
	myPacemaker_old->xc0 = atof( getfield(tmp6, 6));
	myPacemaker_old->t0 = atof( getfield(tmp7, 7));
	myPacemaker_old->xn = atof( getfield(tmp8, 8));
	myPacemaker_old->xcn = atof( getfield(tmp9, 9));
	myPacemaker_old->tn = atof( getfield(tmp10, 10));
	free(tmp1);
	free(tmp2);
	free(tmp3);
	free(tmp4);
	free(tmp5);
	free(tmp6);
	free(tmp7);
	free(tmp8);
	free(tmp9);
	free(tmp10);

   }
   	/* matlab input structures*/
	treatment = (d_struct_T *) malloc(sizeof(d_struct_T)); 
	if (treatment  == NULL)
	  {
        	emxFree_real_T(&intimeUTCActivity);
			emxFree_real_T(&intimeOffsetActivity);
			emxFree_real_T(&inactivityIndex);
			emxFree_real_T(&inactivityCount);
			emxFree_real_T(&intimeUTCLight);
			emxFree_real_T(&intimeOffsetLight);
			emxFree_real_T(&inred);
			emxFree_real_T(&ingreen);
			emxFree_real_T(&inblue);
            emxFree_real_T(&inclear);
			emxFree_real_T(&incla);
			emxFree_real_T(&incs);

			free(lightReading);
			free(activityReading);
			free(myPacemaker_old);
        return_value=ERROR_TREATMENT_STRUCTURE_CREATION;
		return(return_value);
	  }

   /*Preparing inputs for blackbox program*/

	activityReading->timeUTC = intimeUTCActivity;
	activityReading->timeOffset =  intimeOffsetActivity;
	activityReading->activityIndex = inactivityIndex;
	activityReading->activityCount = inactivityCount;

	lightReading->timeUTC = intimeUTCLight;
	lightReading->timeOffset =intimeOffsetLight;
	lightReading->red = inred;
	lightReading->green = ingreen;
	lightReading->blue = inblue;
    lightReading->clear = inclear;
	lightReading->cla = incla;
	lightReading->cs = incs;

	tempdouble=lightReading->cs->data[7];

	/*Preparing treat structure */
	indurationMinsTreat.size[1]=0;
	indurationMinsTreat.data[0]=0;

	instartTimeUTCTreat.size[1]=0;
	instartTimeUTCTreat.data[0]=0;

	n_treat=0;

	treatment->durationMins=indurationMinsTreat;
	treatment->startTimeUTC=instartTimeUTCTreat;
	treatment->n=n_treat;

	distanceToGoal_data[0]=0.0;
	distanceToGoal_size[0]=0;
	distanceToGoal_size[1]=0;

   /*Running LRC blackbox program*/
    
	return_value= blackbox( runTimeUTC,  runTimeOffset, myGoal.bedTime, myGoal.riseTime, lightReading, activityReading, 
		myPacemaker_old, treatment, myPacemaker, distanceToGoal_data, distanceToGoal_size); 

	if (return_value!=ERROR_CODE_NONE){
		free(lightReading);
		free(activityReading);
		free(treatment);
		free(myPacemaker_old);

		emxFree_real_T(&intimeUTCActivity);
		emxFree_real_T(&intimeOffsetActivity);
		emxFree_real_T(&inactivityIndex);
		emxFree_real_T(&inactivityCount);
		emxFree_real_T(&intimeUTCLight);
		emxFree_real_T(&intimeOffsetLight);
		emxFree_real_T(&inred);
		emxFree_real_T(&ingreen);
		emxFree_real_T(&inblue);
        emxFree_real_T(&inclear);
		emxFree_real_T(&incla);
		emxFree_real_T(&incs);
		return(return_value);
	}else{


		pTreatment->durationMins=treatment->durationMins;
		pTreatment->n =treatment->n;
		pTreatment->startTimeUTC=treatment->startTimeUTC;
		*pDistanceToGoal=distanceToGoal_data[0]/SECONDSinHOUR;


		/*Appending results to pacemaker.csv file */
//		pfPacemaker = fopen("pacemaker.csv", "a");
//		if (pfPacemaker == NULL) 
//		{
//			emxFree_real_T(&intimeUTCActivity);
//			emxFree_real_T(&intimeOffsetActivity);
//			emxFree_real_T(&inactivityIndex);
//			emxFree_real_T(&inactivityCount);
//			emxFree_real_T(&intimeUTCLight);
//			emxFree_real_T(&intimeOffsetLight);
//			emxFree_real_T(&inred);
//			emxFree_real_T(&ingreen);
//			emxFree_real_T(&inblue);
//			emxFree_real_T(&incla);
//			emxFree_real_T(&incs);
//
//			free(lightReading);
//			free(activityReading);
//			free(treatment);
//			free(myPacemaker_old);
//			
//			//printf ("Exception - Error Opening data file\r\n");
//			return_value= ERROR_PACEMAKER_MEMORY_ALLOCATION;
//			return(return_value);
//		}

		//fprintf(pfPacemaker,"%10.2f,%3.2f,%1.2f,%s,%2.2f,%2.2f,%10.2f,%2.2f,%2.2f,%10.2f\n",myPacemaker->runTimeUTC, myPacemaker->runTimeOffset, myPacemaker->version, myPacemaker->model,
		//myPacemaker->x0, myPacemaker->xc0, myPacemaker->t0, myPacemaker->xn, myPacemaker->xcn, myPacemaker->tn);

		fclose(pfPacemaker);

   		emxFree_real_T(&intimeUTCActivity);
		emxFree_real_T(&intimeOffsetActivity);
		emxFree_real_T(&inactivityIndex);
		emxFree_real_T(&inactivityCount);
		emxFree_real_T(&intimeUTCLight);
		emxFree_real_T(&intimeOffsetLight);
		emxFree_real_T(&inred);
		emxFree_real_T(&ingreen);
		emxFree_real_T(&inblue);
        emxFree_real_T(&inclear);
		emxFree_real_T(&incla);
		emxFree_real_T(&incs);

		free(lightReading);
		free(activityReading);
		free(treatment);
		//free(myPacemaker);
		free(myPacemaker_old);
		}

    return (return_value);
    
}




const char* getfield(char* line, int num)
{
    const char* tok;
    for (tok = strtok(line, ",");
            tok && *tok;
            tok = strtok(NULL, ",\n"))
    {
        if (!--num)
            return tok;
    }
    return NULL;
}