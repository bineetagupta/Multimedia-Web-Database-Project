function [result,C]=Task2SIFTEuclidean(fileName,file1,a,b,knn)
%Hausdroff distance between two point sets. Range [0,1.414] if normalized
%unitvectors are used. like sift. Have to check if 
%fileName='out_file_50_spca.csv';
delimiter=',';
hist=importdata(fileName,delimiter);

%using mat file
%MatLoad=load('D:filename.mat');
%hist=MatLoad.hist;

% a=11;
% b=30;
% 
% file1='2R.mp4';
 %file2='2R.mp4';
% knn=5;

%Extract file1
ind1= strcmp(hist.textdata(:,1),file1);
videoVector1=hist.data(ind1,:);
nFrames1=videoVector1(size(videoVector1,1),1);


MultiArray=zeros(1,4);
maidx=1;

%Get all unique files from the hist data
C = unique(hist.textdata);

for video=1:size(C,1)
    
    file2=C(video);
    %Extract file2
ind2=strcmp(hist.textdata(:,1),file2);
videoVector2=hist.data(ind2,:);

nFrames2=videoVector2(size(videoVector2,1),1);

%Get sift per frame from videoVector1
fstrt=1;
fend=fstrt;
findex1=zeros(nFrames1+1,1);
i=1;
sv1=size(videoVector1,1);
while fend<sv1
    while (videoVector1(fend,1)==i)
        fend=fend+1;
        if fend>sv1
            break;
        end
    end

    findex1(i+1,1)=fend-1;
    i=i+1;
end

%Get sift per frame from videoVector2
fstrt=1;
fend=fstrt;
findex2=zeros(nFrames2+1,1);
i=1;
sv1=size(videoVector2,1);
while fend<sv1
    while (videoVector2(fend,1)==i)
        fend=fend+1;
        if fend>sv1
            break;
        end
    end

    findex2(i+1,1)=fend-1;
    i=i+1;
end

alpha=0.8;
beta=1.2;

%k sliding window size to be compared 
p=b-a;
kk=floor(p*beta)-floor(p*alpha);
k=floor(p*beta);


steps=floor(p/2);

dStart=8;
dEnd=size(videoVector1,2);

for strt=1:steps:nFrames2-steps*2

    sSize=min(k,nFrames2-strt);
    if(strt+k>=nFrames2)
        break;
    end
    corresDistance=zeros(sSize,p);
    for i=a:b-1
        sSize2=min(nFrames2,strt+k-1);
        for j=strt:sSize2-1
            corresDistance(j-strt+1,i-a+1)=sift_euclidian(videoVector1(findex1(i,1)+1:findex1(i+1,1),dStart:dEnd)',videoVector2(findex2(j,1)+1:findex2(j+1,1),dStart:dEnd)');
        end
    end

    %MultiArray(maidx,:,:)=[strt,strt+k-1,dynamicMultiple(corresDistance)];
    dm=dynamicMultiple(corresDistance,kk);
    
    %one way get the smallest distance in variable frame comparision
     [dmMin,idx]=min(dm);
     MultiArray(maidx,:,:)=[video,strt,sSize2-kk-1+idx,dmMin];
     maidx=maidx+1;

    %other way    
%    for idx=1:size(dm,1)
%        MultiArray(maidx,:,:)=[video,strt,sSize2-kk-1+idx,dm(idx)];
%        maidx=maidx+1;
%    end
    
    
end

% [sma,ima] = sort(MultiArray);
% ima=(ima-1)*k+1;
end

MultiArraySort=sortrows(MultiArray,4);
knn=min(knn,size(MultiArraySort,1));
result=MultiArraySort(1:knn,:);