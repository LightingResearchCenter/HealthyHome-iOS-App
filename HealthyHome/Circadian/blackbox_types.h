/*
 * blackbox_types.h
 *
 * Code generation for function 'blackbox'
 *
 * C source code generated on: Mon Jul 13 11:40:53 2015
 *
 */

#ifndef __BLACKBOX_TYPES_H__
#define __BLACKBOX_TYPES_H__

/* Include files */
#include "rtwtypes.h"
#include "config.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T
{
    double *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_real_T*/
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /*typedef_emxArray_real_T*/
#ifndef typedef_b_struct_T
#define typedef_b_struct_T
typedef struct
{
    emxArray_real_T *timeUTC;
    emxArray_real_T *timeOffset;
    emxArray_real_T *activityIndex;
    emxArray_real_T *activityCount;
} b_struct_T;
#endif /*typedef_b_struct_T*/
#ifndef typedef_c_struct_T
#define typedef_c_struct_T
typedef struct
{
    double runTimeUTC;
    double runTimeOffset;
    double version;
    char model[5];
    double x0;
    double xc0;
    double t0;
    double xn;
    double xcn;
    double tn;
} c_struct_T;
#endif /*typedef_c_struct_T*/
#ifndef struct_emxArray_real_T_192
#define struct_emxArray_real_T_192
struct emxArray_real_T_192
{
    double data[LRCtreatmentSize];
    int size[1];
};
#endif /*struct_emxArray_real_T_192*/
#ifndef typedef_emxArray_real_T_192
#define typedef_emxArray_real_T_192
typedef struct emxArray_real_T_192 emxArray_real_T_192;
#endif /*typedef_emxArray_real_T_192*/
#ifndef struct_emxArray_real_T_193
#define struct_emxArray_real_T_193
struct emxArray_real_T_193
{
    double data[LRCtreatmentSize+1];
    int size[1];
};
#endif /*struct_emxArray_real_T_193*/
#ifndef typedef_emxArray_real_T_193
#define typedef_emxArray_real_T_193
typedef struct emxArray_real_T_193 emxArray_real_T_193;
#endif /*typedef_emxArray_real_T_193*/
#ifndef struct_sIIslapQxDlSGr9yuhN5B0
#define struct_sIIslapQxDlSGr9yuhN5B0
struct sIIslapQxDlSGr9yuhN5B0
{
    double n;
    emxArray_real_T_192 startTimeUTC;
    emxArray_real_T_193 durationMins;
};
#endif /*struct_sIIslapQxDlSGr9yuhN5B0*/
#ifndef typedef_d_struct_T
#define typedef_d_struct_T
typedef struct sIIslapQxDlSGr9yuhN5B0 d_struct_T;


#endif /*typedef_d_struct_T*/
#ifndef typedef_e_struct_T
#define typedef_e_struct_T
typedef struct
{
    double n;
    double startTimeUTC[LRCtreatmentSizeOrig];
    double durationMins[LRCtreatmentSizeOrig];
} e_struct_T;
#endif /*typedef_e_struct_T*/
#ifndef struct_emxArray__common
#define struct_emxArray__common
struct emxArray__common
{
    void *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray__common*/
#ifndef typedef_emxArray__common
#define typedef_emxArray__common
typedef struct emxArray__common emxArray__common;
#endif /*typedef_emxArray__common*/
#ifndef struct_emxArray_boolean_T
#define struct_emxArray_boolean_T
struct emxArray_boolean_T
{
    boolean_T *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_boolean_T*/
#ifndef typedef_emxArray_boolean_T
#define typedef_emxArray_boolean_T
typedef struct emxArray_boolean_T emxArray_boolean_T;
#endif /*typedef_emxArray_boolean_T*/
#ifndef struct_emxArray_int32_T
#define struct_emxArray_int32_T
struct emxArray_int32_T
{
    int *data;
    int *size;
    int allocatedSize;
    int numDimensions;
    boolean_T canFreeData;
};
#endif /*struct_emxArray_int32_T*/
#ifndef typedef_emxArray_int32_T
#define typedef_emxArray_int32_T
typedef struct emxArray_int32_T emxArray_int32_T;
#endif /*typedef_emxArray_int32_T*/
#ifndef struct_emxArray_int32_T_1
#define struct_emxArray_int32_T_1
struct emxArray_int32_T_1
{
    int data[1];
    int size[1];
};
#endif /*struct_emxArray_int32_T_1*/
#ifndef typedef_emxArray_int32_T_1
#define typedef_emxArray_int32_T_1
typedef struct emxArray_int32_T_1 emxArray_int32_T_1;
#endif /*typedef_emxArray_int32_T_1*/
#ifndef struct_emxArray_int32_T_191
#define struct_emxArray_int32_T_191
struct emxArray_int32_T_191
{
    int data[LRCtreatmentSize-1];
    int size[1];
};
#endif /*struct_emxArray_int32_T_191*/
#ifndef typedef_emxArray_int32_T_191
#define typedef_emxArray_int32_T_191
typedef struct emxArray_int32_T_191 emxArray_int32_T_191;
#endif /*typedef_emxArray_int32_T_191*/
#ifndef struct_emxArray_int32_T_192
#define struct_emxArray_int32_T_192
struct emxArray_int32_T_192
{
    int data[LRCtreatmentSize];
    int size[1];
};
#endif /*struct_emxArray_int32_T_192*/
#ifndef typedef_emxArray_int32_T_192
#define typedef_emxArray_int32_T_192
typedef struct emxArray_int32_T_192 emxArray_int32_T_192;
#endif /*typedef_emxArray_int32_T_192*/
#ifndef struct_emxArray_int32_T_193
#define struct_emxArray_int32_T_193
struct emxArray_int32_T_193
{
    int data[LRCtreatmentSize+1];
    int size[1];
};
#endif /*struct_emxArray_int32_T_193*/
#ifndef typedef_emxArray_int32_T_193
#define typedef_emxArray_int32_T_193
typedef struct emxArray_int32_T_193 emxArray_int32_T_193;
#endif /*typedef_emxArray_int32_T_193*/
#ifndef struct_emxArray_real_T_1
#define struct_emxArray_real_T_1
struct emxArray_real_T_1
{
    double data[1];
    int size[1];
};
#endif /*struct_emxArray_real_T_1*/
#ifndef typedef_emxArray_real_T_1
#define typedef_emxArray_real_T_1
typedef struct emxArray_real_T_1 emxArray_real_T_1;
#endif /*typedef_emxArray_real_T_1*/
#ifndef struct_emxArray_real_T_1x192
#define struct_emxArray_real_T_1x192
struct emxArray_real_T_1x192
{
    double data[LRCtreatmentSize];
    int size[2];
};
#endif /*struct_emxArray_real_T_1x192*/
#ifndef typedef_emxArray_real_T_1x192
#define typedef_emxArray_real_T_1x192
typedef struct emxArray_real_T_1x192 emxArray_real_T_1x192;
#endif /*typedef_emxArray_real_T_1x192*/
#ifndef typedef_struct_T
#define typedef_struct_T
typedef struct
{
    emxArray_real_T *timeUTC;
    emxArray_real_T *timeOffset;
    emxArray_real_T *red;
    emxArray_real_T *green;
    emxArray_real_T *blue;
    emxArray_real_T *clear;
    emxArray_real_T *cla;
    emxArray_real_T *cs;
} struct_T;
#endif /*typedef_struct_T*/

#endif
/* End of code generation (blackbox_types.h) */
