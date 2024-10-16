close all
clearvars

benchmark_list={
    "shale-08-02-02","Shale08ss_injection_rate_02_alpha_02.dat";...
    "shale-08-10-02","Shale08ss_injection_rate_10_alpha_02.dat";...
    "shale-09-02-02","Shale09ss_injection_rate_02_alpha_02.dat";...
    "shale-09-10-02","Shale09ss_injection_rate_10_alpha_02.dat";...
    "shale-09-02-02-old","Shale09ss_injection_rate_02_alpha_02.dat";...
    "shale-09-10-02-old","Shale09ss_injection_rate_10_alpha_02.dat";...
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

    globaloutput=load(['benchmark\',name,'model.mat']);
    
    globaloutput=globaloutput.globaloutput;

    plotter(globaloutput,parameters);
    hold on

    sgtitle(name)
    fig=gcf;

    for i=1:size(fig.Children,1)
        if fig.Children(i).Type == "axes"
            gca=fig.Children(i);
            gca.FontSize=14;
            gca.FontName='Arial';

            gca.Children(2).DisplayName='JR23';
            gca.Children(2).LineStyle='none';
            gca.Children(2).Marker='o';
            gca.Children(2).Color='black';

            gca.Children(1).DisplayName='SA';
            gca.Children(1).LineStyle='-';
            gca.Children(1).LineWidth=2;
            gca.Children(1).Color='red';
            uistack(gca.Children(1),"top");

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