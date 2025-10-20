function output = vafter2 (vbefore,taubefore,tauafter,parameters)

output = vbefore*exp((tauafter-taubefore)/parameters.a);

end