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
	const float SmCoef[4] = {-0.070873,	-0.204847,	0.265436,	0.243761}; // Scone/macula
	const float VmCoef[4] = {0.040024,	0.028073,	-0.112701,	1.117983}; // Vlamda/macula (L+M cones)
	const float MCoef[4]  = {0.120659,	0.374496,	0.404917,	-0.471267}; // Melanopsin
	const float VpCoef[4] = {0.152405,	0.679046,	0.317550,	-0.590977}; // Vprime (rods)
	// const float VCoef[4]  = {0.025021,	0.003694,	-0.211097,	1.178995}; // Vlambda
	// Model coefficients: a2, a3, k, A/683
	const float CLACoef[4]   = {0.583972,	3.298705,	0.239282,	2.308392};

	// RGB ONLY weighting constants for each response
	const float SmCoef2[4] = {0.000981,	-0.079768,	0.309320,	0.0}; // Scone/macula
	const float VmCoef2[4] = {0.347166,	0.684235,	0.039616,	0.0}; // Vlamda/macula (L+M cones)
	const float MCoef2[4]  = {-0.016200,	0.110203,	0.336419,	0.0}; // Melanopsin
	const float VpCoef2[4] = {-0.021933,	0.356985,	0.226024,	0.0}; // Vprime (rods)
	// const float VCoef2[4]  = {0.385371,	0.618378,	-0.015533,	0.0}; // Vlambda
	// Model coefficients: a2, a3, k, A/683
	const float CLACoef2[4]   = {0.545682,	3.269864,	0.234354,	2.309318};
	
	float Sm,Vm,M,Vp;

	if(RedCounts&0x8000 && GreenCounts&0x8000 && BlueCounts&0x8000){
		*RLux = 20*(float)(RedCounts&0x7FFF);
		*GLux = 20*(float)(GreenCounts&0x7FFF);
		*BLux = 20*(float)(BlueCounts&0x7FFF);
		*ClearLux = 20*(float)(ClearCounts);
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


	if(Sm > CLACoef[2]*Vm)
		*CLA = M + CLACoef[0]*(Sm - CLACoef[2]*Vm) - CLACoef[1]*683*(1 - pow(2.7183,(-(Vp/(683*6.5)))));
	else
		*CLA = M;
	
	*CLA = CLACoef[3]*(*CLA);

	if((*CLA) < 0){ // If CLA is negative try again without the clear channel
		Sm = SmCoef2[0]*(*RLux) + SmCoef2[1]*(*GLux) + SmCoef2[2]*(*BLux) + SmCoef2[3]*(*ClearLux);
		Vm = VmCoef2[0]*(*RLux) + VmCoef2[1]*(*GLux) + VmCoef2[2]*(*BLux) + VmCoef2[3]*(*ClearLux);
		M  = MCoef2[0]*(*RLux) + MCoef2[1]*(*GLux)  + MCoef2[2]*(*BLux)  + MCoef2[3]*(*ClearLux);
		Vp = VpCoef2[0]*(*RLux) + VpCoef2[1]*(*GLux) + VpCoef2[2]*(*BLux) + VpCoef2[3]*(*ClearLux);
		
		if(Sm > CLACoef[2]*Vm)
			*CLA = M + CLACoef2[0]*(Sm - CLACoef2[2]*Vm) - CLACoef2[1]*683*(1 - pow(2.7183,(-(Vp/(683*6.5)))));
		else
			*CLA = M;
		
		*CLA = CLACoef2[3]*(*CLA);
		
		if((*CLA) < 0) // If CLA is still negative set it to zero
			*CLA = 0;
	}


	*CS = 0.7*(1-(1/(1+pow(*CLA/355.7,1.1026))));
	return 0; 	// Success
}
