function videoExtractor(result,C,videoPath)

for vi=1:size(result,1)
    k=C{result(vi,1)};
    v=VideoReader(strcat(videoPath,k));
    m=result(vi,2);
    n=result(vi,3);
    % Number Of frames calculation
    numberOfFrames=get(v,'NumberOfFrames');
    %disp(['the video has ',num2str(numberOfFrames),' frames']);

    if(m>0 && m<=n && m<=numberOfFrames && n<=numberOfFrames)
        newFile = VideoWriter(strcat('Videos\',strcat(k,'_',num2str(vi))));
        open(newFile);
        for frameIndex=m:n
                keyFrameVideo = im2frame(read(v, frameIndex));
                writeVideo(newFile, keyFrameVideo);
        end
        close(newFile);
    else
        disp('Invalid value of m or n');
    end
end