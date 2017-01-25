%% Create a sequence of network using a Poisson Point Process, then measure the mean SINR from a node at the centre

tic;

% Set up parameters of simulation

origin = [0 0];

pathlossExponent = 4; % Assume 2-ray multipath propagation model, alpha = 4

noInstances = 1;

networkRadius = 32; % units are unit distance (assumed to be m)

nodeDensity = 1;    % units are users per square unit distance

%% Define the antenna array radiation pattern for use on transmitters

% Set up paramters of array pattern

azimuth = 2*pi*[0:359]/360;

% Create array pattern - cone and sphere model

% mainlobeBeamwidth = 30; % mainlobe beamwidth in degrees * 360/length(azimuth)
% 
% mainlobeLevel = 10^(6/20);
% 
% sidelobeLevel = 10^(1/20);
% 
% antennaPattern = sidelobeLevel * ones(1,length(azimuth));
% 
% antennaPattern(1:floor(mainlobeBeamwidth/2)) = mainlobeLevel;
% 
% antennaPattern(length(azimuth)-floor(mainlobeBeamwidth/2):end) = mainlobeLevel;
% 
% antennaPatternIntegral = (mainlobeLevel * degtorad(mainlobeBeamwidth) + sidelobeLevel ...
%     * (2*pi - degtorad(mainlobeBeamwidth)))^(2/pathlossExponent);

% Create array pattern - raised sinusoid model

directivity = 0.99; % varies between 0 (no directivity) to 1 (creates nulls), =1 to align with [118]

noMainLobes = 1; % =1 to align with [118]

antennaPattern = 1 + directivity * cos(noMainLobes * azimuth);

antennaPatternIntegral = pi * ( (1-directivity)^(2/pathlossExponent) * ...
    hypergeom([0.5,-2/pathlossExponent],1,(2*directivity/(directivity-1))) ...
    + (1+directivity)^(2/pathlossExponent) * hypergeom([0.5,-2/pathlossExponent],1,(2*directivity/(directivity+1))) );

% Create array pattern - Chebyshev polynomial model

%% Create a sorted network over multiple instances and determine the SINR

% Set up paramters of transmissions and propagation model

nodeTransmitPower = 10^(0/20); % signal power in dB (=1 to align with [118])

noisePower = 10^(0/20); % noise power in dB (=1 to align with [118])

sinrThreshold = 10^(0/20); % dummy SINR (linear) threshold for now (=1 to align with [118])

alohaTransmissionProbability = 0.4;

sinr = cell(1,noInstances);

% create the random network

[nodeLocation,nodeOrientation] = createRandomNetwork(networkRadius,nodeDensity,'disc');

for instanceIndex=1:noInstances
    
    % Thin the network with ALOHA transmission probability
    
    [nodeLocation,nodeOrientation] = createRandomNetwork(networkRadius,nodeDensity,'disc');
    
    [thinnedNodeLocation,thinnedNodeOrientation] = thinNetwork(nodeLocation,nodeOrientation,alohaTransmissionProbability,1);
    
    % Add a node at predetermined distance
    
    
    
    
    % Calculate the distance and angle from origin of each node
    
    noNodes = length(thinnedNodeLocation);
    
    originNodeDistance = zeros(1,noNodes);

    originNodeAngle = zeros(1,noNodes);
    
    % sort the nodes by distance from the origin
    
    % [thinnedNodeLocation,thinnedNodeOrientation] = sortNetwork(thinnedNodeLocation,thinnedNodeOrientation,origin);
    
    for nodeIndex = 1:noNodes
    
        originNodeDistance(nodeIndex) = euclideanDistance(origin, thinnedNodeLocation(nodeIndex,:));
    
        originNodeAngle(nodeIndex) = euclideanAngle(thinnedNodeLocation(nodeIndex,:),origin);
    
    end

    % Restrict angle measurements to 0-2*pi
    
    originNodeAngle = mod(round(originNodeAngle*360/(2*pi)),360);
    
    % determine SINR, treating each node as the desired transmitter
    
    % S = (P*|h|^2)/(d^a+1)
    
    for nodeIndex = 1:length(originNodeAngle)
    
        signal = (nodeTransmitPower * antennaPattern(originNodeAngle(nodeIndex)+1)) / (1 + originNodeDistance(nodeIndex)^pathlossExponent);
    
        interferers = 1:length(originNodeAngle);
        
        interferers(nodeIndex) = [];
        
        interference = 0;
            
        for otherNodeIndex = interferers
            
            % I = (P*|h|^2)/(d^a+1)
    
            interference = interference + (nodeTransmitPower * antennaPattern(originNodeAngle(otherNodeIndex)+1)) / ...
                (1 + originNodeDistance(otherNodeIndex)^pathlossExponent);

        end
    
     noise = 0; % noisePower;
     
     sinr{instanceIndex}(nodeIndex) = signal/(interference + noise);    
     
    end
        
end

% plug in expression for integral of antenna pattern over 2*pi

thresholdProbEst = exp(-(sinrThreshold*noisePower*originNodeDistance(1)^pathlossExponent) ...
    /(nodeTransmitPower*antennaPattern(originNodeAngle(1)))) * ...
    exp(-((nodeDensity*alohaTransmissionProbability)/(2*pathlossExponent*sin(2*pi/pathlossExponent))) ...
    *(sinrThreshold/antennaPattern(originNodeAngle(1)))^(2/pathlossExponent)*2*pi*antennaPatternIntegral);

toc;