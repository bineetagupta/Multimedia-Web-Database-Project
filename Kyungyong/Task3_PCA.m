close all;
clear all;
clc;

[fileName, pathName] = uigetfile({'*.*';'*.xls';'*.csv'},'Select files', 'MultiSelect', 'on');

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

for k = 1:length
    
    if(iscell(fileName))
       [data,txt] = xlsread(fullfile(pathName, fileName{k}));
    else
       [data,txt] = xlsread(fullfile(pathName, fileName));
    end
    
    txt(1,:)=[];
    video_names = txt(:,1);
    objects = data(:,[1,2,3]);
    data(:,[1,2,3])=[];
    
    size_of_data = size(data);
    dimensionlaity_of_data = size_of_data(1,2);
    the_number_of_column_of_data = size_of_data(1,1);
    
    if(iscell(fileName))
       prompt = strcat('input dimensionality of \', fileName{k}, ' :');
    else
       prompt = strcat('input dimensionality of \', fileName, ' :');
    end
   

    dimensionality = input(prompt);
    
    while(true)
        if(dimensionality > 0 || dimensionality <= dimensionlaity_of_data )
            break;
        else
            dimensionality = input('input dimemsionality again(you input wrong value) :');
        end
    end
    
    [coeff, score, latent] = pca(data);
    
    new_score = mat2cell(score, the_number_of_column_of_data,[dimensionality dimensionlaity_of_data-dimensionality]);
    new_score = cell2mat(new_score(1,1));

    output_path = uigetdir('select the directory to store an output file');
    
    if(iscell(fileName))
       str = char(fileName{k});
    else
       str = char(fileName);
    end

    output_name = strcat('out_file_', num2str(dimensionality), '_', str(1,8), 'pca.csv');
    
    output = fullfile(output_path, output_name);
    fid=fopen(output, 'wb');    
    fprintf(fid, '%s', 'video number, frame number, cell number of x, cell number of y');
    for i = 1:dimensionality
        fprintf(fid, ',%s%d', 'PC', i);
    end
    fprintf(fid, '\n');

    for i = 1:the_number_of_column_of_data
        fprintf(fid, '%s', video_names{i,1});
        fprintf(fid, ',%d', objects(i,1));
        fprintf(fid, ',%d', objects(i,2));
        fprintf(fid, ',%d', objects(i,3));
        for j = 1:dimensionality
            fprintf(fid, ',%f', new_score(i,j));
        end
        
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
    X = bsxfun(@minus, data, mean(data,1));            
    covariancex = (X'*X)./(size(X,1)-1);                 
    [V, D] = eigs(covariancex, dimensionality);
    [nrows,ncols] = size(V);
    
    output_name = strcat('out_file_score_', num2str(dimensionality), '_', str(1,8), 'pca.csv');
    output = fullfile(output_path, output_name);
    
    fid=fopen(output, 'wb'); 
    
    for row = 1:nrows
        for col = 1:ncols
            fprintf(fid, '%d,', V(row,col));
        end
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
end
