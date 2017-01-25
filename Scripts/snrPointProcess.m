%% Determine the intensity of transformed PPP

% Set parameters for simulation

origin = [0 0];

userDensity = 0.1;

networkRadius = 100;

transmitPower = 10^(0/20);

fadingCoefficient = 3;

alohaTransmissionProbability = 1;

noisePower = 10^(-40/20);

noInstances = 1e3;

% Set parameters for antenna pattern

arrayDirectivity = 0.5;

noArrayLobes = 2;

% Create antenna array radiation pattern

azimuth = linspace(0,2*pi,360);

arrayPattern = 1 + arrayDirectivity * cos(noArrayLobes * azimuth);

% Create vector of distance measures

powerAxis = linspace(0,1,1000);

% Create 2-D network of users for each instance

receivedPowerHist = cell(noInstances,1);

for instanceIndex = 1:noInstances
   
    groundProcessLocation = [];
    groundProcessOrientation = [];
    
    [groundProcessLocation,groundProcessOrientation] = createRandomNetwork(networkRadius,userDensity,'disc');

    %[thinnedProcessLocation,thinnedProcessOrientation] = thinNetwork(groundProcessLocation,groundProcessOrientation,alohaTransmissionProbability,0);

    % Count the number of users

    noUsers = length(groundProcessOrientation);

    receivedPower = zeros(1,noUsers);
    
    for userIndex = 1:noUsers
        
        receivedPower(userIndex) = transmitPower * (euclideanDistance(groundProcessLocation(userIndex,:),origin))^(-fadingCoefficient);
    
    end
    
    [receivedPowerHist{instanceIndex},~] = histcounts(receivedPower,powerAxis,'Normalization','cumcount');
        
end

% Compute the average number of nodes found in each interval, i.e. find
% the average of all the histograms from each network instance. Infinity pad
% the average to include the value for P_r = 0

receivedPowerHistogram = [Inf ensembleAve(receivedPowerHist)];

% Calculate the expected intensity measure of the received power point
% process from (81) in logbook

recievedPowerIntensityMeasure = pi* userDensity * powerAxis.^(-2/fadingCoefficient);

% Compute the intensity function of the received power point process from
% the received power intensity measure. Zero pad to account for the diff
% function reducing the number of entries by 1.

receivedPowerIntensity = [diff(receivedPowerHistogram) 0] / diff(powerAxis(1:2));

% Calculate the expected intensity function of the received power point
% process from (82) in logbook.

receivedPowerIntensityFunction = pi * userDensity * 2/fadingCoefficient * powerAxis.^(-2/fadingCoefficient - 1);


