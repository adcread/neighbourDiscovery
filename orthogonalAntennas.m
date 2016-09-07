
% Perform orthogonal base-derived weighting of uniform linear array, and
% determine CDF of transmitted signals

%% Set up paths

addpath('C:\PhD\neighbourDiscovery\Array\');
addpath('C:\PhD\neighbourDiscovery\General Functions\');

%% Set up simulation parameters

noElementsRange = 9;
noCDFPoints = 50;

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

pattern = cell(noElementsRange,noElementsRange);
azPattern = cell(noElementsRange,noElementsRange);
azPatternSum = cell(noElementsRange,1);

cdfRange = cell(noElementsRange,noElementsRange);
azPatternCDF = cell(noElementsRange,noElementsRange);
azPatternCDFSum = cell(noElementsRange,1);

%% Perform calculation of array pattern

for noElementsIndex = 1:noElementsRange

    for baseIndex = 1:noElementsIndex

        pattern{noElementsIndex,baseIndex} = zeros(size(azGrid));

        % calculate the weights and phasing angles to steer the lobes

        weights = 1/(sqrt(noElementsIndex)) * exp(baseIndex*[0:noElementsIndex-1]*-1i*2*pi/noElementsIndex);

        for antennaIndex = 1:noElementsIndex

            for elIndex = 1:length(el)

                for azIndex = 1:length(az)

                    pattern{noElementsIndex,baseIndex}(elIndex,azIndex) = pattern{noElementsIndex,baseIndex}(elIndex,azIndex) + (weights(antennaIndex) * exp(-1i * waveNumber * (antennaIndex-1) * antennaSeparation * cos(el(elIndex)) * sin(az(azIndex))));

                end

            end

        end
        
    end
    
end


%% Generate statistical data on performance of antenna array

for noElementsIndex = 1:noElementsRange

    for baseIndex = 1:noElementsIndex

        % Azimuth pattern (el=0) is centre row of pattern matrix

        azPattern{noElementsIndex,baseIndex} = abs(pattern{noElementsIndex,baseIndex}(ceil(length(el)/2),:));

        % Normalise azimuth pattern to the largest gain measured
        
%         maxGain(noElementsIndex,baseIndex) = max(azPattern{noElementsIndex,baseIndex});
        
%         azPattern{noElementsIndex,baseIndex} = azPattern{noElementsIndex,baseIndex}/maxGain(noElementsIndex,baseIndex);
        
        % Create CDF of the azimuth pattern array factor

        [azPatternCDF{noElementsIndex,baseIndex},cdfRange{noElementsIndex,baseIndex}] = histcounts(azPattern{noElementsIndex,baseIndex},noCDFPoints,'Normalization','cdf');

        % Add in P(x<=0) element to CDF so that both vectors align for plotting

        azPatternCDF{noElementsIndex,baseIndex} = [0 azPatternCDF{noElementsIndex,baseIndex}];

    end

end


%% Combine beamformer patterns to create sum pattern and calculate sum CDF as well.

for noElementsIndex = 1:noElementsRange
    
    azPatternSum{noElementsIndex} = zeros(1,length(az));
    azPatternCDFSum{noElementsIndex} = zeros(size(azPatternCDF{noElementsIndex,1}));
    
    for baseIndex = 1:noElementsIndex

        azPatternSum{noElementsIndex} = azPatternSum{noElementsIndex} + azPattern{noElementsIndex,baseIndex};
        azPatternCDFSum{noElementsIndex} = azPatternCDFSum{noElementsIndex} + azPatternCDF{noElementsIndex,baseIndex}/noElementsIndex;
        
    end

end


%% Plot the results

% Plot the azimuth patterns for the various sidelobe suppression levels

figure;

for noElementsIndex = 1:noElementsRange
    
    subplot(3,3,noElementsIndex);
    hold on;
    title([num2str(noElementsIndex) ' Antennas']);
    
    for baseIndex = 1:noElementsIndex
        polar(az,azPattern{noElementsIndex,baseIndex});
    end
    
end

figure;

for noElementsIndex = 1:noElementsRange
    
    subplot(3,3,noElementsIndex);
    hold on;
    title([num2str(noElementsIndex) ' Antennas']);
    polar(az,azPatternSum{noElementsIndex});
    
end


% Plot the CDFs for the various steering angles

figure;
hold on;

for noElementsIndex = 2:noElementsRange
        plot(cdfRange{noElementsIndex},azPatternCDF{noElementsIndex},plotFormat(noElementsIndex-1,'bw'),'DisplayName',[num2str(noElementsIndex) ' antennas']);
end

legend(gca,'show','Location','NorthWest');
title('Combined Beamformer CDFs');
xlabel('Antenna Gain (x)');
ylabel('Probability (P_{x})');


