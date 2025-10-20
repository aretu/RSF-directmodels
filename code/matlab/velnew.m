function output = velnew (velold,nstressold,deltastress,stateold,parameters)

    output = velold*((nstressold+deltastress)/nstressold)^(parameters.alpha/parameters.a)*exp(-deltastress/(parameters.a*(nstressold+deltastress))*mu(velold,stateold,parameters));

end

