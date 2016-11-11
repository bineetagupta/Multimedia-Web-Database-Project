function motDist=Task1_motion_similarity(dbName,file1,file2,distanceMeasure)
    motDist=0;    
    if(strcmp(distanceMeasure,'HOMV_Manhattan'))
        motDist=HOMV_Manhattan(dbName,file1,file2);
        %siftDist
    elseif (strcmp(distanceMeasure,'HOMV_Intersection'))
        motDist=HOMV_Intersection(dbName,file1,file2);
        %siftDist
    elseif (strcmp(distanceMeasure,'PCA_Euclidean'))
        motDist=Motion_PCA_Euclidean(dbName,file1,file2);
    elseif (strcmp(distanceMeasure,'PCA_Manhattan'))
        motDist=Motion_PCA_Manhattan(dbName,file1,file2);
    else
        fprintf('Enter the correct distance method');
    end