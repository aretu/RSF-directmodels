close all
name="mcf-055-01-00-000000-1a";
% name="mcf-055-01-00-000000-000001-2E-12-2a";
name=char(name);

% model parameters

parameters=get_parameters(name);

%% matlab
% load matlab model results

globaloutput=load(['results\',name,'model.mat']);

globaloutput=globaloutput.globaloutput;

% plot matlab model results
comparison_plotter(globaloutput,parameters);

dimplotter(globaloutput,parameters);

%% julia
% load julia model result

globaloutput2=importdata(['..\julia-tests\results\',name,'rt.csv']);
globaloutput2=globaloutput2.data;

% plot julia model results
comparison_plotter(globaloutput2,parameters);

dimplotter(globaloutput2,parameters);