Video Sub-sequence Search Using Diverse Similarity Measures In The Original Space And The Reduced Dimensionality

         Anurag Arora, Bineeta Gupta, Kyungyong Han, Neha Prasad, Nishant Jagadeesan, Ujjwal Dasu
                        aarora40, bkgupta, hkyungyo, nhprasad, njagade1, udasu@asu.edu

This is a MATLAB/C++ implementation of video vub-sequence search using diverse similarity measures in the original space and the reduced dimensionality

[1] Task 1
COMPLING AND EXECUTION
For Histogram Similarity from MATLAB prompt
  > Open the file 'Task1_histogram_similarity.m' in matlab.
  > From MATLAB prompt input Task1_histogram_similarity(dbName, file1, file2, distanceMeasure) in console.

Input to the program:
> dbName - It is the path to the .csv database of all videos histogram values.
> file1 - It is the first video file name whose histogram values need to be extracted from the db.
> file2 - It is the second video file name whose histogram values need to be extracted from the db.
> distanceMeasure - The distanceMeasure is  either 'Intersection' for  intersection  similarity  or 'ChiSquared' for chi square similarity. If any other similarity method is entered. The program would ask you to enter an appropriate distance measure.

Output: The output would be a value of total histogram similarity/difference for the two videos.

For SIFT Similarity from MATLAB prompt
  > Open the file 'Task1_sift_similarity.m' in matlab.
  > From MATLAB prompt input Task1_sift_similarity(dbName, file1, file2, distanceMeasure) in console.

Input to the program:
> dbName - It is the path to the .csv database of all videos histogram values.
> file1 - It is the first video file name whose sift descriptor values need to be extracted from the db.
> file2 - It is the second video file name whose sift descriptor values need to be extracted from the db.
> distanceMeasure - The distanceMeasure is either 'Hausdorff' for Hausdorff distance or 'SquaredEuclidean' for squared Euclidean Distance. If any other similarity method is entered. The program would ask you to enter an appropriate

Output: The output would be a value of total SIFT similarity/difference for the two videos.

For Motion Similarity from MATLAB prompt
  > Open the file 'Task1_motion_similarity.m' in matlab.
  > From MATLAB prompt input Task1_motion_similarity(dbName, file1, file2, distanceMeasure) in console.

Input to the program:
> dbName - It is the path to the .csv database of all videos histogram values.
> file1 - It is the first video file name whose motion vector values need to be extracted from the db.
> file2 - It is the second video file name whose motion vector values need to be extracted from the db.
> distanceMeasure - The distanceMeasure is either 'HOMV_Manhattan' for  Manhattan  distance  using  HOMV or HOMV_Intersection for Intersection  Similarity  using HOMV.  So the distanceMeansure string should either be 'Hausdorff' or 'SquaredEuclidean'. If any other similarity method is entered. The program would ask you to enter an appropriate distance measure.

Output: The output would be a value of total motion similarity/difference for the two videos.

For Overall Similarity
  > Open the file 'Task1_Overall_Similarity.m' in matlab.
  > From MATLAB prompt input Task1_Overall_Similarity(directoryName, nameOfHistFile, nameOfSiftFile, nameOfMVFile, file1, file2, distanceMeasure, reduced) in console.

Inputs to the program:
> directoryName - The directory name is the path of the common directory path where the input files for histogram, sift and motion vectors exist.
> nameOfHistFile - Its the name of the file which contain histogram values for all videos.
> nameofSiftFile - Its the name of the file which contain sift vector data for all videos.
> nameOfMVFile - Its the name of the file which contain motion vector data for all videos.
> file1 - Its the name of the first file to be compared whose data has to be extracted from the earlier provided histogram, sift and motion vector databases / files.
> file2 - Its the name of the second file to be compared whose data has to be extracted from the ealier provided histogram, sift and motion vector databases.
> distanceMeasure - distanceMeasure is the distance combination to be used for sift, histogram and motion vector respectively. eg - Haus_Chi_HI means distance measure 'hausdorff' being used for sift, 'chisquared' being used for hisogram and 'HOMV intersection' is being used for motion vectors.
> reduced - reduced is a flag variable which helps in differentiating between whether the simarity measured has to be put on original dimensions or reduced dimensions.

The output is a value calculated by a linear combination of all similarity measures(SIFT, Histogram and motion vector), and it will be received by console.

