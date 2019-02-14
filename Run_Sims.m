function [Stability] = Run_Sims(TargetList, Norb, YearsSim, Ncores)
% Description: The following function runs several simulations (Norb) for
% each Target system. 
% Input: 
    % - All: Input is formed by the TargetList struct, containing the 
    % system and planets of the correspoding system which must be 
    % simulated. Norb defines de number of study cases for each system,
    % while YearsSim indicates de years of simulation for each case. 
% Output: 
    % - Stability: Contains the results for each system studied. In
    % particular the number and percentage of stable orbits is stored.

parpool(Ncores)                         % Starting parallel pool
Targets = ImportData(TargetList);       % Import struct with each target properties
cont = 1;

for i = 1 : length(Targets)             % Iterate over every system target
    StableOrbs = zeros(1, Norb);        % Initialize stable orbits vector
    ImageableOrbs = zeros(1, Norb);     % Initialize imageable orbits vector
    Target = Targets{i};                % Select target system to be studied
    
    parfor (j = 1 : Norb, Ncores)                       % Start Parallel pool
        [StableOrbs(j), ImageableOrbs(j)] = SingleSim(Target, YearsSim);    % Calculate stability for particular case
    end
    
    System = Targets{i}(1).system;                      % Get system name
    NStable = sum(StableOrbs);                          % Calculate number of stable orbits
    NImageable = sum(ImageableOrbs);
    Stability(i, :) = {System, NImageable, NStable, ...
                       (NStable / Norb) * 100, (NStable / NImageable) * 100};% Store results in stability cell matrix
    
    fprintf('%i%%\n',(cont/(length(Targets)) * 100))
    cont = cont + 1;
end
end