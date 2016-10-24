function final_distance = HOMV_Manhattan(fileName,file1,file2)

%take csv as input
delimiter=',';
hist=importdata(fileName,delimiter);
histMaxRow=size(hist.data,1);


%Extract file1
ind1= find(strcmp(hist.textdata(:,1),file1));
videoVector1=hist.data(ind1,:);

%Extract file2
ind2=find(strcmp(hist.textdata(:,1),file2));
videoVector2=hist.data(ind2,:);

start_point=0;end_point=start_point;
initial=2;loop_count= size(videoVector1,1);i=1;index_of_list=1;sum =0;global_count_video1=0;
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

start_point=0;end_point=start_point;
initial=2;loop_count= size(videoVector2,1);i=1;index_of_list=1;sum =0;list_of_video2=zeros(loop_count,1);

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

size_of_list1=size(list_of_video1,1);
size_of_list2=size(list_of_video2,1);

new_matrix_video1=zeros(9500,12);

global_count=1;previous_count=0;start_from=0;end_at=0;j=0;i=0;
new_matrix_video1=sortrows(videoVector1,[1,2]);
new_matrix_video1=new_matrix_video1(:,2:size(new_matrix_video1,2));
global_count=size(new_matrix_video1,1);
video2_cell_count_list=zeros(global_count,1);

video1_cell_count_list=zeros(global_count,1);
index_video1_cell_count_list=1;ii=1;sum=0;

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

video1_cell_count_list= video1_cell_count_list( [1:index_video1_cell_count_list], : );

size_of_list2=size(list_of_video2,1);new_matrix_video2=zeros(9500,11);previous_count=0;
start_from=0;end_at=0;global_count=1;

new_matrix_video2=sortrows(videoVector2,[1,2]);
new_matrix_video2=new_matrix_video2(:,2:size(new_matrix_video2,2));
global_count=size(new_matrix_video2,1);
video2_cell_count_list=zeros(global_count,1);

video2_cell_count_list=zeros(global_count,1);
index_video2_cell_count_list=1;ii=1;sum=0;

%to count the start and end index of a cell in a frame
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

y=0;previous_count3=0;start_from3=0;end_at3=0;

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

y=0;
previous_count3=0;
start_from3=0;
end_at3=0;

%to compute the distance and angles for all motion vectors of one cell and
%write them as one entity
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

count_of_cell=0;previous_count4=0;start_from4=0;end_at4=0;
initial_theta=0;xx=0;initial_mag=0;final_magnitude=0;final_theta=0;
matrix_video2=zeros(10000,3);index_matrix_video2=1;cell_value=0;
new_matrix_video1_HOMV=zeros(10000,5);index_new_matrix_video1_HOMV=1;
initial_theta_m=0; multiply_mag_theta=0;sum_1=0;sum_2=0;sum_3=0;sum_4=0;
 previous_count4=0; start_from4=0; end_at4=0;
 
%writing all magnitude together for each cell in new matrix
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
rr=size(new_matrix_video1_HOMV,2);
rows_count_of_homv1=size(new_matrix_video1_HOMV,1);
summ=0;a=0;

% writing in bin matrix
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

count_of_cell=0;
previous_count4=0;
start_from4=0;
end_at4=0;

initial_theta=0;xx=0;initial_mag=0;final_magnitude=0;final_theta=0;
matrix_video2=zeros(10000,3);index_matrix_video2=1;cell_value=0;
new_matrix_video2_HOMV=zeros(10000,5);index_new_matrix_video2_HOMV=1;
initial_theta_m=0; multiply_mag_theta=0;sum_1=0;sum_2=0;sum_3=0;sum_4=0;
previous_count4=0; start_from4=0; end_at4=0;
 
%writing all magnitude otgether for each cell in new matrix
for u=1:size(video2_cell_count_list)
    count_of_cell=video2_cell_count_list(u,1);
    %fprintf('count of cell %d\n',count_of_cell);
   % fprintf('previous: %d\n',previous_count4);
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
    end

new_matrix_video2_HOMV= new_matrix_video2_HOMV( [1:index_new_matrix_video2_HOMV-1], : );

rr=size(new_matrix_video2_HOMV,2);rows_count_of_homv2=size(new_matrix_video2_HOMV,1);
summ=0;a=0;

%normalising the matrices row-wise
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

i_new=0; j_new=0; dist_new=0; c_new=0;
mag1_1=0; mag1_2=0;mag2_1=0;mag2_2=0;
mag3_1=0;mag3_2=0;mag4_1=0;mag4_2=0;
 
nframes1 = videoVector1(size(videoVector1,1), 1); 
nframes2 = videoVector2(size(videoVector2,1), 1);
nframes1=nframes1-1;
nframes2=nframes2-1;

rows=size(new_matrix_video1,1);
r=new_matrix_video1(rows,1);
final_matrix=zeros(nframes1,nframes2);

%final matrix construction
for i_new=0:nframes1
    for j_new=0:nframes2
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
            dot=abs((mag1_1-mag1_2)+(mag2_1-mag2_2)+(mag3_1-mag3_2)+(mag4_1-mag4_2));
         end
            final_matrix(i_new+1,j_new+1)=dot/r;
     end
end

final_distance =dynamicAllign(final_matrix)