ABOUT THE SOURCE CODE
  We use the follwing convention to name files:
  *.m                         :      M files
  histogram_similarity.m      :      Service scripts
  sift_similarity.m           :      Service scripts 
  motion_similarity.m         :      Service scripts 
  Overall_Similarity.m        :      Service scripts 


[2] Task 2
COMPLING AND EXECUTION

  > Open the file 'Task2_Overall.m ' in matlab.
  > From MATLAB prompt input Task2_Overall(directoryName,nameOfHistFile, nameOfSiftFile, nameOfMVFile,file1,a,b,knn,distanceMeasure,reduced,videoPath) in console.

Inputs to the program:
> directoryName - The directory name is the path of the common directory path where the input files for histogram, sift and motion vectors exist.
> nameOfHistFile - Name of the file which contain histogram values for all videos.
> nameofSiftFile - Name of the file which contain sift vector data for all videos.
> nameOfMVFile - Name of the file which contain motion vector data for all videos.
> file1 - Its the name of the file whose subsequence has to be computed from the earlier provided histogram, sift and motion vector databases / files.
> a - a is the start of the frame range.
> b - b is the end of the frame range.
> knn - It is the number of top k most similar frame sequences that have to be computed and it would be the number of output files that would be generated.
> distanceMeasure - distanceMeasure is the distance combination to be used for sift, histogram and motion vector respectively. distanceMeasure should be one of the following strings.
> reduced - reduced is a flag which would define if the computation has to be made on original dimensions or reduced dimensions.
> videoPath - Path to output directory where the subsequence files would be generated.

The output is a video which have top knn(number) of sub-sequence frames. The format of video is `avi'.


ABOUT THE SOURCE CODE
  We use the follwing convention to name files:
  *.m                  :      M files
  Task2_Overall.m      :      Service scripts



[3] Task 3
COMPLING AND EXECUTION

For PCA
  > Open ``Task3_Kmeans.m" in matlab.
  > From MATLAB prompt input "Task3_PCA" to execute application.
  > Select input files from phase 1 by using UI.
  > Input reduced dimensionality you want of each file.
  > Select directory to store output files by using UI.
  > If a file remains, go to step 3
  
For K-means
  > Open ``Task3_Kmeans.m" in matlab.
  > From MATLAB prompt input "Task3_Kmeans" to execute application.
  > Select input files from phase 1 by using UI.
  > Input reduced dimensionality you want of each file.
  > Select directory to store output files by using UI.
  > If a file remains, go to step 3

ABOUT THE SOURCE CODE
  We use the follwing convention to name files:
  *.m              :      M files
  Task3_PCA.m      :      Service scripts
  Task3_Kmeans.m   :      Service scripts 
  
[4] Task 4
COMPLING AND EXECUTION

  > Open the file 'Task2_Overall.m ' in matlab.
  > From MATLAB prompt input Task2_Overall(directoryName,nameOfHistFile, nameOfSiftFile, nameOfMVFile,file1,a,b,knn,distanceMeasure,reduced,videoPath) in console.

Inputs to the program:
> directoryName - The directory name is the path of the common directory path where the input files for histogram, sift and motion vectors exist.
> nameOfHistFile - Name of the file which contain histogram values for all videos.
> nameofSiftFile - Name of the file which contain sift vector data for all videos.
> nameOfMVFile - Name of the file which contain motion vector data for all videos.
> file1 - Its the name of the file whose subsequence has to be computed from the earlier provided histogram, sift and motion vector databases / files.
> a - a is the start of the frame range.
> b - b is the end of the frame range.
> knn - It is the number of top k most similar frame sequences that have to be computed and it would be the number of output files that would be generated.
> distanceMeasure - distanceMeasure is the distance combination to be used for sift, histogram and motion vector respectively. distanceMeasure should be one of the following strings.
> reduced - reduced is a flag which would define if the computation has to be made on original dimensions or reduced dimensions.
> videoPath - Path to output directory where the subsequence files would be generated.

The output is a video which have top knn(number) of sub-sequence frames. The format of video is `avi'.

The input and output are exactly same as Task 2 except that Task 4 uses vectors in the reduced dimensional space as input instead of vectors in the original dimensional space.

ABOUT THE SOURCE CODE
  We use the follwing convention to name files:
  *.m                  :      M files
  Task2_Overall.m      :      Service scripts
