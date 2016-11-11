fileName='Histogram.csv';
delimiter=',';
hist=importdata(fileName,delimiter);
histMaxRow=size(hist.data,1);
strt=1;

file1='1R.mp4';
file2='10R.mp4';

while strcmp(hist.textdata(strt,1),file1)==0
    strt=strt+1;
end

fin=strt+1;

while strcmp(hist.textdata(fin,1),file1)==1
    fin=fin+1;
end

fin=fin-1;

videoVector1=hist.data(strt:fin,4:13);
 
strt=1;
fin=1;

while strcmp(hist.textdata(strt,1),file2)==0
    strt=strt+1;
end

fin=strt+1;

while fin<=histMaxRow && strcmp(hist.textdata(fin,1),file2)==1
    fin=fin+1;
end

fin=fin-1;

videoVector2=hist.data(strt:fin,4:13);

fid=fopen('c.out','wt');

thres=100;
thres_count=0;
for i=1:size(videoVector1,1)
    for j=1:size(videoVector2,1)
        man=manhattan(videoVector1(i,:),videoVector2(j,:));
        if man<thres
            thres_count=thres_count+1;
            break;
        end      
    end
end

fclose(fid);