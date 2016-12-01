
% Perform orthogonal base-derived weighting of uniform linear array, and
% determine CDF of transmitted signals

%% Set up paths

addpath('C:\PhD\neighbourDiscovery\Array\');
addpath('C:\PhD\neighbourDiscovery\General Functions\');

%% Set up simulation parameters

noElements = 3;

% Relevant only to the creation of the array - not a parameter in the
% investigation 
% ------------------------------------------------------------------------

frequency = 2.4e9;

wavelength = 3e8/frequency;

antennaSeparation = .65 * wavelength ;

waveNumber = (2*pi)/wavelength;

% ------------------------------------------------------------------------

% Define the angular resolution of the simulation

az = ([0:360]/360) * 2 * pi;
el = ([-90:90]/360) * 2 * pi;

[azGrid,elGrid] = meshgrid(az,el);

% Set up cells to hold the spherical patterns

pattern = cell(1,noElements);
azPattern = cell(1,noElements);
cdfRange = cell(1,noElements);

%% Perform calculation of array pattern

for baseIndex = 1:noElements

    pattern{baseIndex} = zeros(size(azGrid));

    % calculate the weights and phasing angles to steer the lobes

    weights(baseIndex,:) = 1/(sqrt(noElements)) * exp(baseIndex*[0:noElements-1]*-1i*2*pi/noElements);

    for antennaIndex = 1:noElements

        for elIndex = 1:length(el)

            for azIndex = 1:length(az)

                pattern{baseIndex}(elIndex,azIndex) = pattern{baseIndex}(elIndex,azIndex) + (weights(baseIndex,antennaIndex) * exp(-1i * waveNumber * (antennaIndex-1) * antennaSeparation * cos(el(elIndex)) * sin(az(azIndex))));

            end

        end

    end
    
end

%% Generate statistical data on performance of antenna array

for baseIndex = 1:noElements
       
    % Azimuth pattern (el=0) is centre row of pattern matrix
    
    azPattern{baseIndex} = abs(pattern{baseIndex}(ceil(length(el)/2),:));
    
    % Create CDF of the azimuth pattern array factor
    
    [azPatternCDF{baseIndex},cdfRange{baseIndex}] = histcounts(azPattern{baseIndex},100,'Normalization','cdf');

    % Add in P(x<=0) element to CDF so that both vectors align for plotting
    
    azPatternCDF{baseIndex} = [0 azPatternCDF{baseIndex}];
    
end

%% Determine location and width of main lobe

for baseIndex = 1:noElements
   
    % Determine maximum gain of antenna array from the array CDF
    
    arrayFactorMax(baseIndex) = cdfRange{baseIndex}(end-1);
   
    [mainLobeCentre(baseIndex),mainLobeWidth(baseIndex)] = beamwidth(azPattern{baseIndex},arrayFactorMax(baseIndex)/sqrt(2),(2*pi)/length(az));
      
end

% Azimuth distribution of directivity across beamformers

sumPattern = zeros(1,length(az));

for baseIndex = 1:noElements
    
    sumPattern = sumPattern + azPattern{baseIndex};

end


%% Plot the results

% Plot the azimuth patterns for the various sidelobe suppression levels

figure;
subplot(1,2,1);
for baseIndex = 1:noElements
    polar(az,azPattern{baseIndex});
    hold on;
end
title('Azimuth Pattern')

subplot(1,2,2);
polar(az,sumPattern/noElements);
title('Sum pattern over beamformers');

% Plot the CDFs for the various steering angles

figure;
hold on;

for baseIndex = 1:noElements
        plot(cdfRange{baseIndex},azPatternCDF{baseIndex},plotFormat(baseIndex,'bw'),'DisplayName',['Beamformer ' num2str(baseIndex)]);
end

legend(gca,'show','Location','NorthWest');


