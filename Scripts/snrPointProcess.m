%% Determine the intensity of transformed PPP

% Set parameters for simulation

origin = [0 0];

userDensity = 0.1;

networkRadius = 100;

% transmitAmplitude is expressed in Volts

transmitAmplitude = 10^(0/20);

fadingCoefficient = 3;

alohaTransmissionProbability = 1;

% noiseAmplitude is expressed in Volts

noiseAmplitude = 10^(-40/20);

noInstances = 1e3;

% Set parameters for antenna pattern

arrayDirectivity = .5;

noArrayLobes = 1;

% Create antenna array radiation pattern

azimuth = linspace(0,2*pi,360);

arrayPattern = 1 + arrayDirectivity * cos(noArrayLobes * azimuth);

% Create vector of distance measures

samplingResolution = 0.5;

% Create the axis onto which the point process intensities are measured;
% this is expressed in decibels (10*log10(P))

minPower = floor(20*log10((1-arrayDirectivity)) - fadingCoefficient*10*log10(networkRadius))+20;
maxPower = ceil(20*log10((1+arrayDirectivity)) - fadingCoefficient*10*log10(1e-3));

powerAxis = minPower:samplingResolution:maxPower;

% Create 2-D network of users for each instance

mappedProcessIntensity = cell(1,noInstances);
    
for instanceIndex = 1:noInstances
   
    groundProcessLocation = [];
    groundProcessOrientation = [];
    
    [groundProcessLocation,groundProcessOrientation] =  ...
        createRandomNetwork(networkRadius,userDensity,'disc');

    [thinnedProcessLocation,thinnedProcessOrientation] = ...
        thinNetwork(groundProcessLocation,groundProcessOrientation, ...
        alohaTransmissionProbability,0);

    % Count the number of users

    noUsers(instanceIndex) = length(thinnedProcessOrientation);

    mappedProcessLocation = zeros(1,noUsers(instanceIndex));
    
    gain = zeros(1,noUsers(instanceIndex));
    attenuation = zeros(1,noUsers(instanceIndex));
    
    for userIndex = 1:noUsers(instanceIndex)
        
        % Gain is expressed here in Amplitude gain (i.e. Volts)
               
        gain(userIndex) = transmitAmplitude * arrayPattern(mod(round(...
            thinnedProcessOrientation(userIndex)*360/(2*pi)),360)+1);
        
        % Map the locations of the thinned point process to the Real line
        % representing the received power. 
        % Psi' = P_r(x)= 20*log10(A_t*G)/(|x|^alpha)
        
        attenuation(userIndex) = 10 * fadingCoefficient * log10(...
            euclideanDistance(thinnedProcessLocation(userIndex,:),origin));
        
        mappedProcessLocation(userIndex) = ...
            20*log10(gain(userIndex)) - attenuation(userIndex);
    
    end
    
    % Compute the contact distance for that instance of the point process -
    % the closest user is the one with the largest x' value.
    
    contactDistance(instanceIndex) = max(mappedProcessLocation);
    
    mappedProcessIntensity{instanceIndex} = zeros(1,length(powerAxis));
        
    for powerIndex = 1:length(powerAxis)
        
        mappedProcessIntensity{instanceIndex}(powerIndex) = ...
            length(find(mappedProcessLocation >= powerAxis(powerIndex)));
    
    end
        
end

%%

% Compute the average number of nodes found in each interval, i.e. find
% the average of all the individual intensities

mappedProcessIntensityMeasure = ensembleAve(mappedProcessIntensity);

% Calculate the expected intensity measure of the received power point
% process from (81) in logbook

receivedPowerIntensityMeasure = pi* userDensity * ...
    10.^(-2*powerAxis/(10*fadingCoefficient));

gainAxis = (round(20*log10((min(arrayPattern)))/samplingResolution)*...
    samplingResolution):samplingResolution:(round(20*log10((max(arrayPattern)))...
    /samplingResolution)*samplingResolution);

