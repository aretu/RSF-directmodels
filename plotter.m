% function to plot data in normalized units

function output=plotter(input,parameters)

output.Time=input(:,1);
output.Sliprate=input(:,2);
output.State=input(:,3);
output.Slip=input(:,4);
output.Sstress=input(:,5);
output.Porosity=input(:,6);
output.Pfreservoir=input(:,7);
output.Pffault=input(:,8);

%% PLOTTING

figure(1)
S=fieldnames(output);

for k=2:size(S,1)
    
    subplot(2,4,k-1)
    hold on;
    plot(output.Time,output.(S{k}))
    title(S{k})
%     xline(parameters.TstartCreep,'--k','DisplayName','Onset of creep')
%     xline(parameters.TstartInj,'--k','DisplayName','Onset of stepping')
end

end