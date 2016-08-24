#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <stdint.h>

#include "profile.h"
#include "lightreading.h"
#include "blackbox.h"
#include "prepare_activity_struct.h"
#include "prepare_light_struct.h"
#include "blackbox_emxutil.h"
#include "CircadianModel.h"


#define _CRTDBG_MAP_ALLOC

#include <crtdbg.h>





int main(int argc, char *argv[])
{

	int  errorCode, i, numOfLinesInFileLight,numOfLinesInFileActivity , numOfLinesInFilePacemaker,lineNumber, treatnumber;
	PROFILE_T myProfile;
    GOAL_T myGoal;
	double runTimeUTC, runTimeOffset;

    char **headerFields;
    char **rowFields ;
	char * tmp1, *tmp2, * tmp3, *tmp4, * tmp5, *tmp6, * tmp7, *tmp8, * tmp9, *tmp10;

	FILE *myDataFile;
	LIGHTREADING_T *myLightreading;
	ACTIVITYREADING_T * myActivityreading;
	c_struct_T * myPacemaker_old, *myPacemaker;
	char * tempchar;
	const char * tempchara;
	char *record;
	char buffer[1024] ;
	char *token;
	const char * const array[]={"timeUTC", "timeOffset","red", "green", "blue", "cla", "cs"};
	//char line[200];
	double tempdouble;
	double tempdoubleptr;
	double T1,T2, distanceToGoal[1];
	
	double distanceToGoal_data[1];
    int distanceToGoal_size[2];

	emxArray_real_T *intimeUTCLight;
	emxArray_real_T *intimeOffsetLight;
    emxArray_real_T *inred;
    emxArray_real_T *ingreen;
    emxArray_real_T *inblue;
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

	FILE* streamLight, * streamActivity, * streamPacemaker, *stream;
	char line[100];


	emxInit_real_T(&intimeUTCActivity, 2);
	emxInit_real_T(&intimeOffsetActivity, 2);
	emxInit_real_T(&inactivityIndex, 2);
	emxInit_real_T(&inactivityCount, 2);

	emxInit_real_T(&intimeUTCLight, 2);
	emxInit_real_T(&intimeOffsetLight, 2);
	emxInit_real_T(&inred, 2);
	emxInit_real_T(&ingreen, 2);
	emxInit_real_T(&inblue, 2);
	emxInit_real_T(&incla, 2);
	emxInit_real_T(&incs, 2);
	
	
	

	_CrtSetDbgFlag ( _CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF );

    /* Set up the User Profile and goal settings*/
    myProfile.age = 42;
	myProfile.sex=E_MALE;
	myGoal.riseTime=6.5;
	myGoal.bedTime=22.5;

	/*Initialize Variables*/
	runTimeUTC = 1437637059.724;//1421847870;//1397652960;
	runTimeOffset = -5;

	
	errorCode= CircadianModel_Initialize( myProfile, myGoal, runTimeUTC , runTimeOffset);

   /* reading light data*/
	
   streamLight = fopen("lightReading.csv", "r");
   if (streamLight == NULL) 
	{
		printf ("Exception - Error Opening data file\r\n");
		return -1;
	}
  


/* Reading Activity Data*/

 
	
   streamActivity = fopen("activityReading.csv", "r");
   if (streamActivity == NULL) 
	{
		printf ("Exception - Error Opening data file\r\n");
		return -1;
	}
  
  

	/*constructing pacemaker structure*/
	myPacemaker= (c_struct_T *) malloc(sizeof(c_struct_T));
   if (myPacemaker  == NULL)
	  {
		printf ("Fatal Error Allocating memory\r\n");
		exit(0);
	  }
	myPacemaker_old= (c_struct_T *) malloc(sizeof(c_struct_T));
	if (myPacemaker_old  == NULL)
	  {
		printf ("Fatal Error Allocating memory\r\n");
		exit(0);
	  }

	myPacemaker->runTimeUTC = runTimeUTC;
	myPacemaker->runTimeOffset = runTimeOffset;
	myPacemaker->version = LRCversion;
	strcpy(myPacemaker->model,LRCmodel);
	myPacemaker->x0 = 0;
	myPacemaker->xc0 = 0;
	myPacemaker->t0 = 0;
	myPacemaker->xn = 0;
	myPacemaker->xcn = 0;
	myPacemaker->tn = 0;

	streamPacemaker = fopen("pacemaker.csv", "r");
    if (streamPacemaker == NULL) 
	{
		printf ("Exception - Error Opening data file\r\n");
		return -1;
	}

  	

	/* matlab input structures*/
	treatment = (d_struct_T *) malloc(sizeof(d_struct_T)); 
	if (treatment  == NULL)
	  {
		printf ("Fatal Error Allocating memory\r\n");
		exit(0);
	  }

	/*Preparing treat structure */
	indurationMinsTreat.size[1]=0;
	indurationMinsTreat.data[0]=0;

	instartTimeUTCTreat.size[1]=0;
	instartTimeUTCTreat.data[0]=0;

	n_treat=0;

	treatment->durationMins=indurationMinsTreat;
	treatment->startTimeUTC=instartTimeUTCTreat;
	treatment->n=n_treat;

	distanceToGoal[0]=0.0;
	errorCode = CircadianModelRun(streamActivity, streamLight, streamPacemaker, treatment, myPacemaker, distanceToGoal);


   
   	/*Displaying results*/

	if (errorCode ==ERROR_CODE_NONE){
    
		treatnumber=treatment->n;
		printf("There are %d treatments.\n",treatnumber);
		treatnumber=treatment->n;
	
		if(treatnumber !=0) {
			for(i=0;i< treatnumber; i++){
				printf("Treatment starts at utc time: %lf, with the duration of %lf min\n", treatment->startTimeUTC.data[i],treatment->durationMins.data[i]);
			}
		}
		printf("Distance to goal: %lf hours.\n", distanceToGoal[0]);

		stream = fopen("treatment.csv", "a");
		if (stream == NULL) 
		{
			printf ("Exception - Error Opening data file\r\n");
			return -1;
		}
		if(treatnumber !=0) {
			for(i=0;i< treatnumber; i++){
				T1=treatment->startTimeUTC.data[i];
				T2= treatment->durationMins.data[i];
				fprintf(stream,"%lf, %lf\n",  T1, T2);
			}
		}
	
		//stream = fopen("treatment.csv", "a");


		fclose(stream);
	}
	else{
		printf("Exception - Error Code %d.\r\n", errorCode);
	}

			  
	/*Freeing allocated memory*/
	emxFree_real_T(&intimeUTCActivity);
	emxFree_real_T(&intimeOffsetActivity);
	emxFree_real_T(&inactivityIndex);
	emxFree_real_T(&inactivityCount);
	emxFree_real_T(&intimeUTCLight);
	emxFree_real_T(&intimeOffsetLight);
	emxFree_real_T(&inred);
	emxFree_real_T(&ingreen);
	emxFree_real_T(&inblue);
	emxFree_real_T(&incla);
	emxFree_real_T(&incs);


	free(treatment);
	free(myPacemaker);
	free(myPacemaker_old);


    return 0; 


}

