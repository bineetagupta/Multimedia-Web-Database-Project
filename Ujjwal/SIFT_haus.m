%function SIFT_Sample(fileName)
%Hausdroff distance between two point sets. Range [0,1.414] if normalized
%unitvectors are used. like sift. Have to check if 
fileName='oldVideos_SIFT.csv';
delimiter=',';
hist=importdata(fileName,delimiter);
histMaxRow=size(hist.data,1);

nFrames1=75;
nFrames2=50;
strt=1;

file1='1R.mp4';
file2='square_L_R_texture.mp4';

%Extract file1
ind1= find(strcmp(hist.textdata(:,1),file1));
videoVector1=hist.data(ind1,:);

%Extract file2
ind2=find(strcmp(hist.textdata(:,1),file2));
videoVector2=hist.data(ind2,:);

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

dist=0;
strt=1;

corresDistance=zeros(nFrames2,nFrames1);

for i=1:nFrames1
    for j=1:nFrames2
        corresDistance(j,i)=sift_hausroff(videoVector1(findex1(i,1)+1:findex1(i+1,1),8:135)',videoVector2(findex2(j,1)+1:findex2(j+1,1),8:135)');
    end
end

dynamicAllign(corresDistance)
