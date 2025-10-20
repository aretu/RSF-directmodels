% Calculates the Tau stepping segment - NOT SURE IF IT IS CORRECT

function output = CreepManyJumpsTauZLP(vel0,state0,sstress0,disp0,porosity,tstart,parameters)
    xi=parameters.xi;  
    mu0=parameters.mu0;
    dp=parameters.delp;
    dtau=parameters.deltau;
    dt=parameters.delt;
    M=parameters.M;
    N=parameters.N;
%     N=10000;
    
    vaftZLP=vafter2(vel0,sstress0,xi*mu0,parameters); %vbefore,taubefore,tauafter


    ICZLP=[xi*mu0,vaftZLP,state0,disp0,porosity];
       
    D=define_function(parameters,'simple',parameters.zlp_steptype);
    
    %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)

    figure(666) %for odeplot
    [t,omega] = ode45(D, [tstart:dt/N:tstart+dt], ICZLP, parameters.options);

    Comp=[t,omega(:,2),omega(:,3),omega(:,4),omega(:,1),omega(:,5)];
   
    Comp=[Comp,zeros(size(Comp,1),2)];
    plotter(Comp)

    for k=1:M
        vaftZLP=vafter2(Comp(end,2),Comp(end,5),Comp(end,5)+dtau,parameters); %vbefore,taubefore,tauafter

        %Initial conditions
        IC=[Comp(end,5)+dtau,vaftZLP,Comp(end,3),Comp(end,4),Comp(end,6)];

        %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)
        figure(666) %for odeplot
        [t,omega] = ode45(D, [tstart+k*dt:dt/N:tstart+(k+1)*dt], IC, parameters.options); %require N timesteps

        Comp=[t,omega(:,2),omega(:,3),omega(:,4),omega(:,1),omega(:,5)];

        Comp=[Comp,zeros(size(Comp,1),2)];

        plotter(Comp)
    
        disp(k)
    end
    output=Comp;
end