function output = mu (v,theta,parameters)
    output=parameters.mu0+parameters.a*log(v)+parameters.b*log(theta);
end