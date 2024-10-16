% Calculates entire injection experiment

function output = AllCreep(parameters)
    % model the final part of steady state, the zero load point (optional)
    % and the constant shear stress stage before stepping
    
    Initial=SCreep(parameters);

    Time=Initial(size(Initial,1)-1,1);
    Velocity=Initial(size(Initial,1)-1,2);
    State=Initial(size(Initial,1)-1,3);
    Disp=Initial(size(Initial,1)-1,4);
    Shear=Initial(size(Initial,1)-1,5);
    Porosity=Initial(size(Initial,1)-1,6);
    
    if and(parameters.DPInj>0,parameters.DtauInj==0)
        % model the reactivation experiment by pore fluid stepping
        if strcmp(parameters.crpinj_modtype,'simple')
            % simple pore fluid stepping
            Jumps=CreepManyJumps(Velocity,State,1,Disp,Porosity,Time,parameters);
            Jumps(:,end)=pressure(Jumps(:,1),parameters);
            Jumps(:,end-1)=pressure(Jumps(:,1),parameters);
    
        elseif strcmp(parameters.crpinj_modtype,'complex')
            % complex pore fluid stepping
            Jumps=CreepManyJumpsComplex(Velocity,State,Disp,Porosity,Time,parameters);
    
        end
    else
        % model the reactivation experiment by shear stress stepping
        Jumps=CreepManyJumpsTauCRP(Velocity,State,Shear,Disp,Porosity,Time,parameters);
    end
    output=[Initial;Jumps];
end