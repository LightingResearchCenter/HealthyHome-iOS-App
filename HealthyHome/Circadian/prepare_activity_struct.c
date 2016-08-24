#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "lightreading.h"
#include "blackbox.h"
#include "blackbox_emxutil.h"

/* Function Declaration */
void prepare_activity_struct(ACTIVITYREADING_T * myActivityreading, emxArray_real_T *timeUTC, 
							 emxArray_real_T *timeOffset, emxArray_real_T *activityIndex,emxArray_real_T *activityCount, int dataLength)
{
int i0;
double testdouble;



  i0 = timeUTC->size[0] * timeUTC->size[1];
  
  timeUTC->size[1] = 1;
  timeUTC->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)timeUTC, i0, (int)sizeof(double));
  
  timeOffset->size[1] = 1;
  timeOffset->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)timeOffset, i0, (int)sizeof(double));
  
    
  activityIndex->size[1] = 1;
  activityIndex->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)activityIndex, i0, (int)sizeof(double));
    
  activityCount->size[1] = 1;
  activityCount->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)activityCount, i0, (int)sizeof(double));
  
  for (i0 = 0; i0 < dataLength; i0++) {
	  timeUTC->data[i0] = myActivityreading[i0].timeUTC;
	  timeOffset->data[i0] = myActivityreading[i0].timeOffset;
	  activityIndex->data[i0] = myActivityreading[i0].activityIndex;
	  activityCount->data[i0] = myActivityreading[i0].activityCount;
  }
  testdouble = activityIndex->data[8] ;
}


