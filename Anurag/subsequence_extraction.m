videoPath=input('Enter the path to the video: ','s');
v=VideoReader(videoPath);

% Number Of frames calculation
numberOfFrames=(floor(v.duration*floor(v.framerate)));
disp(['the video has ',num2str(numberOfFrames),' frames']);

m=input('Enter the starting point in your range: ');
n=input('Enter the ending point in your range: ');

if(m>0 && m<n && m<numberOfFrames && n<numberOfFrames)
    newFile = VideoWriter('newVideoFile');
    open(newFile);
    for frameIndex=1:(numberOfFrames)
        if (frameIndex>=m && frameIndex<=n)
            keyFrameVideo = im2frame(read(v, frameIndex));
            writeVideo(newFile, keyFrameVideo);
        end
    end
    close(newFile);
else
    disp('Invalid value of m or n');
end