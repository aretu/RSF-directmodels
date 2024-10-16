function parameters=get_parameters(expname)
%% input values

opts = detectImportOptions('inputparameters.xlsx');
opts.VariableNamingRule = 'preserve';

file=readtable('inputparameters.xlsx',opts);

% rows = (matches(file.name,"b902") | matches(file.name,"b1137"));

rows=matches(file.name,expname);

T=file(rows,:);
% experiments=table2struct(T);

%name
parameters.name=expname;

%
parameters.data=string(T.data);

%step options
parameters.zlp=char(T.zlp);
parameters.zlp_steptype=char(T.zlp_steptype);
parameters.crp_steptype=char(T.crp_steptype);
parameters.crpinj_modtype=char(T.crpinj_modtype);
parameters.crpinj_steptype=char(T.crpinj_steptype);

parameters.Area=T.("area (m^2)");
parameters.kvert=T.("k_vert (kN/mm)")*1e6; %N/m
parameters.dc=T.("d_c (mm)")*1e-3; %m
parameters.sigma=T.("sigma (MPa)")*1e6; % Effective Normal Stress, Pa 
parameters.pf0=T.("Pf (MPa)")*1e6;

parameters.experiment=T.name; %

% real time units
parameters.DtZLP=T.("dtzlp (hours)")*3600; %sec
parameters.DtCreep=T.("dtcreep (hours)")*3600; %sec
parameters.DtInj=T.("dtinj (hours)")*3600; %sec %duration of each pressure step

parameters.dpinjfactor=T.dpinjfactor; % correction due to sample geometry
parameters.DPInj=T.("dpinj (MPa)")*1e6; %Pa %amplitude of each pressure step

parameters.DtauInj=T.("dtauinj (MPa)")*1e6; %Pa %amplitude of each shear stress step

parameters.v0=T.("v0 (µm/s)")*1e-6; %m/s
parameters.mu0=T.mu0; % 
parameters.a=T.a; % 
parameters.b=T.b; % 

parameters.eta=T.eta; %magic number
parameters.alpha=T.alpha; % linker and dieterich
parameters.epsilon=T.epsilon; % segall and rice

parameters.xi=T.xi; %reduction of shear stress with respect to preshear
parameters.N=T.N; %number of model steps
parameters.M=T.M; %number of pressure steps 

parameters.k=parameters.kvert*parameters.dc/(parameters.sigma*parameters.Area);

% c and beta
if strcmp(parameters.crpinj_modtype,'complex')
    parameters.cstar=1/T.("difftime (s)"); %1/s
    parameters.beta=T.("beta (1/Pa)"); %1/Pa
    parameters.betahat=parameters.beta*parameters.sigma;
    parameters.chat=parameters.cstar*parameters.dc/parameters.v0;
else
    parameters.cstar=1/T.("difftime (s)"); %1/s
    parameters.beta=T.("beta (1/Pa)"); %1/Pa
    parameters.betahat=[];
    parameters.chat=[];
end

%step parameters

%normalized time units
%duration
parameters.deltZLP=parameters.v0*parameters.DtZLP/parameters.dc;
parameters.deltcreep=parameters.v0*parameters.DtCreep/parameters.dc;
parameters.delt=parameters.v0*parameters.DtInj/parameters.dc;

%normalized stress steps
parameters.delp=parameters.DPInj/parameters.sigma;
parameters.deltau=parameters.DtauInj/parameters.sigma;

%instant of times
parameters.TstartZLP=100; % always 100 points at steady state 
parameters.TstartCreep=parameters.TstartZLP+parameters.deltZLP;
parameters.TstartInj=parameters.TstartZLP+parameters.deltZLP+parameters.deltcreep;

end