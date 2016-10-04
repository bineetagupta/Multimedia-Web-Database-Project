close all;
clear all;
clc;

[fileName, pathName] = uigetfile({'*.*';'*.xls';'*.csv'},'Select files', 'MultiSelect', 'on');

for k = 1:length(fileName)
    
    [data,txt] = xlsread(fullfile(pathName, fileName{k}));
    
    txt(1,:)=[];
    new_data = data(:,[1,2,3]);
    data(:,[1,2,3])=[];
    
    prompt = strcat('input dimensionality of \', fileName{k}, ' :');
    dimensionality = input(prompt);
    
    size_of_new_data = size(data);
    dimensionlaity_of_new_data = size_of_new_data(1,2);
    number_of_column_of_new_data = size_of_new_data(1,1);
    
    while(true)
        if(dimensionality > 0 || dimensionality <= dimensionlaity_of_new_data )
            break;
        else
            dimensionality = input('input dimemsionality again(you input wrong value) :');
        end
    end
    
    [idx,C,sumd,D] = kmeans(data, dimensionality);
    
    new_txt = txt(:,1);

    output_path = uigetdir('select the directory to store an output file');
    
    str = char(fileName{k});
    output_name = strcat('out_file_', num2str(dimensionality), '_', str(1,8), 'km.csv');
    
    output = fullfile(output_path, output_name);
    fid=fopen(output, 'wb');    
    
    for i = 1:number_of_column_of_new_data
        fprintf(fid, '%s', new_txt{i,1});
        fprintf(fid, ',%d', new_data(i,1));
        fprintf(fid, ',%d', new_data(i,2));
        fprintf(fid, ',%d', new_data(i,3));
        for j = 1:dimensionality
            fprintf(fid, ',%f', D(i,j));
        end
        
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
end
