close all
clearvars
% close all

%% Setup paths
script_path=fileparts(mfilename('fullpath'));
cd(script_path);

root_path = fileparts(fileparts(script_path));
par_path = fullfile(root_path,'inputparameters.xlsx');

benchmark_path=fullfile(root_path,"benchmark");

%% Import list of benchmark experiments

benchmark_list=readtable('benchmark.list', 'FileType', 'text', 'Delimiter', ',');

%% Loop across list, import and plot data
for j=1:size(benchmark_list,1)
    if string(benchmark_list{j,3}) == "true"

        close all
        name=char(benchmark_list{j,1});
        name2=char(benchmark_list{j,2});

        parameters=get_parameters(name);
        parameters.lw=1;

        shift=100; %before: 100

        disp("Import and plot JR models")

        if contains (name2,'arbonate')
            jr=JRcarb2mat(fullfile(benchmark_path,name2));
            jr(:,1)=jr(:,1)+parameters.TstartCreep; %fixes time delay
            jr(:,4)=jr(:,4)+shift; %fixes slip delay

        else
            jr=JRshale2mat(fullfile(benchmark_path,name2));
            jr(:,1)=jr(:,1)+shift; %fixes time delay
            jr(:,4)=jr(:,4)+shift; %fixes slip delay

        end

        plotter(jr,parameters);

        % load and plot matlab model
        disp("Import and plot matlab models")

        globaloutput=load(fullfile(benchmark_path,[name,'model.mat']));

        globaloutput=globaloutput.globaloutput;

        plotter(globaloutput,parameters);
        hold on

        % load and plot julia model if available
        juliamodel = false;
        juliamodel2 = false;

        try
            disp("Import and plot julia models")
            juliamodel=importdata(fullfile(benchmark_path,[name,'rt.csv']));

            juliamodel=juliamodel.data;

            plotter(juliamodel,parameters)
            hold on

            juliamodel = true;

        catch ME
            disp(ME.message)
        end

        try
            disp("Import and plot julia models")
            juliamodel=importdata(fullfile(benchmark_path,[name,'.csv']));

            juliamodel=juliamodel.data;

            plotter(juliamodel,parameters)
            hold on

            juliamodel2 = true;

        catch ME
            disp(ME.message)
        end

        %% Edit the summary figure
        sgtitle(name)
        fig=gcf;
        alpha=0.75;

        for i=1:size(fig.Children,1)
            if fig.Children(i).Type == "axes"
                gca=fig.Children(i);
                gca.FontSize=14;
                gca.FontName='Arial';

                if xor(juliamodel,juliamodel2)
                    gca.Children(3).DisplayName='JR23';
                    gca.Children(3).LineStyle='none';
                    gca.Children(3).Marker='o';
                    gca.Children(3).Color='black';

                    gca.Children(2).DisplayName='SA - matlab';
                    gca.Children(2).LineStyle='-';
                    gca.Children(2).LineWidth=2;
                    gca.Children(2).Color='red';
                    gca.Children(2).Color=[gca.Children(2).Color,alpha];

                    gca.Children(1).DisplayName='SA - julia';
                    gca.Children(1).LineStyle='-';
                    gca.Children(1).LineWidth=2;
                    gca.Children(1).Color='cyan';
                    gca.Children(1).Color=[gca.Children(1).Color,alpha];


                elseif (juliamodel==true) && (juliamodel2==true)
                    gca.Children(4).DisplayName='JR23';
                    gca.Children(4).LineStyle='none';
                    gca.Children(4).Marker='o';
                    gca.Children(4).Color='black';

                    gca.Children(3).DisplayName='SA - matlab';
                    gca.Children(3).LineStyle='-';
                    gca.Children(3).LineWidth=2;
                    gca.Children(3).Color='red';
                    gca.Children(3).Color=[gca.Children(3).Color,alpha];

                    gca.Children(2).DisplayName='SA - julia - rt';
                    gca.Children(2).LineStyle='-';
                    gca.Children(2).LineWidth=2;
                    gca.Children(2).Color='cyan';
                    gca.Children(2).Color=[gca.Children(2).Color,alpha];

                    gca.Children(1).DisplayName='SA - julia';
                    gca.Children(1).LineStyle='-';
                    gca.Children(1).LineWidth=2;
                    gca.Children(1).Color='green';
                    gca.Children(1).Color=[gca.Children(1).Color,alpha];

                elseif (juliamodel == false) && (juliamodel2 == false)
                    gca.Children(2).DisplayName='JR23';
                    gca.Children(2).LineStyle='none';
                    gca.Children(2).Marker='o';
                    gca.Children(2).Color='black';

                    gca.Children(1).DisplayName='SA - matlab';
                    gca.Children(1).LineStyle='-';
                    gca.Children(1).LineWidth=2;
                    gca.Children(1).Color='red';
                    gca.Children(1).Color=[gca.Children(1).Color,alpha];
                end
                % uistack(gca.Children(2),"top");
                % uistack(gca.Children(1),"top");

                if or(fig.Children(i).Title.String == "Sliprate",fig.Children(i).Title.String == "Slip")
                    gca.YScale="log";
                end
            end
        end

        fig.Units = 'normalized';
        fig.OuterPosition=[0 0 1 1];

        %% Save the summary figure
        fig.Renderer="painters";

        savefig(fig,fullfile(benchmark_path,"plots",strcat(name,'.fig')))
        saveas(fig,fullfile(benchmark_path,"plots",strcat(name,'.svg')))
        saveas(fig,fullfile(benchmark_path,"plots",strcat(name,'.png')))
    end
end