function output=comparison_plotter(input,parameters)

% necessary data conversions

output.Time=input(:,1);
output.Sliprate=input(:,2);
output.State=input(:,3);
output.Slip=input(:,4);
output.Sstress=input(:,5);
output.Porosity=input(:,6);
output.Pfreservoir=input(:,7);
output.Pffault=input(:,8);

Time_min=output.Time*parameters.dc/parameters.v0/60; %minutes
Vel_mms=output.Sliprate*parameters.v0*1e3; %millimeters per second
Displ_mm=output.Slip*parameters.dc*1e3; % millimeters

Pf=output.Pffault*parameters.sigma+parameters.pf0; %Pa
Sigma_n_eff=parameters.sigma+parameters.pf0-Pf; %Pa
% Sigma_n_eff_test=parameters.sigma+parameters.pf0-(parameters.dpinjfactor*Pf);
Tau=parameters.sigma*output.Sstress; %Pa

%time starts from start of creep!!

output.Time=output.Time-parameters.TstartCreep-100; %seconds

%% Figure 4 Rudnicki
figure(3)

yyaxis left
hold on;
plot(output.Time,log(output.Sliprate),'DisplayName',parameters.name)
ylabel('ln(v/v_{R})')

yyaxis right
hold on;
plot(output.Time,output.Pffault)
ylabel('Pressure, \Delta p / \sigma_{0}')

xlabel('Time, v_{R}t/d_{c}')
title('Figure 4 R23')

%% Figure 15 Rudnicki
figure(4)
hold on;

semilogy(Time_min,Vel_mms,'DisplayName',parameters.name)
ylabel('Velocity, mm/s)')

xlabel('Time, min')
title('Figure 15 R23')

%% Figure 4 Rudnicki
figure(5)
hold on;

semilogy(Time_min,Displ_mm,'DisplayName',parameters.name)
ylabel('Displacement, mm')

xlabel('Time, min')
title('Figure 4 R23')

%% Figure 16 Rudnicki
figure(6)
hold on;

semilogy(Time_min,Displ_mm*1e3,'DisplayName',parameters.name)
ylabel('Displacement, \mu m')

xlabel('Time, min')
title('Figure 16 R23')

%% Figure 14 Rudnicki
figure(7)
hold on;
plot(output.Time,output.Pfreservoir,'-b','DisplayName',parameters.name)
plot(output.Time,output.Pffault,'-r','DisplayName',parameters.name)

ylabel('$Pressure, \Delta p / \overline{\sigma}_0$','interpreter','latex')

xlabel('Time, v_{R}t/d_{c}')
title('Figure 14 R23')

%% bonus figure - stresses
figure(8)
yyaxis left;
hold on;
plot(Time_min,Pf,'-c','DisplayName',['Pore pressure (MPa) ' parameters.name])
plot(Time_min,Sigma_n_eff,'-m','DisplayName',['Effective normal stress (MPa) ' parameters.name])
plot(Time_min,Tau,'-k','DisplayName',['Shear stress (MPa) ' parameters.name])

ylabel('Stress and pressure, Pa')

yyaxis right;
hold on;
plot(Time_min,Tau./Sigma_n_eff,'-g','DisplayName',['Effective friction ' parameters.name])

xlabel('Time, min')
legend
title('Figure with stresses')
