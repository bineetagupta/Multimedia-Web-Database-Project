% This program takes a video as input and extracts key frames from that
% video based on euclidean distance between the frames.
%
% Below is a four (4) step process:
% 1. Calculating consecutive frame differences and storing them in an
% matrix (distanceMatrix).
% 2. Calculating a threshold for the distances to be compared against.
% 3. Marking the frames as key frames (represented by 1) and non key
% frames (represented by 0) in a matrix (frameMatrix).
% 4. Creating a new video from the frames marked as key
% frames (keyFrameVideo).

% Asking user to input values of r and n
n=input('Give a value for n: ');
arrKeyFrameInput=input('Do you want to make an array of Key Frames (computationally expensive) (y/n): ', 's');

videoToLoad='sam_videos/2R.mp4';
v=VideoReader(videoToLoad);

% Number Of frames calculation
numberOfFrames=(floor(v.duration*floor(v.framerate)));

% Creating the distance matrix from the frame sequence of the video
distanceMatrix = ones(numberOfFrames,1);
for frameIndex=1:(numberOfFrames-1)
    frame = rgb2gray(read(v, frameIndex));
    frameNext = rgb2gray(read(v, frameIndex+1));
    
    histFrame1 = imhist(frame,n);
    histFrame2 = imhist(frameNext,n);
    
    d=pdist2(histFrame1',histFrame2');
    distanceMatrix(frameIndex+1, 1)=d;
end

% Taking threshold as mean of distance matrix values
threshold = floor(sum(distanceMatrix)/numberOfFrames);

% Marking key frames with 1 in 2nd column of frameMatrix %
frameMatrix = ones(numberOfFrames, 2);
for frameIndex=2: numberOfFrames
    frameMatrix(frameIndex,1)=distanceMatrix(frameIndex);
    if(distanceMatrix(frameIndex)>threshold)
        frameMatrix(frameIndex,2)=1;
    else
        frameMatrix(frameIndex,2)=0;
    end
end

%Converting key frames to a video which can be created back to a video if
%needed
if(arrKeyFrameInput=='y')
    newFile = VideoWriter('newVideoFile');
    open(newFile);
    for frameIndex=1: numberOfFrames
        if(frameMatrix(frameIndex,2)==1)
            keyFrameVideo = im2frame(read(v, frameIndex));
            writeVideo(newFile, keyFrameVideo);
        end
    end
    close(newFile);
end


