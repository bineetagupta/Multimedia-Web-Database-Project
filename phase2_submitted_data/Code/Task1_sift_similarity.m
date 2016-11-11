function siftDist=Task1_sift_similarity(dbName,file1,file2,distanceMeasure)
    siftDist=0;    
    if(strcmp(distanceMeasure,'Hausdorff'))
        [siftDist,redCorresDistance]=SIFT_haus(dbName,file1,file2);
        %siftDist
    elseif (strcmp(distanceMeasure,'SquaredEuclidean'))
        [siftDist,redCorresDistance]=Sift_Euc(dbName,file1,file2);
        %siftDist
    else
        fprintf('Enter the correct distance method');
    end