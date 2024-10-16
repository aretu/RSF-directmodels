% Calculates the Pf injection segment

function output = CreepManyJumps(vel0,state0,nstress0,disp0,porosity,tstart,parameters)
    xi=parameters.xi;  
    mu0=parameters.mu0;
    dp=parameters.delp*parameters.dpinjfactor; %corrected by hollow sample effect
    dt=parameters.delt;
    M=parameters.M;
    N=parameters.N;
%     N=10000;

    Oldstate=state0;
    Oldnstress=nstress0;
    Oldvel=vel0;

    % calculate the new state variable and velocity
    newstate=statenew(Oldstate,Oldnstress,-dp,parameters);

    newvel=velnew(Oldvel,Oldnstress,-dp,Oldstate,parameters);


    %Initial conditions

    IC=[newstate,newvel,disp0,xi*mu0,porosity];

    D=define_function(parameters,parameters.crpinj_modtype,parameters.crpinj_steptype);

    %Here there should be the Mathcad Radau solver, uses the Radau5 method or Radau IIA (??)
    figure(666) %for odeplot
    [t,CC] = ode45(D, [tstart:dt/N:tstart+dt], IC, parameters.options); %require N timesteps

    Comp=[t,CC(:,2),CC(:,1),CC(:,3),CC(:,4),CC(:,5)];
    
    Comp=[Comp,zeros(size(Comp,1),2)];
    plotter(Comp)

    for k=1:M
        Oldstate=Comp(end,3);
        Oldnstress=Oldnstress-dp;
        Oldvel=Comp(end,2);
        newstate=statenew(Oldstate,Oldnstress,-dp,parameters);

        newvel=velnew(Oldvel,Oldnstress,-dp,Oldstate,parameters);
        
        %Initial conditions
        IC=[newstate,newvel,Comp(end,4),Comp(end,5),Comp(end,6)];

        %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)
        figure(666) %for odeplot
        [t,CC] = ode45(D, [tstart+k*dt:dt/N:tstart+(k+1)*dt], IC, parameters.options); %require N timesteps

        Comp=[Comp;[t,CC(:,2),CC(:,1),CC(:,3),CC(:,4),CC(:,5),zeros(size(CC,1),2)]];

        plotter(Comp)
    
        disp(k)
    end
    output=Comp;
end