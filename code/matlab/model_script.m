close all
clearvars

%% Setup paths
script_path=fileparts(mfilename('fullpath'));
cd(script_path);

%% Import lists

all_model_list=readtable('model.list', 'FileType', 'text', 'Delimiter', ',','ReadVariableNames', false);
all_model_list.Properties.VariableNames([1, 2]) = {'model', 'group'};

model_list=unique(all_model_list.group);

disp(model_list)

% choose one from the comparison_list

models=all_model_list((all_model_list.group == "all shiva BG bare-rock models"),:);


expnames=models;
savemod='True';

%% Execute model list in for loop

for i=1:size(expnames,1)
    runmodel(string(expnames{i,1}),savemod)
end