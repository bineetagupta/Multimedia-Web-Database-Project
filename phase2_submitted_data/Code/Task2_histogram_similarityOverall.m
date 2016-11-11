function [result,C]=Task2_histogram_similarityOverall(dbName,file1,a,b,knn,distanceMeasure)

% dbName='C:\Users\Sunny\OneDrive\ASU\Fall_2016\MWDB\Phase2Final\Final_Ujjwal\Histogram.csv';
% file1='1R.mp4';
% file2='square_L_R_texture.mp4';
% distanceMeasure='Intersection';

    delimiter=',';
    hist=importdata(dbName,delimiter);
    n=num2str(hist.data(size(hist.data,2),2)-2);

    r=num2str(sqrt(hist.data(size(hist.data,1),2)));
    C = unique(hist.textdata);
    f1=num2str(find(strcmp(C, file1)));
    
    a=num2str(a);
    b=num2str(b);
    knnn=knn;
    knn=num2str(knn);
    
    if (strcmp(distanceMeasure,'Intersection'))
        executable=strcat(['task2_intersect_overall.exe ',dbName,' ',f1,' ',a,' ',b,' ',knn,' ',r,' ',n]);
        d=system(executable);
        
        result=importdata('outfile_intermed');

    elseif (strcmp(distanceMeasure,'ChiSquared'))
        
        executable=strcat(['task2_chi_square_overall.exe ',dbName,' ',f1,' ',a,' ',b,' ',knn,' ',r,' ',n]);
        d=system(executable);
        
        result=importdata('outfile_intermed');
    else
        fprintf('Enter the correct distance method');
    end
    
    
   