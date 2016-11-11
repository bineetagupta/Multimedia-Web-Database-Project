function res=allignOverall(mh,ma,C)
ma=sortHist(mh,C);
mh=sortHist(ma,C);

if(size(mh,1)<=size(ma,1))
    jj=ma(1:size(mh,1),4)+mh(1:size(mh,1),4);
    mh(:,4)=jj;
    res=mh;
else
    jj=mh(1:size(ma,1),4)+ma(1:size(ma,1),4);
    ma(:,4)=jj;
    res=ma;
end
