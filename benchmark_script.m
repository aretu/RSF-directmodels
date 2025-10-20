close all
clearvars

benchmark_list={
    "shale-08-02-02","Shale08ss_injection_rate_02_alpha_02.dat";...
    "shale-08-10-02","Shale08ss_injection_rate_10_alpha_02.dat";...
    "shale-09-02-02","Shale09ss_injection_rate_02_alpha_02.dat";...
    "shale-09-10-02","Shale09ss_injection_rate_10_alpha_02.dat";...
    % "shale-09-02-02-old","Shale09ss_injection_rate_02_alpha_02.dat";...
    % "shale-09-10-02-old","Shale09ss_injection_rate_10_alpha_02.dat";...
    "carbonate-08-02-00","Carbonate08ss_injection_rate_02_alpha_00.dat";...
    "carbonate-08-02-03","Carbonate08ss_injection_rate_02_alpha_03.dat";...
    "carbonate-08-02-04","Carbonate08ss_injection_rate_02_alpha_04.dat";...
    "carbonate-08-10-00","Carbonate08ss_injection_rate_10_alpha_00.dat";...
    "carbonate-08-10-03","Carbonate08ss_injection_rate_10_alpha_03.dat";...
    "carbonate-08-10-04","Carbonate08ss_injection_rate_10_alpha_04.dat";...
    "carbonate-09-02-00","Carbonate09ss_injection_rate_02_alpha_00.dat";...
    "carbonate-09-02-03","Carbonate09ss_injection_rate_02_alpha_03.dat";...
    "carbonate-09-02-04","Carbonate09ss_injection_rate_02_alpha_04.dat";...
    "carbonate-09-10-00","Carbonate09ss_injection_rate_10_alpha_00.dat";...
    "carbonate-09-10-03","Carbonate09ss_injection_rate_10_alpha_03.dat";...
    "carbonate-09-10-04","Carbonate09ss_injection_rate_10_alpha_04.dat"
    };

for j=1:size(benchmark_list,1)

    close all
    name=char(benchmark_list{j,1});
    name2=char(benchmark_list{j,2});

    parameters=get_parameters(name);

    shift=100; %before: 100

    disp("Import and plot JR models")

    if contains (name2,'arbonate')
        jr=JRcarb2mat(['benchmark\',name2]);
        jr(:,1)=jr(:,1)+parameters.TstartCreep; %fixes time delay
        jr(:,4)=jr(:,4)+shift; %fixes slip delay

    else
        jr=JRshale2mat(['benchmark\',name2]);
        jr(:,1)=jr(:,1)+shift; %fixes time delay
        jr(:,4)=jr(:,4)+shift; %fixes slip delay

    end
    
    plotter(jr,parameters);

    % load and plot matlab model
    disp("Import and plot matlab models")

    globaloutput=load(['benchmark\',name,'model.mat']);
    
    globaloutput=globaloutput.globaloutput;

    plotter(globaloutput,parameters);
    hold on
    
    % load and plot julia model if available
    juliamodel = false;
    juliamodel2 = false;
    try
        disp("Import and plot julia models")
        juliamodel=importdata(['benchmark\',name,'rt.csv']);
        
        juliamodel=juliamodel.data;

        plotter(juliamodel,parameters)
        hold on
        
        juliamodel = true;
    end

    try
        disp("Import and plot julia models")
        juliamodel=importdata(['benchmark\',name,'.csv']);
        
        juliamodel=juliamodel.data;

        plotter(juliamodel,parameters)
        hold on
        
        juliamodel2 = true;
    end

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
    
    %% possible savefigure function
    fig.Renderer="painters";
    savefig(fig,['benchmark\plots\',name,'.fig'])
    saveas(fig,['benchmark\plots\',name,'.svg'])
    saveas(fig,['benchmark\plots\',name,'.png'])

end