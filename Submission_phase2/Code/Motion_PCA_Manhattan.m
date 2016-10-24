function final_distance = Motion_PCA_Manhattan(fileName,file1,file2)

delimiter=',';
hist=importdata(fileName,delimiter);
histMaxRow=size(hist.data,1);

%Extract file1
ind1= find(strcmp(hist.textdata(:,1),file1));
videoVector1=hist.data(ind1,:);

%Extract file2
ind2=find(strcmp(hist.textdata(:,1),file2));
videoVector2=hist.data(ind2,:);

nframes1 = videoVector1(size(videoVector1,1), 1); 
nframes2 = videoVector2(size(videoVector2,1), 1);

n=size(videoVector1,2)-2;
start_point=0;end_point=start_point;initial=2;loop_count= size(videoVector1,1);
i=1;index_of_list=1;sum =0;global_count_video1=0;list_of_video1=zeros(loop_count,1);

%calculate the start and end index of frame
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

start_point=0;end_point=start_point;initial=2;loop_count= size(videoVector2,1);
i=1;index_of_list=1;sum =0;list_of_video2=zeros(loop_count,1);

%calculate the start and end index of frame
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

ff=list_of_video2(index_of_list-1,1);list_of_video2(index_of_list-1,1)=ff+1;
list_of_video2 = list_of_video2( [1:index_of_list], : );
size_of_list1=size(list_of_video1,1);size_of_list2=size(list_of_video2,1);
new_matrix_video1=zeros(9500,size(videoVector2,2));
global_count=1;previous_count=0;start_from=0;end_at=0;j=0;i=0;

%sort the matrix and write in a new matrix
new_matrix_video1=sortrows(videoVector1,[1,2]);
new_matrix_video1=new_matrix_video1(:,2:size(new_matrix_video1,2));

global_count=size(new_matrix_video1,1);video2_cell_count_list=zeros(global_count,1);
video1_cell_count_list=zeros(global_count,1);index_video1_cell_count_list=1;
ii=1;sum=0;

% calculate the starting and ending index of one cell in each frame
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

global_count=1;size_of_list2=size(list_of_video2,1);new_matrix_video2=zeros(9500,11);
previous_count=0;start_from=0;end_at=0;

%normalise
new_matrix_video2=sortrows(videoVector2,[1,2]);
new_matrix_video2=new_matrix_video2(:,2:size(new_matrix_video2,2));

global_count=size(new_matrix_video2,1);video2_cell_count_list=zeros(global_count,1);
video2_cell_count_list=zeros(global_count,1);index_video2_cell_count_list=1;
ii=1;sum=0;

% calculate the starting and ending index of one cell in each frame. 
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

%remove extra rows and columns
video2_cell_count_list= video2_cell_count_list( [1:index_video2_cell_count_list], : );

y=0;previous_count3=0;start_from3=0;end_at3=0;index_new_x=1;new_x=zeros(10000,n);
temp=zeros(1,n);i=2; vector=zeros(1,n+1);new_vector_1=zeros(10000,n+1);index_new_vector_1=1;

% calculate together all motion vectors of a cell
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
         vector=vector+new_matrix_video1(x,:);
    end   
    new_vector_1(index_new_vector_1,:)=vector;
    new_vector_1(index_new_vector_1,1)=new_matrix_video1(x,1);
    index_new_vector_1=index_new_vector_1+1;
end

%remove extra rows and columns
new_vector_1= new_vector_1( [1:index_new_vector_1-1], : );

rows=size(new_vector_1,1);
r=new_vector_1(rows,1);

y=0;previous_count3=0;start_from3=0;end_at3=0;index_new_x=1;new_x=zeros(10000,n);
temp=zeros(1,n);i=2; vector=zeros(1,n+1);new_vector_2=zeros(10000,n+1);index_new_vector_2=1;

% addition of all motion vectors of a cell
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
         vector=vector+new_matrix_video2(x,:);
    end   
    new_vector_2(index_new_vector_2,:)=vector;
    new_vector_2(index_new_vector_2,1)=new_matrix_video2(x,1);
    index_new_vector_2=index_new_vector_2+1;
end

%size of constructed matrices
s2=size(new_vector_2,2);
new_vector_2_norm=normr(new_vector_2(:,2:s2));
s1=size(new_vector_1,2);
new_vector_1_norm=normr(new_vector_1(:,2:s1));

nframes1 = videoVector1(size(videoVector1,1), 1); 
nframes2 = videoVector2(size(videoVector2,1), 1);
nframes1=nframes1-1;
nframes2=nframes2-1;

s1=size(new_vector_1,2);g=2;c=(r*r);
final_matrix=zeros(nframes1,nframes2);

%final matrix construction
for i_new=0:(nframes1-1)
    for j_new=0:(nframes2-1)
        dot=0;
        for c_new=1:r
          dot=dot+pdist2(new_vector_1_norm(r*(i_new)+c_new,:),new_vector_2_norm(r*(j_new)+c_new,:),'hamming');

         end
            final_matrix(i_new+1,j_new+1)=dot/r;
     end
end

final_distance =dynamicAllign(final_matrix)