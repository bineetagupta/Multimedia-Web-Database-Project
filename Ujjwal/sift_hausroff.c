/*
* sift_euclidian 
** multiplies two sift descriptors using euclidian distance
** https://www.mathworks.com/help/matlab/matlab_external/standalone-example.html#zmw57dd0e19250
**/

#include "mex.h"
#include<math.h>

#define MAX_DOUBLE mxGetInf()

double spatialHausdroff(const double *D1,const double *D2, int col_D1, int col_D2,int dim){
	int i,j;
	double maxDist=0;
	for(i=0;i<col_D1;++i,D1+=dim){
		double minDist=MAX_DOUBLE;
		
		for(j=0;j<col_D2;++j,D2+=dim){
			double dist=0;
			int k;
			for(k=0;k<dim;k++){
				//L2 norm
				dist+=(D1[k]-D2[k])*(D1[k]-D2[k]);
			}
			//dist=sqrt(dist);
			//mexPrintf("Distance = %g\n",dist);
			//Update the nearest neighbour
			if(dist<minDist) minDist=dist;
		}
		
		//Update the maximum distance between the distribution
		if(maxDist<minDist) maxDist=minDist;
		//Reset the D2 pointer for next iteration
		D2-=col_D2*dim;
	}

	//mexPrintf("Hausdroff Distance = %g\n",maxDist);
	return sqrt(maxDist);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	//Check for two inputs
	if( nrhs !=2 ){
		mexErrMsgIdAndTxt("MyToolbox:sift_distance:nrhs", "Two inputs required");
	}
	
	//Check for input argument types
	if(!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1])) {
		mexErrMsgIdAndTxt("MyToolbox:sift_distance:nrhs","Input Vector must be of type double");
	}
	//Check if row size is same
	if(mxGetM(prhs[0])!=mxGetM(prhs[1])){
		mexErrMsgIdAndTxt("MyToolbox:sift_distance:nrhs","Input Vectors must have same number of rows");
	}
	
	const double *D1;
	const double *D2;
	
	//Input dimesions
	int col_D1=mxGetN(prhs[0]);
	int col_D2=mxGetN(prhs[1]);
	int dim=mxGetM(prhs[0]);
	
	D1=mxGetData(prhs[0]);
	D2=mxGetData(prhs[1]);
	
	if(col_D1>0 && col_D2>0){
		double D12=spatialHausdroff(D1,D2,col_D1,col_D2,dim);
		double D21=spatialHausdroff(D2,D1,col_D2,col_D1,dim);
		
		
		if(D12>D21) {
			//mexPrintf("Hausdroff Distance = %g\n",D12);
			plhs[0] = mxCreateDoubleScalar(D12);
		}
		else {
			//mexPrintf("Hausdroff Distance = %g\n",D21);
			plhs[0] = mxCreateDoubleScalar(D21);
		}	
	}
	else {	
		plhs[0] = mxCreateDoubleScalar(MAX_DOUBLE);
	}
}