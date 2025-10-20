%% add s1949 data
function dataoverlayer(path,timeoffset,parameters)

load(path,'Time','vel','PumpPressure');

vel2=vel;

if parameters.kvert=='386120000'
else
vel2(vel2<=1e-5)=0;
end
vel3=smooth(vel2,201);

PumpPressure_Pa=PumpPressure*1e6;
PumpPressure_Pa2=smooth(PumpPressure_Pa,101);

NTime=Time*parameters.v0/parameters.dc-timeoffset;
NSliprate=vel3/parameters.v0;
NPffault=(PumpPressure_Pa2-parameters.pf0)/parameters.sigma*parameters.dpinjfactor;


yyaxis left;
hold on;
plot(NTime,log(NSliprate),'-r','DisplayName','Slip rate measured (s201)')

yyaxis right;
hold on;
plot(NTime,NPffault,'-c','DisplayName','Pf measured (s101)')

end