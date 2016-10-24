function overAllDist=Task1_Overall_Similarity(directoryName,nameOfHistFile, nameOfSiftFile, nameOfMVFile,file1,file2,distanceMeasure,reduced)
overAllDist=0;

% CONSTANTS (Distance Measures)
DISTANCE_COMBINATION_ORIGINAL_ONE='Haus_Chi_HI';
DISTANCE_COMBINATION_ORIGINAL_TWO='SE_Inter_HM';
DISTANCE_COMBINATION_REDUCED_ONE='SE_Inter_PCAEuc';
DISTANCE_COMBINATION_REDUCED_TWO='Haus_Chi_PCAMan';

DISTANCE_HAUSDORFF='Hausdorff';
DISTANCE_SQUARED_EUCLIDEAN='SquaredEuclidean';
DISTANCE_CHI_SQUARED='ChiSquared';
DISTANCE_HOMV_INTERSECTION='HOMV_Intersection';
DISTANCE_HOMV_MANHATTAN='HOMV_Manhattan';
DISTANCE_INTERSECTION='Intersection';
DISTANCE_PCA_EUCLIDEAN='PCA_Euclidean';
DISTANCE_PCA_MANHATTAN='PCA_Manhattan';

% Concatinating directory path and file name to generate full path
pathtoHistFile=strcat(directoryName, nameOfHistFile);
pathtoSiftFile=strcat(directoryName, nameOfSiftFile);
pathtoMVFile=strcat(directoryName, nameOfMVFile);

% Input sanitation on distanceMeasure string
%distanceSanitation = strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_ONE)||strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_TWO)||strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_TWO)||strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_TWO);
%if(distanceSanitation==1)
    if (reduced==0)
        if(strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_ONE))
           overAllDist=sift_similarity(pathtoSiftFile,file1,file2,DISTANCE_HAUSDORFF)+histogram_similarity(pathtoHistFile,file1,file2,DISTANCE_CHI_SQUARED)+motion_similarity(pathtoMVFile,file1,file2,DISTANCE_HOMV_INTERSECTION);

        elseif(strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_TWO))
            overAllDist=sift_similarity(pathtoSiftFile,file1,file2,DISTANCE_SQUARED_EUCLIDEAN)+histogram_similarity(pathtoHistFile,file1,file2,DISTANCE_INTERSECTION)+motion_similarity(pathtoMVFile,file1,file2,DISTANCE_HOMV_MANHATTAN);
        end
    else
        if(strcmp(distanceMeasure,DISTANCE_COMBINATION_REDUCED_ONE))
            overAllDist=sift_similarity(pathtoSiftFile,file1,file2,DISTANCE_SQUARED_EUCLIDEAN)+histogram_similarity(pathtoHistFile,file1,file2,DISTANCE_INTERSECTION)+motion_similarity(pathtoMVFile,file1,file2,DISTANCE_PCA_EUCLIDEAN);

        elseif(strcmp(distanceMeasure,DISTANCE_COMBINATION_REDUCED_TWO))       
           overAllDist=sift_similarity(pathtoSiftFile,file1,file2,DISTANCE_HAUSDORFF)+histogram_similarity(pathtoHistFile,file1,file2,DISTANCE_CHI_SQUARED)+motion_similarity(pathtoMVFile,file1,file2,DISTANCE_PCA_MANHATTAN);
        end
    end
%else
%    disp 'Please enter a valid distance combination'
%end