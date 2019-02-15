function [Stable, Imageable] = SingleSim(KnownExo, YearsSim)
% Description: The following function performs one simulation for a
% specific system. Reading the information from the known exoplanets of the
% particular system, a new random exoplanet is generated. The entire system
% is then integrated over the period of time specified by 'YearsSim'. While
% integrating, after a period of time determined by 'checktime', the
% stability conditions are checked. Depending on the result, the
% integration continues or ends. 

% Input: 
    % - KnownExo: Array formed by the exoplanets contained in the system  
    % analyzed and specified in TargetList. Each array element consists
    % of an exoplanet struct. 
    % - YearsSim: Simulation time in years. 

% Output: 
    % - Stable: Boolean indicating if the simulated case is stable or not.
    
Constants;            % Load constant values    
m = length(KnownExo); % Number of known exoplanets
n = m + 1;            % Total number of planets (Known and Random)

RandomExo = GenerateExo(KnownExo);              % Generate random exoplanet
if RandomExo.a == 0
    Stable = 0;
    Imageable = 0;
else 
    Imageable = 1;
    Exo = [RandomExo, KnownExo];                % Create vector containing known and random exoplanet

    [y_in, dy_in, mus] = InitialCond(Exo);      % Calculate system's initial conditions

    InitialDist = zeros(1, n);                  % Initialize planets distance from star
    StarInitPos = y_in(end - 2 : end);          % Star intial position
    for i = 1 : n                                          % Iterate over every planet
        PlanetPos = y_in((3 * i - 2) : 3 * i);             % Planet initial position
        InitialDist(i) = norm(PlanetPos - StarInitPos);    % Calculate and store planet intial distance from star
    end

    dt = min([Exo.per]) / 9;                    % Time step a ninth of the minimum orbital period of the system   
    t_in = [dt; checktime; dtoutput];           % Rebound time parameters            
    SimTime = 0;                                % Initialize SimTime
    Stable = 1;                                 % Initialize Stability flag

    while Stable == 1 && SimTime <= (YearsSim * YearDays)

        [t_out, y_out, dy_out] = reboundmex(t_in, y_in, dy_in, mus); % Run n body integration with rebound
        y_in = y_out(:, end);                                        % Calculate new initial position
        dy_in = dy_out(:, end);                                      % Calculate new initial velocity
        SimTime = SimTime + checktime;                               % Update simulation time
        Stable = StabilityCheck(y_out, dy_out, mus, InitialDist, n); % Perform Stability check

    end
end

end