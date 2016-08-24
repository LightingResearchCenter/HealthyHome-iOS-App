/*
 * CLACScalc.h
 *
 *  Created on: July 15, 2015
 *      Author: Andrew Bierman
 *  Revised on: July 16,2015
 */

#ifndef CLACSCALC_H_
#define CLACSCALC_H_
#include <stdlib.h>


int32_t CLACScalc_ComputeMetrics(		unsigned int RedCounts,
										unsigned int GreenCounts,
										unsigned int BlueCounts,
										unsigned int ClearCounts,
										float *computedR,
										float *computedG,
										float *computedB,
										float *computedClear,
										float *CLA,
										float *CS);

#endif /* CLACSCALC_H_ */
