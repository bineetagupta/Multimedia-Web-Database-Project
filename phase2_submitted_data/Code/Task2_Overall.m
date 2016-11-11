function [result,C]=Task2_Overall(directoryName,nameOfHistFile, nameOfSiftFile, nameOfMVFile,file1,a,b,knn,distanceMeasure,reduced,videoPath)

result=zeros(1,4);
C={};
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

if reduced==0
    if(strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_ONE))
        [MultiArray1,C]=Task2SIFTOverall(pathtoSiftFile,file1,a,b,knn);
        [MultiArray2,C]=Task2_histogram_similarityOverall(pathtoHistFile,file1,a,b,knn,DISTANCE_CHI_SQUARED);
        [MultiArray3,C]=Task2_HOMV_Intersection_Overall(pathtoMVFile,file1,a,b,knn);
        MultiArray2(:,2)=MultiArray2(:,2)+1;
        result=allignOverall(MultiArray1,MultiArray2,C);
        result=allignOverall(result,MultiArray3,C);
        result=sortrows(result,4);
        result=result(1:knn,:);
        
        videoExtractor(result,C,videoPath);
        
        
    elseif (strcmp(distanceMeasure,DISTANCE_COMBINATION_ORIGINAL_TWO))
        [MultiArray1,C]=Task2SIFTOverallEuclidean(pathtoSiftFile,file1,a,b,knn);
        [MultiArray2,C]=Task2_histogram_similarityOverall(pathtoHistFile,file1,a,b,knn,DISTANCE_INTERSECTION);
        [MultiArray3,C]=Task2_HOMV_Manhattan_Overall(pathtoMVFile,file1,a,b,knn);
        MultiArray2(:,2)=MultiArray2(:,2)+1;
        result=allignOverall(MultiArray1,MultiArray2,C);
        result=allignOverall(result,MultiArray3,C);
        result=sortrows(result,4);
        result=result(1:knn,:);
        videoExtractor(result,C,videoPath);
    end
    
else
    if (strcmp(distanceMeasure,DISTANCE_COMBINATION_REDUCED_ONE))
        [MultiArray1,C]=Task2SIFTOverallEuclidean(pathtoSiftFile,file1,a,b,knn);
        [MultiArray2,C]=Task2_histogram_similarityOverall(pathtoHistFile,file1,a,b,knn,DISTANCE_INTERSECTION);
        [MultiArray3,C]=Task2_Motion_PCA_Euclidean_Overall(pathtoMVFile,file1,a,b,knn);
        MultiArray2(:,2)=MultiArray2(:,2)+1;
        result=allignOverall(MultiArray1,MultiArray2,C);
        result=allignOverall(result,MultiArray3,C);
        result=sortrows(result,4);
        result=result(1:knn,:);
        videoExtractor(result,C,videoPath);
        
    elseif (strcmp(distanceMeasure,DISTANCE_COMBINATION_REDUCED_TWO))
        [MultiArray1,C]=Task2SIFTOverallEuclidean(pathtoSiftFile,file1,a,b,knn);
        [MultiArray2,C]=Task2_histogram_similarityOverall(pathtoHistFile,file1,a,b,knn,DISTANCE_INTERSECTION);
        [MultiArray3,C]=Task2_HOMV_Manhattan_Overall(pathtoMVFile,file1,a,b,knn);
        MultiArray2(:,2)=MultiArray2(:,2)+1;    
        result=allignOverall(MultiArray1,MultiArray2,C);
        result=allignOverall(result,MultiArray3,C);
        result=sortrows(result,4);
        result=result(1:knn,:);
        videoExtractor(result,C,videoPath);
    end
    
    
end


