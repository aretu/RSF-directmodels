% Calculates the Pf injection segment

function output = CreepManyJumpsComplex(vel0,state0,disp0,porosity,tstart,parameters)
    dt=parameters.delt;

    M=parameters.M;
    N=parameters.N;
    xi=parameters.xi;
    mu0=parameters.mu0;

    dprev=parameters.delp*parameters.dpinjfactor; %corrected by hollow sample effect
    p0=0;

    %Initial conditions

    IC=[p0,vel0,state0,porosity,disp0,dprev,xi*mu0];

    D=define_function(parameters,parameters.crpinj_modtype,parameters.crpinj_steptype);

    %Here there should be the Mathcad Radau solver, uses the Radau5 method or Radau IIA (??)
    figure(666) %for odeplot
    [t,CC] = ode45(D, [tstart:dt/N:tstart+dt], IC, parameters.options); %require N timesteps

    Comp=[t,CC(:,2),CC(:,3),CC(:,5),CC(:,7),CC(:,4),CC(:,6),CC(:,1)];
    
    plotter(Comp)

    for k=1:M

        %Initial conditions
        IC=[Comp(end,8),Comp(end,2),Comp(end,3),Comp(end,6),Comp(end,4),Comp(end,7)+dprev,Comp(end,5)];

        %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)
        figure(666) %for odeplot
        [t,CC] = ode45(D, [tstart+k*dt:dt/N:tstart+(k+1)*dt], IC, parameters.options); %require N timesteps


        Comp=[Comp;[t,CC(:,2),CC(:,3),CC(:,5),CC(:,7),CC(:,4),CC(:,6),CC(:,1)]];

        plotter(Comp)
        disp(k)
    end
    output=Comp;
end