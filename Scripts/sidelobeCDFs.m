
% Perform D-T weighting of uniform linear array, and determine degree of
% HPBW widening as a function of sidelobe suppression.

%% Set up paths

addpath('C:\PhD\neighbourDiscovery\Array\');

%% Set up simulation parameters

noElements = 5;

noSuppressionLevels = 4;

% Relevant only to the creation of the array - not a parameter in the
% investigation 
% ------------------------------------------------------------------------

frequency = 2.4e9;

wavelength = 3e8/frequency;

antennaSeparation = .5 * wavelength ;

waveNumber = (2*pi)/wavelength;

% ------------------------------------------------------------------------

% Define the angular resolution of the simulation

az = ([0:360]/360) * 2 * pi;
el = ([-90:90]/360) * 2 * pi;

% Set up cells to hold the spherical patterns

pattern = cell(1,noSuppressionLevels);
azPattern = cell(1,noSuppressionLevels);

%% Perform multiple calculations of array pattern

for levelIndex = 1:noSuppressionLevels
       
    % Calculate the level of sidelobe suppression to apply
    
    sidelobeAttenuation = 3*(levelIndex-1);
    
    % calculate the D-T weights given level of sidelobe attenuation
    
    weights = dolphTArray(noElements,sidelobeAttenuation);
        
    pattern{levelIndex} = generateAntennaPattern(az,el,weights,waveNumber,antennaSeparation);
        
end


%% Capture the azimuth radiation patterns

for levelIndex = 1:noSuppressionLevels
       
    % Azimuth pattern (el=0) is centre row of pattern matrix
    
    azPattern{levelIndex} = abs(pattern{levelIndex}(ceil(length(el)/2),:));
    
    % Create CDF of the azimuth pattern array factor
    
end


%% Generate statistical data on performance of antenna array

% Find the largest value of array gain for all beamformers, use this to
% create the histogram bins

maxArrayGain = 1;

for levelIndex = 1:noSuppressionLevels
    
    maxArrayGain = max(maxArrayGain,max(azPattern{levelIndex}));
    
end

cdfRange = linspace(0,maxArrayGain,100);

for levelIndex = 1:noSuppressionLevels
    
    azPatternCDF{levelIndex} = histcounts(azPattern{levelIndex},cdfRange,'Normalization','cdf');

    % Add in P(x<=0) element to CDF so that both vectors align for plotting
    
    azPatternCDF{levelIndex} = [0 azPatternCDF{levelIndex}];
    
end

%% Determine location and width of main lobe

% for levelIndex = 1:noSuppressionLevels
%    
%     % Determine maximum gain of antenna array from the array CDF
%     
%     arrayFactorMax(levelIndex) = cdfRange(end-1);
%    
%     [mainLobeCentre(levelIndex),mainLobeWidth(levelIndex)] = beamwidth(azPattern{levelIndex},arrayFactorMax(levelIndex)/sqrt(2),(2*pi)/length(az));
%       
% end
% 
% % Azimuth distribution of directivity across beamformers
% 
% sumPattern = zeros(1,length(az));
% 
% for levelIndex = 1:noSuppressionLevels
%     
%     sumPattern = sumPattern + azPattern{levelIndex};
% 
% end


%% Plot the results

% Plot the azimuth patterns for the various sidelobe suppression levels

figure;

for levelIndex = 1:noSuppressionLevels
        polar(az,azPattern{levelIndex});
        hold on;
end
title('Azimuth Pattern')




% Plot the CDFs for the various steering angles

figure;
hold on;

for levelIndex = 1:noSuppressionLevels
        plot(cdfRange,azPatternCDF{levelIndex},plotFormat(levelIndex,'bw'),'DisplayName',[num2str(3*(levelIndex-1)) ' dB suppression']);
end

legend(gca,'show','Location','NorthWest');


