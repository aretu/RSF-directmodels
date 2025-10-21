function runmodel(expname,savemod)
%% Setup paths
script_path=fileparts(mfilename('fullpath'));
cd(script_path);

root_path = fileparts(fileparts(script_path));
save_path=fullfile(root_path,"results",strcat(expname,"model"));

%% Import parameters
parameters=get_parameters(expname);

%Rudnicky uses TOL=1e-12 but there is no clear definition of TOL in Mathcad
% parameters.options=odeset('RelTol',1e-12,'Stats','on','OutputFcn',@odeplot);

parameters.options=odeset('RelTol',1e-9,'AbsTol',1e-12,'Stats','on','OutputFcn',@odeplot);
parameters.lw=1;

%% Run model

globaloutput=AllCreep(parameters);

%% Plot model results
close all

plotter(globaloutput,parameters);
comparison_plotter(globaloutput,parameters);
% dimplotter(globaloutput,parameters);


%% Save model results

if strcmp(savemod,'True')
    disp(strcat('saving data: ',expname," to folder: ", save_path))
    save(save_path,'globaloutput')
else
    disp(strcat('not saving: ',expname))
end
end