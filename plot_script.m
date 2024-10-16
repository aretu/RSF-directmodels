close all
name="dummy-s";
name=char(name);

parameters=get_parameters(name);

globaloutput=load(['results\',name,'model.mat']);

globaloutput=globaloutput.globaloutput;

comparison_plotter(globaloutput,parameters);

dimplotter(globaloutput,parameters);