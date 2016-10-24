function [result,C]=Task2_HOMV_Intersection(fileName,file1,as,bs,knn)
%Hausdroff distance between two point sets. Range [0,1.414] if normalized
%unitvectors are used. like sift. Have to check if 

delimiter=',';
hist=importdata(fileName,delimiter);

fs=as;
fe=bs;

%read video1 which needs to be comapred
ind1= find(strcmp(hist.textdata(:,1),file1));
videoVector1=hist.data(ind1,:);

start_point=0;end_point=start_point;
initial=2;
loop_count= size(videoVector1,1);
i=1;
index_of_list=1;
sum =0;
global_count_video1=0;
list_of_video1=zeros(loop_count,1);

%to count the start index and end index of frames
while i < loop_count
    value=videoVector1(i,1);
    value_to_compare=videoVector1(i+1,1);
    if (value==value_to_compare)
        sum=sum+1;
        list_of_video1(index_of_list,1)=sum;
        i=i+1;
    end
    if (value ~=value_to_compare)
        list_of_video1(index_of_list,1)=sum+1;
        index_of_list=index_of_list+1;
        i=i+1;
        sum=0;
    end  
end

ff=list_of_video1(index_of_list-1,1);
list_of_video1(index_of_list-1,1)=ff+1;
list_of_video1= list_of_video1( [1:index_of_list], : );

size_of_list1=size(list_of_video1,1);
new_matrix_video1=zeros(9500,size(videoVector1,2));

global_count=1;
previous_count=0;
start_from=0;
end_at=0;
j=0;
i=0;

%sort the matrix so that all cells are at one place
new_matrix_video1=sortrows(videoVector1,[1,2]);
new_matrix_video1=new_matrix_video1(:,2:size(new_matrix_video1,2));

global_count=size(new_matrix_video1,1);
video1_cell_count_list=zeros(global_count,1);
index_video1_cell_count_list=1;
ii=1;
sum=0;

% to count the cell indexes- start and end
while ii < global_count
    value=new_matrix_video1(ii,1);
    value_to_compare=new_matrix_video1(ii+1,1);
    if (value==value_to_compare)
        sum=sum+1;
        video1_cell_count_list(index_video1_cell_count_list,1)=sum;
        ii=ii+1;
    end
    if (value ~=value_to_compare)
        video1_cell_count_list(index_video1_cell_count_list,1)=sum+1;
        index_video1_cell_count_list=index_video1_cell_count_list+1;
        ii=ii+1;
        sum=0;
    end  
end

%remove extra rows and columns
video1_cell_count_list= video1_cell_count_list( [1:index_video1_cell_count_list], : );

y=0;
previous_count3=0;
start_from3=0;
end_at3=0; 
sum_1=0;sum_2=0;sum_3=0;sum_4=0;

%to compute the distance and angles for all motion vectors of one cell and
%write them as one entity
for y=1:size(video1_cell_count_list,1)
    count_of_cell=video1_cell_count_list(y,1);
    if (previous_count3==0)
        start_from3=1;
        end_at3=start_from3+count_of_cell-1;
        previous_count3=end_at3;
    else
        start_from3=previous_count3+1;
        end_at3=start_from3+count_of_cell-1;
        previous_count3=end_at3;
    end
    for x=start_from3:end_at3
        sx= new_matrix_video1(x,5);
        sy=new_matrix_video1(x,6);
        dx= new_matrix_video1(x,7);
        dy= new_matrix_video1(x,8);
        magnitude=sqrt(abs(dx-sx) * abs(dx-sx)+abs(dy-sy) * abs(dy-sy));
        theta = (atan((dy-sy)/(dx-sx))) * 57.33;
        if (theta<0)
            theta=theta+180;
        end
           if ( ( (dy-sy) ==0 && (dx-sx)==0) || (dx-sx)==0) 
                theta = 0;
           end
        new_matrix_video1(x,3)=magnitude;
        new_matrix_video1(x,4)=theta;  
    end   
end

start_from4=0;end_at4=0;
previous_count4=0; 
new_matrix_video1_HOMV=zeros(10000,5);
index_new_matrix_video1_HOMV=1;

