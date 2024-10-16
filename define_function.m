function odefun = define_function(parameters,modtype,steptype)


%% import parameters
a=parameters.a;  
b=parameters.b; 

k=parameters.k;

epsilon=parameters.epsilon;

eta=parameters.eta;

alpha=parameters.alpha;

%% define step
switch modtype
case 'simple'

    syms v(t) u(t) theta(t) tau(t) phi(t) p(t) prev(t) T Y

    switch steptype
    case 'zlp'
        dv = diff(v) == v/a * (diff(tau) - b / theta * diff(theta))/(1 + v * eta/a);
        du = diff(u) == v;
        dtheta = diff(theta) == 1 - theta * v;
        dtau = diff(tau) == -k * v;
        dphi = diff(phi) == -v * (phi - epsilon * log(v));

    case 'creep'
        dv = diff(v) == -b/a * v * (1/theta * diff(theta));
        du = diff(u) == v;
        dtheta = diff(theta) == 1 - theta * v;
        dtau = diff(tau) == 0;
        dphi = diff(phi) == -v * (phi - epsilon * log(v));

    case 'zlp-shale'
        dv = diff(v) == v/a * (diff(tau) - b / theta * diff(theta))/(1 + v * eta/a);
        du = diff(u) == 0;
        dtheta = diff(theta) == 1 - theta * v;
        dtau = diff(tau) == -k * v;
        dphi = diff(phi) == -v * (phi - epsilon * log(v));
    
    case 'creep-shale'
        dv = diff(v) == -b/a * v * (1/theta * diff(theta));
        du = diff(u) == 0;
        dtheta = diff(theta) == 1 - theta * v;
        dtau = diff(tau) == 0;
        dphi = diff(phi) == -v * (phi - epsilon * log(v));

    end

    eqns=[dv dtheta du dtau dphi];

    [VF,Subs] = odeToVectorField(eqns); 

    odefun = matlabFunction(VF,'Vars', {T,Y});

case 'complex'
    chat=parameters.chat;
    betahat=parameters.betahat;
    mu0=parameters.mu0;

    syms v(t) u(t) theta(t) tau(t) phi(t) p(t) prev(t) T Y
    
    switch steptype

    case 'creepinj-shale'

%         dv = diff(v) == v/a * ( diff(p) * mu(v,theta,parameters) - b/theta*diff(theta) );
        
        dv = diff(v) == v/a * (diff(p) * (mu0 + a * log(v) + b * log(theta)) - b/theta*diff(theta));
        dtheta = diff(theta) == 1 - theta * v + alpha/b * theta/(1 - p) * diff(p);
        dp = diff(p) == chat * (prev - p) - diff(phi)/betahat;
        du = diff(u) == v;
        dprev = diff(prev) == 0;
        dtau = diff(tau) == 0;
        dphi = diff(phi) == -v * (phi - epsilon * log(v));

    end

        eqns=[dv dtheta dp du dprev dtau dphi];

        [VF,Subs] = odeToVectorField(eqns); 

        odefun = matlabFunction(VF,'Vars', {T,Y});

end




end