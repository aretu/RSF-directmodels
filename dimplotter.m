% function to plot data converted to real units

function output=dimplotter(input,parameters)

NTime=input(:,1);
output.Time=NTime*parameters.dc/parameters.v0;

NSliprate=input(:,2);
output.Sliprate=NSliprate*parameters.v0;

NState=input(:,3);
output.State=NState*parameters.dc/parameters.v0;

NSlip=input(:,4);
output.Slip=NSlip*parameters.dc;

NSstress=input(:,5);
output.Sstress=NSstress*parameters.sigma;

NPorosity=input(:,6);
output.Porosity=NPorosity+0; %initial porosity in ZLP or SCreep is 0

NPfreservoir=input(:,7);
output.Pfreservoir=NPfreservoir*parameters.sigma+parameters.pf0;

NPffault=input(:,8);
output.Pffault=NPffault*parameters.sigma+parameters.pf0;

%% PLOTTING

figure(2)
S=fieldnames(output);

for k=2:size(S,1)
subplot(2,4,k-1)
plot(output.Time,output.(S{k}))
title(S{k})
% xline(parameters.TstartCreep,'-r')
% xline(parameters.TstartInj,'-b')
end

end