% Create HOMV model with appropriate value distribution in bin
for u=1:size(video1_cell_count_list)
    count_of_cell=video1_cell_count_list(u,1);
    if (previous_count4==0)
        start_from4=1;
        end_at4=start_from4+count_of_cell-1;
        previous_count4=end_at4;
    else
        start_from4=previous_count4+1;
        end_at4=start_from4+count_of_cell-1;
        previous_count4=end_at4;
    end
    for xx=start_from4:end_at4
        cell_value=new_matrix_video1(xx,1);       
        initial_mag=new_matrix_video1(xx,3);
        initial_theta=new_matrix_video1(xx,4);
        initial_theta_m=abs(ceil(initial_theta/90));
        if (initial_theta_m==0)
            initial_theta_m=1;
        end
        multiply_mag_theta=initial_theta*initial_mag*4/count_of_cell;
        new_matrix_video1_HOMV(index_new_matrix_video1_HOMV,1)=cell_value;        
        if (initial_theta_m==1)
         sum_1=sum_1+multiply_mag_theta;
         new_matrix_video1_HOMV(index_new_matrix_video1_HOMV,initial_theta_m+1)=sum_1;         
        end
        if (initial_theta_m==2)
         sum_2=sum_2+multiply_mag_theta;
         new_matrix_video1_HOMV(index_new_matrix_video1_HOMV,initial_theta_m+1)=sum_2;
        end
        if (initial_theta_m==3)
         sum_3=sum_3+multiply_mag_theta;
         new_matrix_video1_HOMV(index_new_matrix_video1_HOMV,initial_theta_m+1)=sum_3;
        end
        if (initial_theta_m==4)
         sum_4=sum_4+multiply_mag_theta;
         new_matrix_video1_HOMV(index_new_matrix_video1_HOMV,initial_theta_m+1)=sum_4;
        end    
    end
        index_new_matrix_video1_HOMV=index_new_matrix_video1_HOMV+1;
   end

new_matrix_video1_HOMV= new_matrix_video1_HOMV( [1:index_new_matrix_video1_HOMV-1], : );

%rr=size(new_matrix_video1_HOMV,2);
rows_count_of_homv1=size(new_matrix_video1_HOMV,1);
summ=0;a=0;

%Normalising
for y=1:rows_count_of_homv1
   summ=0;
   a=(new_matrix_video1_HOMV(y,2))*(new_matrix_video1_HOMV(y,2));
   b=(new_matrix_video1_HOMV(y,3))*(new_matrix_video1_HOMV(y,3));
   c=(new_matrix_video1_HOMV(y,4))*(new_matrix_video1_HOMV(y,4));
   d=(new_matrix_video1_HOMV(y,5))*(new_matrix_video1_HOMV(y,5));
   summ=a+b+c+d;
   summ=sqrt(summ);
    if (summ==0)
        summ=1;
    end   
     new_matrix_video1_HOMV(y,2)=new_matrix_video1_HOMV(y,2)./summ;
     new_matrix_video1_HOMV(y,3)=new_matrix_video1_HOMV(y,3)./summ;
     new_matrix_video1_HOMV(y,4)=new_matrix_video1_HOMV(y,4)./summ;
     new_matrix_video1_HOMV(y,5)=new_matrix_video1_HOMV(y,5)./summ;  
end 

MultiArray=zeros(1,4);
maidx=1;

%Get all unique files from the hist data
C = unique(hist.textdata);

for video=1:size(C,1)    
    file2=C(video);
    
%Extract file2
ind2=find(strcmp(hist.textdata(:,1),file2));
videoVector2=hist.data(ind2,:);

start_point=0;
end_point=start_point;
initial=2;
loop_count= size(videoVector2,1);
i=1;
index_of_list=1;
sum =0;
list_of_video2=zeros(loop_count,1);

%to check the start index and end index of frames
while i < loop_count
    value=videoVector2(i,1);
    value_to_compare=videoVector2(i+1,1);
    if (value==value_to_compare)
        sum=sum+1;
        list_of_video2(index_of_list,1)=sum;
        i=i+1;
    end
    if (value ~=value_to_compare)
        list_of_video2(index_of_list,1)=sum+1;
        index_of_list=index_of_list+1;
        i=i+1;
        sum=0;
    end  
end
ff=list_of_video2(index_of_list-1,1);
list_of_video2(index_of_list-1,1)=ff+1;
list_of_video2 = list_of_video2( [1:index_of_list], : );

size_of_list2=size(list_of_video2,1);

new_matrix_video2=zeros(9500,size(videoVector2,2));
video2_cell_count_list=zeros(global_count,1);
global_count=1;previous_count=0;start_from=0;end_at=0;j=0;i=0;

previous_count=0;
start_from=0;end_at=0;

%normalising the matrix 
new_matrix_video2=sortrows(videoVector2,[1,2]);
new_matrix_video2=new_matrix_video2(:,2:size(new_matrix_video2,2));


global_count=size(new_matrix_video2,1);
video2_cell_count_list=zeros(global_count,1);

