%Calculates reservoir pressure

function output = pressure(t,parameters)
    dt=parameters.delt;
    dp=parameters.delp*parameters.dpinjfactor;
    M=parameters.M;
    
    t=t-parameters.TstartInj;
    t=t';

    %% METODO DI RUDNICKI
%     output=zeros(size(t,1),size(t,2));
%     output1=output;
%     
%     output(t>0)=(M+1)*dp*heaviside(t(t>0)-(M+1)*dt);
%     
%     for k=0:M
%         output1(t>0) = output1(t>0) + ((k+1)*dp*(heaviside(t(t>0)-k*dt)-heaviside(t(t>0)-(k+1)*dt)));
%     end
% 
%     output=output+output1;
%     output=output';

    %% UN ALTRO METODO DA CHATGPT MA I RISULTATI SONO SBAGLIATI UGUALI
    % Define time interval for p increase and the rate of increase
    p_increase_interval = dt; % Increase p every 100 seconds
    p_increase_rate = dp; % Increase p by 0.1
    
    time=t(t>0);

    % Initialize p
    p = zeros(size(time));
    
    % Calculate the increments of p
    increments = ceil(time / (p_increase_interval)); % Increments every 100 seconds
    
    % Update p based on increments
    previous_increment = 0;
    for i = 1:length(time)
        if increments(i) > previous_increment
            p(i) = p_increase_rate * increments(i);
            previous_increment = increments(i);
        else
            p(i) = p(i-1); % Maintain the previous value of p
        end
    end
    
    output=zeros(size(t,1),size(t,2));
    output(t>0)=p;
    output=output';
end