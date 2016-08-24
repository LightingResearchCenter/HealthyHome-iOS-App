#ifndef __LIGHTREADING_H_
#define __LIGHTREADING_H_

typedef struct 
{
  double timeUTC;
  double timeOffset;
  double red;
  double green;
  double blue;
  double clear;
  double cla;
  double cs;
} LIGHTREADING_T;

typedef struct 
{
  double timeUTC;
  double timeOffset;
  double activityIndex;
  double activityCount;
} ACTIVITYREADING_T;

typedef struct 
{
  double runTimeUTC;
  double runTimeOffset;
  const char * version  ;
  const char * model; 
  double x0;
  double xc0;
  double t0;
  double xn;
  double xcn;
  double tn;
} PACEMAKER_T;

#endif


