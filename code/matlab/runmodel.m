function runmodel(expname,savemod)

% cd to path of this script
if(~isdeployed)
    cd(fileparts(matlab.desktop.editor.getActiveFilename));
end

parameters=get_parameters(expname);

%Rudnicky uses TOL=1e-12 but there is no clear definition of TOL in Mathcad
% parameters.options=odeset('RelTol',1e-12,'Stats','on','OutputFcn',@odeplot);

parameters.options=odeset('RelTol',1e-9,'AbsTol',1e-12,'Stats','on','OutputFcn',@odeplot);

%% RUN MODEL

globaloutput=AllCreep(parameters);

%% PLOT
close all

plotter(globaloutput,parameters);
comparison_plotter(globaloutput,parameters);
% dimplotter(globaloutput,parameters);


%% SAVE

if strcmp(savemod,'True')
    disp('saving data')
    save(['./results/',expname,'model'],'globaloutput')

else
    disp('not saving')
end
end