% Calculates the zero load point segment

function output = ScuderiSSZLP(parameters)
    N=10000;
    
    % 100 points at steady state
    k=[0 1];
    
    t=k.*100;
    v=[1,1];
    theta=[1,1];
    u=v.*t;
    tau=[parameters.mu0 parameters.mu0];
    phi=[0,0];
    
    SS=[t',v',theta',u',tau',phi'];
    
    %ZLP stage
    %Initial conditions
    
    ICZLP=[tau(end),v(end),theta(end),u(end),phi(end)];
       
    tstartZLP=SS(end,1);
    tendZLP=tstartZLP+parameters.deltZLP;

    D=define_function(parameters,'simple',parameters.zlp_steptype);
    
    %Here there should be the Mathcad BDF solver, backward differentiation formula methods (ode23tb)

    figure(666) %for odeplot
    [t,omega] = ode45(D, [tstartZLP:(tendZLP-tstartZLP)/N:tendZLP], ICZLP, parameters.options);
%     [t,omega] = ode45(D, [tstartZLP tendZLP], ICZLP, options);

    ZLP=[t,omega(:,2),omega(:,3),omega(:,4),omega(:,1),omega(:,5)];

    output=[SS;ZLP];
    
    output=[output,zeros(size(output,1),2)];
    plotter(output)
end