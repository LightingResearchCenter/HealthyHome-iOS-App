#include <memory.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "lightreading.h"
#include "blackbox.h"
#include "blackbox_emxutil.h"


/* Function Declaration */

void prepare_light_struct(LIGHTREADING_T * myLightreading, emxArray_real_T *timeUTC, emxArray_real_T *timeOffset, emxArray_real_T *red,
									emxArray_real_T *green, emxArray_real_T *blue , emxArray_real_T *clear ,emxArray_real_T *cla , emxArray_real_T *cs,int dataLength)

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

  red->size[1] = 1;
  red->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)red, i0, (int)sizeof(double));
  
  green->size[1] = 1;
  green->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)green, i0, (int)sizeof(double));
    
  blue->size[1] = 1;
  blue->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)blue, i0, (int)sizeof(double));
  
  clear->size[1] = 1;
  clear->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)clear, i0, (int)sizeof(double));
  
  cla->size[1] = 1;
  cla->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)cla, i0, (int)sizeof(double));


  cs->size[1] = 1;
  cs->size[0] = dataLength;
  emxEnsureCapacity((emxArray__common *)cs, i0, (int)sizeof(double));

  for (i0 = 0; i0 < dataLength; i0++) {

	  timeUTC->data[i0] = myLightreading[i0].timeUTC;
	  timeOffset->data[i0] = myLightreading[i0].timeOffset;
	  red->data[i0] = myLightreading[i0].red;
	  green->data[i0] = myLightreading[i0].green;
	  blue->data[i0] = myLightreading[i0].blue;
      clear->data[i0] = myLightreading[i0].clear;
	  cla->data[i0] = myLightreading[i0].cla;
	  cs->data[i0] = myLightreading[i0].cs;
	  
  }
  testdouble = red->data[0] ;



}
