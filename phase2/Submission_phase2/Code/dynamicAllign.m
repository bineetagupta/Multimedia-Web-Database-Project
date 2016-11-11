function dist=dynamicAllign(matrix)
%have to modify distance when there are no sift features for certain videos
%matrix=corresDistance;

%Replace Max distance with 1.414 max sift distance
%matrix(matrix==Inf)=1;
nFrames1=size(matrix,1);
nFrames2=size(matrix,2);

%Weighting Functions
w2=2/(nFrames1+nFrames2);
w1=1/(nFrames1+nFrames2);

matrixD=Inf(size(matrix)+1);

matrixD(1,1)=0;


for i=2:nFrames1+1
    for j=2:nFrames2+1
        matrixD(i,j)= min([matrixD(i-1,j-1)+matrix(i-1,j-1)*w2,matrixD(i-1,j)+
            matrix(i-1,j-1)*w1,matrixD(i,j-1)+
            matrix(i-1,j-1)*w1]);
    end
end
dist=matrixD(nFrames1+1,nFrames2+1);
