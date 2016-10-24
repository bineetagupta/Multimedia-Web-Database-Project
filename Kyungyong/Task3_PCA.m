close all;
clear all;
clc;


%Select input files.
[fileName, pathName] = uigetfile({'*.*';'*.xls';'*.csv'},'Select files', 'MultiSelect', 'on');

% check input the number of input files.
while(true)
    if(iscell(fileName))
        length = length(fileName);
        break;
    elseif(fileName ~= 0)
        length = 1;
        break;
    else
        [fileName, pathName] = uigetfile({'*.*';'*.xls';'*.csv'},'Select files', 'MultiSelect', 'on');
    end
end


%do PCA
for k = 1:length
    if(iscell(fileName))
       current_fileName = fileName{k};
    else
       current_fileName = fileName;
    end

    % parse data part and txt part
    delimiter=',';
    hist=importdata(fullfile(pathName, current_fileName),delimiter);
    
    % parse objects part and vector part
    video_names = hist.textdata(:,1);


    if(strcmp(current_fileName,'output_sift.csv')==1)
        objects = hist.data(:,[1,2,3,4,5,6]);
        hist.data(:,[1,2,3,4,5,6])=[];
    else
        objects = hist.data(:,[1,2]);
        hist.data(:,[1,2])=[];
    end

    
    % extract size of data
    size_of_data = size(hist.data);
    dimensionlaity_of_data = size_of_data(1,2);
    the_number_of_column_of_data = size_of_data(1,1);

    
    % input new dimensionality you want
    prompt = strcat('input dimensionality of \', current_fileName, ' :');
    
    dimensionality = input(prompt);
    
    while(true)
        if(dimensionality > 0 || dimensionality < dimensionlaity_of_data )
            break;
        else
            dimensionality = input('input dimemsionality again(you input wrong value) :');
        end
    end
    
    
    % do pca
    [coeff, score, latent] = pca(hist.data);
    
    % reduce dimensionality
    new_score = mat2cell(score, the_number_of_column_of_data,[dimensionality dimensionlaity_of_data-dimensionality]);
    new_score = cell2mat(new_score(1,1));

    % select output path
    output_path = uigetdir('select the directory to store an output file');

    str = char(current_fileName);


    %create output file
    output_name = strcat('out_file_', num2str(dimensionality), '_', str(1,8), 'pca.csv');
    output = fullfile(output_path, output_name);
    fid=fopen(output, 'wb');    

    % write vectors of reduced dimensionality.
    if(strcmp(current_fileName,'output_sift.csv')==1)
        for i = 1:the_number_of_column_of_data
            fprintf(fid, '%s', video_names{i,1});
            fprintf(fid, ',%d', objects(i,1));
            fprintf(fid, ',%d', objects(i,2));
            fprintf(fid, ',%f', objects(i,3));
            fprintf(fid, ',%f', objects(i,4));
            fprintf(fid, ',%f', objects(i,5));
            fprintf(fid, ',%f', objects(i,6));
            for j = 1:dimensionality
                fprintf(fid, ',%f', new_score(i,j));
            end
            fprintf(fid, '\n');
        end
    else
        for i = 1:the_number_of_column_of_data
            fprintf(fid, '%s', video_names{i,1});
            fprintf(fid, ',%d', objects(i,1));
            fprintf(fid, ',%d', objects(i,2));
            for j = 1:dimensionality
                fprintf(fid, ',%f', new_score(i,j));
            end
            fprintf(fid, '\n');
        end
    end
    fclose(fid);
    
    % create score.
    X = bsxfun(@minus, hist.data, mean(hist.data,1));            
    covariancex = (X'*X)./(size(X,1)-1);                 
    [V, D] = eigs(covariancex, dimensionality);
    [nrows,ncols] = size(V);
    
    % create file to store score
    output_name = strcat('out_file_score_', num2str(dimensionality), '_', str(1,8), 'pca.csv');
    output = fullfile(output_path, output_name);
    
    fid=fopen(output, 'wb'); 
    
    % write score in the file
    for row = 1:nrows
        for col = 1:ncols
            fprintf(fid, '%d,', V(row,col));
        end
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
end
