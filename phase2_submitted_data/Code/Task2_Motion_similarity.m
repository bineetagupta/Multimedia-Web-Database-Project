function [result,C]=Task2_Motion_similarity(fileName,file1,a,b,knn,distanceMeasure,videoPath)

if(strcmp(distanceMeasure,'HOMV_Manhattan'))
    [result,C]=Task2_HOMV_Manhattan(fileName,file1,a,b,knn);
    videoExtractor(result,C,videoPath);
    %siftDist
elseif (strcmp(distanceMeasure,'HOMV_Intersection'))
    [result,C]=Task2_HOMV_Intersection(fileName,file1,a,b,knn);
    videoExtractor(result,C,videoPath);
    %siftDist
    
elseif (strcmp(distanceMeasure,'PCA_Euclidean'))
    [result,C]=Task2_Motion_PCA_Euclidean(fileName,file1,a,b,knn);
    videoExtractor(result,C,videoPath);

elseif (strcmp(distanceMeasure,'PCA_Manhattan'))
    [result,C]=Task2_Motion_PCA_Manhattan(fileName,file1,a,b,knn);
    videoExtractor(result,C,videoPath);
else
    
    fprintf('Enter the correct distance method');
end