video2_cell_count_list=zeros(global_count,1);
index_video2_cell_count_list=1;
ii=1;
sum=0;

%to count the star and end index of cell
while ii < global_count
    value=new_matrix_video2(ii,1);
    value_to_compare=new_matrix_video2(ii+1,1);
    if (value==value_to_compare)
        sum=sum+1;
        video2_cell_count_list(index_video2_cell_count_list,1)=sum;
        ii=ii+1;
    end
    if (value ~=value_to_compare)
        video2_cell_count_list(index_video2_cell_count_list,1)=sum+1;
        index_video2_cell_count_list=index_video2_cell_count_list+1;
        ii=ii+1;
        sum=0;
    end  
end

video2_cell_count_list= video2_cell_count_list( [1:index_video2_cell_count_list], : );


y=0;
previous_count3=0;
start_from3=0;
end_at3=0;

%to compute the distance and angles for all motion vectors of one cell
for y=1:size(video2_cell_count_list,1)
    count_of_cell=video2_cell_count_list(y,1);
    if (previous_count3==0)
        start_from3=1;
        end_at3=start_from3+count_of_cell-1;
        previous_count3=end_at3;
    else
        start_from3=previous_count3+1;
        end_at3=start_from3+count_of_cell-1;
        previous_count3=end_at3;
    end
    for x=start_from3:end_at3
        sx= new_matrix_video2(x,5);
        sy=new_matrix_video2(x,6);
        dx= new_matrix_video2(x,7);
        dy= new_matrix_video2(x,8);
        magnitude=sqrt(abs(dx-sx) * abs(dx-sx)+abs(dy-sy) * abs(dy-sy));
        theta = (atan((dy-sy)/(dx-sx))) * 57.33;
        if (theta<0)
            theta=theta+180;
        end
           if ( ( (dy-sy) ==0 && (dx-sx)==0) || (dx-sx)==0) 
                theta = 0;
           end
        new_matrix_video2(x,3)=magnitude;
        new_matrix_video2(x,4)=theta;
    end 
end

count_of_cell=0;
previous_count4=0;
start_from4=0;
end_at4=0;

initial_theta=0;
xx=0;
initial_mag=0;
final_magnitude=0;
final_theta=0;
index_matrix_video2=1;
cell_value=0;
new_matrix_video2_HOMV=zeros(10000,5);

index_new_matrix_video2_HOMV=1;
initial_theta_m=0; multiply_mag_theta=0;sum_1=0;sum_2=0;sum_3=0;sum_4=0;
 
u=0;
previous_count4=0; start_from4=0; end_at4=0;
 
%Assigning values at appropriate bins
for u=1:size(video2_cell_count_list,1)
     count_of_cell=video2_cell_count_list(u,1);
    if (previous_count4==0)
        start_from4=1;
        end_at4=start_from4+count_of_cell-1;
        previous_count4=end_at4;
    else
        start_from4=previous_count4+1;
        end_at4=start_from4+count_of_cell-1;
        previous_count4=end_at4;
    end
    for xx=start_from4:end_at4
        cell_value=new_matrix_video2(xx,1);
        initial_mag=new_matrix_video2(xx,3);
        initial_theta=new_matrix_video2(xx,4);
        initial_theta_m=abs(ceil(initial_theta/90));
        if (initial_theta_m==0)
            initial_theta_m=1;
        end
        multiply_mag_theta=initial_theta*initial_mag*4/count_of_cell;
        new_matrix_video2_HOMV(index_new_matrix_video2_HOMV,1)=cell_value;
        
        if (initial_theta_m==1)
         sum_1=sum_1+multiply_mag_theta;
         new_matrix_video2_HOMV(index_new_matrix_video2_HOMV,initial_theta_m+1)=sum_1;
         
        end
        if (initial_theta_m==2)
         sum_2=sum_2+multiply_mag_theta;
         new_matrix_video2_HOMV(index_new_matrix_video2_HOMV,initial_theta_m+1)=sum_2;
        end
        if (initial_theta_m==3)
         sum_3=sum_3+multiply_mag_theta;
         new_matrix_video2_HOMV(index_new_matrix_video2_HOMV,initial_theta_m+1)=sum_3;
        end
        if (initial_theta_m==4)
         sum_4=sum_4+multiply_mag_theta;
         new_matrix_video2_HOMV(index_new_matrix_video2_HOMV,initial_theta_m+1)=sum_4;
        end    
    end
        index_new_matrix_video2_HOMV=index_new_matrix_video2_HOMV+1;
        sum_1=0;sum_2=0;sum_3=0;sum_4=0;
    end

new_matrix_video2_HOMV= new_matrix_video2_HOMV( [1:index_new_matrix_video2_HOMV-1], : );

