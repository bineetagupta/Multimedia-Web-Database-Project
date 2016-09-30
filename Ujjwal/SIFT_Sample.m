function SIFT_Sample(fileName)

%fileName='SIFT.csv';
delimiter=',';
hist=importdata(fileName,delimiter);

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

videoVector1=hist.data(strt:fin,8:135);

strt=1;
fin=1;

%handle later
%sortedVideoVector1=sortrows(videoVector1,[1 2]);

while strcmp(hist.textdata(strt,1),file2)==0
    strt=strt+1;
end

fin=strt+1;

while strcmp(hist.textdata(fin,1),file2)==1
    fin=fin+1;
end

fin=fin-1;


%handle later
%sortedVideoVector2=sortrows(videoVector2,[1 2]);

videoVector2=hist.data(strt:fin,8:135);

fid=fopen('sift.out','wt');

% %passing as integers
% videoVector1=uint8(512*videoVector1);
% videoVector2=uint8(512*videoVector2);


matchCount=0;

%With sift library
matches=siftmatch(videoVector1',videoVector2');

%with own code
sift_distance(videoVector1',videoVector2');

%Full iteration
%  for i=1:size(videoVector1,1)
%      bestMatch=99999;
%      secondBest=99999;
%      
%      for j=1:size(videoVector2,1)
%         % tempMatch = manhattan(videoVector1(i,:),videoVector2(j,:));
%         
%         dist=norm(double(videoVector1(i,:)-videoVector2(j,:)));
%                
%         tempMatch=dist;
%          if tempMatch<bestMatch
%              secondBest=bestMatch;
%              bestMatch=tempMatch;
%          elseif tempMatch<secondBest
%              secondBest=tempMatch;
%          end
%          
%          %fprintf(fid,'%d,%d,%d\n',i,j,manhattan(videoVector1(i,:),videoVector1(j,:)));
%      end
%      if bestMatch*1.22<secondBest
%          matchCount=matchCount+1;
%      end
%      
%  end

fclose(fid);