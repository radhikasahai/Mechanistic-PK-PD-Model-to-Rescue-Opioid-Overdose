
#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>
#include <time.h>
static double parms[9];
#define V1 parms[0]
#define kout parms[1]
#define kin parms[2]
#define k12 parms[3]
#define k21 parms[4]
#define k13 parms[5]
#define k31 parms[6]

#define timeout parms[7]
#define starttime parms[8]



void initmod(void (* odeparms)(int *, double *)){
	int N=9;
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
	ydot[1] = -(kin*y[0]*y[1])-((1-y[0])*kin*y[1]); //dose compartment (in mass/s)
	ydot[2] = kin*y[0]*y[1] - kout*y[2] - k12*y[2] + k21*y[3]- k13*y[2] + k31*y[4]; // plasma compartment (mass/s)
	ydot[3] = k12*y[2] - k21*y[3]; // 1st peripheral compartment (mass/s)
	ydot[4] = k13*y[2] - k31*y[4]; // 2nd peripheral compartment (mass/s)




	//Outputs

	yout[0]=((y[2]*1e6)/((V1))); /*Opioid plasma concentration (ng/mL) assumes y[2] is in mg*/ 



}