rr=size(new_matrix_video2_HOMV,2);
rows_count_of_homv2=size(new_matrix_video2_HOMV,1);
summ=0;a=0;

%normalising matrix
for y=1:rows_count_of_homv2
   summ=0;
   a=(new_matrix_video2_HOMV(y,2))*(new_matrix_video2_HOMV(y,2));
   b=(new_matrix_video2_HOMV(y,3))*(new_matrix_video2_HOMV(y,3));
   c=(new_matrix_video2_HOMV(y,4))*(new_matrix_video2_HOMV(y,4));
   d=(new_matrix_video2_HOMV(y,5))*(new_matrix_video2_HOMV(y,5));
   summ=a+b+c+d;
   summ=sqrt(summ);
    if (summ==0)
        summ=1;
    end   
     new_matrix_video2_HOMV(y,2)=new_matrix_video2_HOMV(y,2)./summ;
     new_matrix_video2_HOMV(y,3)=new_matrix_video2_HOMV(y,3)./summ;
     new_matrix_video2_HOMV(y,4)=new_matrix_video2_HOMV(y,4)./summ;
     new_matrix_video2_HOMV(y,5)=new_matrix_video2_HOMV(y,5)./summ;
   
end 

%rr=size(new_matrix_video2_HOMV,2);
rows_count_of_homv2=size(new_matrix_video2_HOMV,1);

summ=0;a=0;

i_new=0; j_new=0; dist_new=0; c_new=0;
mag1_1=0; mag1_2=0;mag2_1=0;mag2_2=0;
mag3_1=0;mag3_2=0;mag4_1=0;mag4_2=0;
 
nframes1 = videoVector1(size(videoVector1,1), 1); 
nframes2 = videoVector2(size(videoVector2,1), 1);
nframes1=nframes1-1;
nframes2=nframes2-1;
final_matrix=zeros(nframes1,nframes2);

rows=size(new_matrix_video2,1);
r=new_matrix_video2(rows,1);

alpha=0.8;
beta=1.2;

%k sliding window size to be compared 
p=fe-fs+1;
kk=floor(p*beta)-floor(p*alpha);
k=floor(p*beta);

steps=floor(p/2);

maxx=0; minn=0;

%Creating result matrix using Intersection
for strt=1:steps:(nframes2-1)-steps*2
        sSize=min(k,(nframes2-1)-strt);
    final_matrix=zeros(sSize,p);
    for i_new=fs:fe
        sSize2=min((nframes2-1),strt+k-1);
        for j_new=strt:sSize2
            dot=0;
        for c_new=1:r
            mag1_1=new_matrix_video1_HOMV(r*(i_new)+c_new,2); 
            mag1_2=new_matrix_video2_HOMV(r*(j_new)+c_new,2);
            mag2_1=new_matrix_video1_HOMV(r*(i_new)+c_new,3);
            mag2_2=new_matrix_video2_HOMV(r*(j_new)+c_new,3);
            mag3_1=new_matrix_video1_HOMV(r*(i_new)+c_new,4);
            mag3_2=new_matrix_video2_HOMV(r*(j_new)+c_new,4);
            mag4_1=new_matrix_video1_HOMV(r*(i_new)+c_new,5);
            mag4_2=new_matrix_video2_HOMV(r*(j_new)+c_new,5);
            maxx=maxx+max(mag1_1,mag1_2);
            minn=minn+min(mag1_2,mag1_1);                        
            maxx=maxx+max(mag2_1,mag2_2);
            minn=minn+min(mag2_2,mag2_1);            
            maxx=maxx+max(mag3_1,mag3_2);
            minn=minn+min(mag3_2,mag3_1);            
            maxx=maxx+max(mag4_1,mag4_2);
            minn=minn+min(mag4_2,mag4_1);
        end
         if (maxx==0)
             dot=1;
         else
             dot=minn/maxx;
         end
            final_matrix(j_new-strt+1,i_new-fs+1)=1-dot; 
            maxx=0; minn=0;
        end
    end   

    %MultiArray(maidx,:,:)=[strt,strt+k-1,dynamicMultiple(corresDistance)];
    dm=dynamicMultiple(final_matrix,kk);
    
    %one way get the smallest distance in variable frame comparision
    [dmMin,idx]=min(dm);
    MultiArray(maidx,:,:)=[video,strt,sSize2-kk-1+idx,dmMin];
    maidx=maidx+1;   
    
end

MultiArraySort=sortrows(MultiArray,4);
knn=min(knn,size(MultiArraySort,1));

end
result=MultiArraySort(1:knn,:);


