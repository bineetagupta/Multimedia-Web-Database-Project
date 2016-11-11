function histDist=Task1_histogram_similarity(dbName,file1,file2,distanceMeasure)

% dbName='C:\Users\SunnC:\Users\kyungyong\Desktop\Final_Ujjwal\Code\Inputy\OneDrive\ASU\Fall_2016\MWDB\Phase2Final\Final_Ujjwal\Histogram.csv';
% file1='1R.mp4';
% file2='square_L_R_texture.mp4';
% distanceMeasure='Intersection';

histDist=0;
    delimiter=',';
    hist=importdata(dbName,delimiter);
    n=num2str(hist.data(size(hist.data,2),2)-2);

    r=num2str(sqrt(hist.data(size(hist.data,1),2)));
    C = unique(hist.textdata);
    f1=num2str(find(strcmp(C, file1)));
    f2=num2str(find(strcmp(C, file2)));
    
    if (strcmp(distanceMeasure,'Intersection'))
        executable=strcat(['task1_intersect.exe ',dbName,' ',f1,' ',f2,' ',r,' ',n]);
        d=system(executable);
        
        histDist=importdata('outfile_intermed');
    elseif (strcmp(distanceMeasure,'ChiSquared'))
        
        executable=strcat(['task1_chi_square.exe ',dbName,' ',f1,' ',f2,' ',r,' ',n]);
        d=system(executable);
        
        histDist=importdata('outfile_intermed');
    else
        fprintf('Enter the correct distance method');
    end
    
    
   