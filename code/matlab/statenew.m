function output = statenew (stateold,nstressold,deltastress,parameters)

    output = stateold*(nstressold/(nstressold+deltastress))^(parameters.alpha/parameters.b);

end