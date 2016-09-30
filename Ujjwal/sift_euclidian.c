/*
* sift_euclidian 
** multiplies two sift descriptors using euclidian distance
** https://www.mathworks.com/help/matlab/matlab_external/standalone-example.html#zmw57dd0e19250
**/

#include "mex.h"

#define MAX_DOUBLE mxGetInf()

void computeDistance(const double *D1,const double *D2, int col_D1, int col_D2,int dim, float thres){
	int i,j;
	int matchCount=0;
	int loopCounter=0;
	    for(i=0 ; i<col_D1 ; ++i, D1+=dim) {
			double bestMatch=MAX_DOUBLE;
			double secondBest=MAX_DOUBLE;
			for(j=0; j<col_D2;++j, D2+=dim){
				loopCounter++;
				int k;
				double dist=0;
				for(k=0;k<dim;++k){
					double temp=D1[k]-D2[k];
					dist+=temp*temp;
				}
				
				//update best and second best
				if(dist<bestMatch){
					secondBest=bestMatch;
					bestMatch=dist;
				}
				else if(dist<secondBest){
					secondBest=dist;
				}
			}
			//reset D2 pointer;
			D2-=col_D2*dim;
			
			//Check with threshold
			if(bestMatch*thres<=secondBest){
				matchCount++;
			}
		}
	mexPrintf("No of Sift matches: %d\n",matchCount);
	mexPrintf("No of loops: %d\n",loopCounter);
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
	
	//Set thres
	float thres=1.5;
	computeDistance(D1,D2,col_D1,col_D2,dim,thres);
}