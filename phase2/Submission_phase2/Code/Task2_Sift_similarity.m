function [result,C]=Task2_Sift_similarity(fileName,file1,a,b,knn,distanceMeasure,videoPath)

if(strcmp(distanceMeasure,'Hausdorff'))
    [result,C]=Task2SIFT(fileName,file1,a,b,knn);
    videoExtractor(result,C,videoPath);
    %siftDist
elseif (strcmp(distanceMeasure,'SquaredEuclidean'))
    [result,C]=Task2SIFTEuclidean(fileName,file1,a,b,knn)
    videoExtractor(result,C,videoPath);
    %siftDist
else
    fprintf('Enter the correct distance method');
end