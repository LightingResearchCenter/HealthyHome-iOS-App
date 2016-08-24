/*
 * CLACScalc.c
 *
 *  Created on: July 15, 2015
 *      Author: Andrew Bierman
 *  Revised on: July 16, 2015 16:00
 */


#include "CLACScalc.h"
#include <math.h>

int32_t CLACScalc_ComputeMetrics(		unsigned int RedCounts,
										unsigned int GreenCounts,
										unsigned int BlueCounts,
										unsigned int ClearCounts,
										float *RLux,
										float *GLux,
										float *BLux,
										float *ClearLux,
										float *CLA,
										float *CS){

	// RGB + clear weighting constants for each response
	const float SmCoef[4] = {-0.005701,	-0.014015,	0.241859,	0.0}; // Scone/macula
	const float VmCoef[4] = {0.381876,	0.642883,	0.067544,	0.0}; // Vlamda/macula (L+M cones)
	const float MCoef[4]  = {0.000254,	0.167237,	0.261462,	0.0}; // Melanopsin
	const float VpCoef[4] = {0.004458,	0.360213,	0.189536,	0.0}; // Vprime (rods)
	// const float VCoef[4]  = {0.382859,	0.604808,	0.017628,	0.0}; // Vlambda
	// Model coefficients: a2, a3, k, A/683
	const float CLACoef[4]   = {0.700000,	3.000000,	0.261600,	2.266300};

	float Sm,Vm,M,Vp;

	if(RedCounts&0x8000 && GreenCounts&0x8000 && BlueCounts&0x8000){
		*RLux = 5*(float)(RedCounts&0x7FFF);
		*GLux = 5*(float)(GreenCounts&0x7FFF);
		*BLux = 5*(float)(BlueCounts&0x7FFF);
		*ClearLux = 5*(float)(ClearCounts);
	}
	else{
		*RLux = 0.1*(float)(RedCounts&0x7FFF);
		*GLux = 0.1*(float)(GreenCounts&0x7FFF);
		*BLux = 0.1*(float)(BlueCounts&0x7FFF);
		*ClearLux = 0.1*(float)ClearCounts;
	}

	// *Lux = VCoef[0]*Rlux + VCoef[1]*Glux + VCoef[2]*Blux + VCoef[3]*Clux;

	Sm = SmCoef[0]*(*RLux) + SmCoef[1]*(*GLux) + SmCoef[2]*(*BLux) + SmCoef[3]*(*ClearLux);
	Vm = VmCoef[0]*(*RLux) + VmCoef[1]*(*GLux) + VmCoef[2]*(*BLux) + VmCoef[3]*(*ClearLux);
	M  = MCoef[0]*(*RLux) + MCoef[1]*(*GLux)  + MCoef[2]*(*BLux)  + MCoef[3]*(*ClearLux);
	Vp = VpCoef[0]*(*RLux) + VpCoef[1]*(*GLux) + VpCoef[2]*(*BLux) + VpCoef[3]*(*ClearLux);


	if(Sm > CLACoef[3]*Vm)
		*CLA = M + CLACoef[0]*(Sm - CLACoef[2]*Vm) - CLACoef[1]*683*(1 - pow(2.7183,(-(Vp/(683*6.5)))));
	else
		*CLA = M;

	*CLA = CLACoef[3]*(*CLA);


	*CS = 0.7*(1-(1/(1+pow(*CLA/355.7,1.1026))));
	return 0; 	// Success
}
