close all
clearvars

%% Setup paths

script_path=fileparts(mfilename('fullpath'));
cd(script_path);

root_path = fileparts(fileparts(script_path));
par_path = fullfile(root_path,'inputparameters.xlsx');

%% Setup options
query = 0;
overlaydata=true;
savefigure=true;

%% Execute comparison from list of models

if query == 0

    all_comparison_list=readtable('comparison.list', 'FileType', 'text', 'Delimiter', ',');

    comparison_list=unique(all_comparison_list.group);

    disp(comparison_list)

    % choose one from the comparison_list

    compare=all_comparison_list((all_comparison_list.group == "final models shiva bg"),:);


    %% Execute comparison from query

elseif query == 1
    close all
    clear qc compare

    % build query qc
    qc.material=["mcf","bg"];
    qc.machine=["brava","shiva"];
    % qc.xi=[0.66];
    % qc.alpha=[0,0.3];
    % qc.epsilon=[0,1.7e-4];
    % qc.crpinj_modtype=["simple","complex"];
    % qc.beta_1_Pa_=[1.0800E-06];
    % qc.model_type=["2a"];

    % get list of experiments using the query qc

    compare=query_table_dynamically(par_path,qc); compare=compare';

    % encode qc into a descriptive string

    % Specify which fields to include (optional)
    fields_to_include = {'material', 'machine', 'alpha', 'epsilon', 'model_type'};

    % Initialize an empty cell array to hold the parts of the string
    strings = {};

    % Loop over all fields in qc
    all_fields = fieldnames(qc);
    for i = 1:numel(all_fields)
        field_name = all_fields{i};

        % If you're filtering to include only specific fields
        if ~isempty(fields_to_include) && ~ismember(field_name, fields_to_include)
            continue;  % Skip this field if not in the inclusion list
        end

        % Get the value of the field
        field_value = qc.(field_name);

        % Handle different data types
        if ischar(field_value) || isstring(field_value)
            % If it's a string or char, combine field name and value
            strings{end+1} = strcat(field_name, '_', char(strjoin(cellstr(string(field_value)), '_')));

        elseif isnumeric(field_value)
            % If it's a numeric array, join its elements with '_', and add field name
            strings{end+1} = strcat(field_name, '_', char(strjoin(string(field_value), '_')));

        elseif iscell(field_value)
            % If it's a cell array, join its contents (assuming strings) with '_', and add field name
            strings{end+1} = strcat(field_name, '_', char(strjoin(string(field_value), '_')));

        else
            % If it's another type, you can define how to handle it or skip
            warning('Unrecognized field type for %s. Skipping.', field_name);
            continue;
        end
    end

    % Ensure the strings are converted to character vectors for strjoin
    comparison = strjoin(strings, '-');

    % Display the final comparison string
    disp(comparison);

end

%% Load and plot models
for i=1:size(compare,1)

    name=string(compare{i,1});
    % disp(name)

    parameters=get_parameters(name);
    parameters.lw=1;

    % try to load and plot a matlab models

    try
        disp(strcat("load model: ",strcat(name,'model.mat')))
        globaloutput=load(fullfile(root_path,"results",strcat(name,'model.mat')));
        globaloutput=globaloutput.globaloutput;

        plotter(globaloutput,parameters);
        hold on

        comparison_plotter(globaloutput,parameters);
        hold on

    catch ME
        disp(ME.message)
    end

    % try to load and plot a .csv (Julia model)

    try
        parameters.lw=2;

        juliamodel=importdata(fullfile(root_path,"results",strcat(name,'rt.csv')));

        juliamodel=juliamodel.data;

        plotter(juliamodel,parameters)
        hold on
        comparison_plotter(juliamodel,parameters)
        hold on

    catch ME
        disp(ME.message)

    end
end

%% Save one comparison figure

fig=figure(3); %why this was figure(3)?
fig.Units = 'normalized';
fig.OuterPosition=[0 0 1 1];

for i=1:size(fig.Children,1)
    if fig.Children(i).Type == "axes"
        gca=fig.Children(i);
        gca.FontSize=20;
        gca.FontName='Arial';

        % for l=1:size(gca.Children,1)
        %     gca.Children(l).LineStyle='-';
        %     gca.Children(l).LineWidth=2;
        % end
    end
end

yyaxis left
colororder("sail")
gca.YColor='k';
yllims=gca.YLim;
xlims=gca.XLim;

yyaxis right
gca.YColor='k';
delete(gca.Children(2:end))
gca.Children(1).LineStyle='-';
gca.Children(1).LineWidth=2;
gca.Children(1).Color='k';
gca.Children(1).DisplayName='Pf';
gca.Children(1).Marker="none";
yrlims=gca.YLim;

title(comparison,'Interpreter','none')

legend(Location="north",FontSize=14)

%% Overlay corresponding data
data=char(parameters.data);

if true(overlaydata)
    switch data
        case 'brava'
            dataoverlayer(fullfile(root_path,"..","..","data","jupyter",data),711,parameters) %906.1??
        case 's1949'
            dataoverlayer(fullfile(root_path,"..","..","data","jupyter",data),711,parameters)
        case 's1997'
            dataoverlayer(fullfile(root_path,"..","..","data","jupyter",data),4446.7,parameters)
    end
end

yyaxis left
ylim([yllims(1),12])
xlim(xlims)
yyaxis right
ylim(yrlims)

%% Save the figure

fig.Renderer="painters";

if true(savefigure)
    if true(overlaydata)

        savefig(fig,fullfile(root_path,"comparetodata","plots",strcat(comparison,'_.fig')))
        saveas(fig,fullfile(root_path,"comparetodata","plots",strcat(comparison,'.svg')))
        saveas(fig,fullfile(root_path,"comparetodata","plots",strcat(comparison,'.png')))

    else
        savefig(fig,fullfile(root_path,"comparisons","plots",strcat(comparison,'_.fig')))
        saveas(fig,fullfile(root_path,"comparisons","plots",strcat(comparison,'.svg')))
        saveas(fig,fullfile(root_path,"comparisons","plots",strcat(comparison,'.png')))

    end
end

