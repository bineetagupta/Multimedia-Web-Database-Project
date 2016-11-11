function minRes=sortHist(res,C)
vSize=size(C,1);
minRes=zeros(1,4);
midx=1;
for i=1:vSize
   ind1= find(res(:,1)==i); 
   p=res(ind1,:);
   uniq=unique(p(:,2));
   for j=1:size(uniq,1)
       ind2= find(p(:,2)==uniq(j));
       qp=p(ind2,:);
       q=p(ind2,4);
       [qm,qi]=min(q);
       minRes(midx,:)=qp(qi,:);
       midx=midx+1;
   end
   
end