function Task1(r,n,dir_path)
%r=4;
%n=10;
%dir_path='C:\Users\Neha\GoogleDrive\ASU\CSE515\Projects\Phase1\DataR\Test\';
outfile=strcat(dir_path, 'out_file1.csv');
fid=fopen(outfile, 'w');
files=dir(dir_path);

% Print the metadata header in the output CSV file
fprintf(fid, 'Video,Frame#,Cell#,Histogram');
% For each file in the input 'dir_path' directory, read the videos in it
for i=1:length(files)
    filename=files(i).name;
    %disp(filename);
    
    % Only process mp4 files - that is the expected input file format
    % handled here
    [~,~,ext]=fileparts(filename);
    if strcmp(ext, '.mp4') 
        full_filename=strcat(dir_path, '\', filename);
        j=1;
        % Extract the video information 
        v=VideoReader(full_filename);
        % Process each frame
        while hasFrame(v)
            f=readFrame(v);
            % convert to grayscale
            gray_f=rgb2gray(f);
            % get the height and width of the frame
            [height, width]=size(gray_f); 
            h_rem=rem(height,r);
            w_rem=rem(width,r);
            % Divide the frame into r x r cells. If the frame dimensions 
            % are not exact multiples of r, add the remainder of the 
            % division to the last row/column
            if ~(h_rem==0 && w_rem==0)
                height=height-h_rem;
                width=width-w_rem;
            end
            nc=width/r;
            nr=height/r;
            rows=nr*ones(1,r);
            rows(r)=rows(r)+h_rem;
            cols=nc*ones(1,r);
            cols(r)=cols(r)+w_rem;
            c = mat2cell(gray_f, rows, cols);
            
            % For each cell(row,col), calculate the n-bin color histogram
            % and output it to the output CSV file
            l=1;
            for row=1:r
                for col=1:r
                    hist=imhist(c{row,col},n);
                    %disp(filename);
                    %disp([i j l]); 
                    %disp(hist);
                    hist_str='';
                    for k=1:n
                        hist_str=strcat(hist_str,num2str(hist(k)),'#');
                    end
                    %disp(hist_str);
                    fprintf(fid, '\n%s,%d,%d,%s', filename, j, l, hist_str);
                    l=l+1;
                end
            end
            j=j+1;
        end
    end
end