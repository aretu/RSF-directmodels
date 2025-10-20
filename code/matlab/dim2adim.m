function output=dim2adim(input,parameters)

output.NTime=input.Time*parameters.v0/parameters.dc; %needs to be zeroed at onset of constant shear stress stage

output.NSliprate=input.Sliprate/parameters.v0;

output.NState=input.State*parameters.v0/parameters.dc;

output.NSlip=input.Slip/parameters.dc;

output.NSstress=input.Sstress/parameters.sigma;

output.NPorosity=input.Porosity-0; %needs to be zeroed for initial porosity

output.NPfreservoir=(input.Pfresvoir-parameters.pf0)/parameters.sigma;

output.NPffault=(input.Pf-parameters.pf0)/parameters.sigma;

end
