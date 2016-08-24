#ifndef __PROFILE_H_
#define __PROFILE_H_

typedef enum Sex 
{
	E_MALE,
	E_FEMALE,
	E_Other

} E_Sex_T;

typedef struct 
{
  int age;
  E_Sex_T sex;
  //double startTime;
} PROFILE_T;

typedef struct 
{
  double bedTime;
  double riseTime;
  //double startTime;
} GOAL_T;
#endif