arrayPatternProbabilityDensityFunction = noArrayLobes./(pi * ...
    abs(noArrayLobes*arrayDirectivity*sqrt(1- ...
    ((10.^(gainAxis/20)-1).^2)./(arrayDirectivity^2))));

% Set points equalling infinity to the mirror to prevent issues in later
% program

arrayPatternProbabilityDensityFunction(end) = ...
    arrayPatternProbabilityDensityFunction(1);

% Normalise array pattern equation to make it a PDF

arrayPatternProbabilityDensityFunction = arrayPatternProbabilityDensityFunction/ ...
    sum(arrayPatternProbabilityDensityFunction*diff(gainAxis(1:2)));

% Compute the intensity function of the received power point process from
% the received power intensity measure. Zero pad to account for the diff
% function reducing the number of entries by 1.

mappedProcessIntensityFunction = [diff(mappedProcessIntensityMeasure) ...
    0] / diff(powerAxis(1:2));

% Calculate the expected intensity function of the received power point
% process from (82) in logbook.

%receivedPowerIntensityFunctionGround = -pi * userDensity * ...
%    2*10.^(-2*powerAxis/(10*fadingCoefficient))*log(10)/fadingCoefficient;

% receivedPowerIntensityFunctionGround = (-pi * userDensity * log(10)) / ...
%     fadingCoefficient * 2.^(-powerAxis/(5*fadingCoefficient)) .* ...
%     5.^((-powerAxis/(5*fadingCoefficient))-1);

receivedPowerIntensityFunctionGround = (-pi * userDensity * log(10))  *  ...
    10.^(-powerAxis/(10*fadingCoefficient)) / 10*fadingCoefficient;

% Perform convolution of the sampled intensity function and array pattern
% PDF. Discard the 'top' samples, which correspond to P_r we aren't
% interested in.

receivedPowerIntensityFunction = conv(receivedPowerIntensityFunctionGround,...
    arrayPatternProbabilityDensityFunction*samplingResolution,'same');

receivedPowerIntensityFunction = receivedPowerIntensityFunction(1:...
    length(mappedProcessIntensityFunction));

%% 

% find the first valid entry in the measurement of the empirical intensity
% function (i.e. when it no longer equals zero)

startingSample = find(mappedProcessIntensityFunction,1,'first');

% Calculate the mean squared error of the predictions made by the 
% directional and omni-directional models to the empirical measured point process intensity function.

mseOmnidirectional = mean((mappedProcessIntensityFunction(startingSample:end) ...
    - receivedPowerIntensityFunctionGround(startingSample:end)).^2);

mseDirectional = mean((mappedProcessIntensityFunction(startingSample:end) ...
    - receivedPowerIntensityFunction(startingSample:end)).^2);

%% Calculate the SINRs


%% 
% Plot the measured and theoretical intensities of each point
% process for comparison

figure;
plot(powerAxis,mappedProcessIntensityMeasure,'DisplayName',...
    ['Empirical Process Intensity Measure']);
hold on;
plot(powerAxis,receivedPowerIntensityMeasure,'DisplayName',...
    ['Theoretical Process Intensity Measure']);
xlabel('Region [x,\infty]');
ylabel('Intensity measure');

legend(gca,'show','Location','NorthEast');

figure;
semilogy(powerAxis,mappedProcessIntensityFunction,plotFormat(1,'bw'),'DisplayName',...
    ['Empirical Process Intensity Function']);
hold on;
semilogy(powerAxis,receivedPowerIntensityFunctionGround,plotFormat(2,'bw'),'DisplayName',...
    ['Theoretical Process Intensity Function(omnidirectional, MSE = ' num2str(mseOmnidirectional) ')']);
semilogy(powerAxis,receivedPowerIntensityFunction,plotFormat(3,'bw'),'DisplayName',...
    ['Theoretical Process Intensity Function (directional, MSE = ' num2str(mseDirectional) ')'])
xlabel('Region [x,\infty]');
ylabel('Intensity function');

legend(gca,'show','Location','NorthEast');


