% Calculates the segment at zero load point and then creep

function output = SCreep(parameters)
    zlp=parameters.zlp;
    N=parameters.N;
    
    switch zlp
        case 'True'
            CalcSSZLP=ScuderiSSZLP(parameters);
        case 'False'
            % 100 points at steady state
            k=[0 1];
            
            t=k.*100;
            v=[1,1];
            theta=[1,1];
            u=v.*t;
            tau=[parameters.mu0 parameters.mu0];
            phi=[0,0];
            pr=[0,0];
            p=[0,0];
            
            CalcSSZLP=[t',v',theta',u',tau',phi',pr',p'];
    end

    vaftZLP=vafter2(CalcSSZLP(end,2),CalcSSZLP(end,5),parameters.xi*parameters.mu0,parameters);
    
    %CRP stage
    %Initial conditions

    ICCRP=[CalcSSZLP(end,3),vaftZLP,CalcSSZLP(end,4),parameters.xi*parameters.mu0,CalcSSZLP(end,6)]; %slip era 0

    tstartCRP=CalcSSZLP(end,1);
    tendCRP=tstartCRP+parameters.deltcreep;

    D=define_function(parameters,'simple',parameters.crp_steptype);
    
    %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)
    
    figure(666) %for odeplot
    [t,omega] = ode45(D, [tstartCRP:(tendCRP-tstartCRP)/N:tendCRP], ICCRP, parameters.options);
    
    output=[CalcSSZLP;t,omega(:,2),omega(:,1),omega(:,3),omega(:,4),omega(:,5),zeros(size(omega,1),2)];

    plotter(output)
end