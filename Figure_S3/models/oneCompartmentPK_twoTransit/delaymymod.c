
#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include <time.h>
static double parms[6];
#define V1 parms[0]
#define kout parms[1]
#define kin parms[2]
#define ktr parms[3]

#define timeout parms[4]
#define starttime parms[5]



void initmod(void (* odeparms)(int *, double *)){
	int N=6;
	odeparms(&N, parms);}

void derivs (int *neq, double *t, double *y, double *ydot, double *yout, int *ip){
	if (ip[0] < 0 ) error("nout not enough!");
	time_t s = time(NULL);
	if((int) s - (int) starttime > timeout) error("timeout!");

	if(y[0]>-1e-6 && y[0]<1e-6) {y[0]=0;}
	if(y[1]>-1e-6 && y[1]<1e-6) {y[1]=0;}
	if(y[2]>-1e-6 && y[2]<1e-6) {y[2]=0;}
	if(y[3]>-1e-6 && y[3]<1e-6) {y[3]=0;}
	if(y[4]>-1e-6 && y[4]<1e-6) {y[4]=0;}


	//1 compartment PK model ===================================================
	ydot[0] = 0; // bioavailability
	ydot[1] = -(ktr*y[0]*y[1])-((1-y[0])*ktr*y[1]); //dose compartment (in mass/s)
	ydot[2] = ktr*y[0]*y[1] - ktr*y[2]; //transit compartment 1 (in mass/s)
	ydot[3] = ktr*y[2] - kin*y[3]; //transit compartment 2 (in mass/s)
	ydot[4] = kin*y[3] - kout*y[4]; // plasma compartment (mass/s)





	//Outputs

	yout[0]=((y[4]*1e6)/((V1))); /*Opioid plasma concentration (ng/mL) assumes y[4] is in mg and V1 is mL*/ 



}
