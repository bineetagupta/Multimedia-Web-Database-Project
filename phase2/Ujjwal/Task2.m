%function SIFT_Sample(fileName)

%Hausdroff distance between two point sets. Range [0,1.414] if normalized

%unitvectors are used. like sift. Have to check if 

fileName='SIFT.csv';

delimiter=',';

hist=importdata(fileName,delimiter);

histMaxRow=size(hist.data,1);



nFrames1=50;

nFrames2=50;

a=31;

b=40;



file1='square_L_R.mp4';



file2='square_T_B.mp4';



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



k=b-a+1;

strt=1;

maidx=1;



MultiArray=zeros();

for strt=1:k:nFrames2-k

    corresDistance=zeros(k,k);

    for i=a:b

        for j=strt:strt+k-1

            corresDistance(j-strt+1,i-a+1)=sift_hausroff(videoVector1(findex1(i,1)+1:findex1(i+1,1),8:135)',videoVector2(findex2(j,1)+1:findex2(j+1,1),8:135)');

        end

    end



    MultiArray(maidx)=dynamicAllign(corresDistance);

    maidx=maidx+1;

end



[sma,ima] = sort(MultiArray);

ima=(ima-1)*k+1;