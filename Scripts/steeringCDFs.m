
% Perform D-T weighting of uniform linear array, and determine degree of
% HPBW widening as a function of beam steering angle.

%% Set up paths

addpath('C:\PhD\neighbourDiscovery\Array\');

%% Set up simulation parameters

noElements = 4;

sidelobeAttenuation = 3;

noAngles = 6;

angleResolution = 72;

% Relevant only to the creation of the array - not a parameter in the
% investigation 
% ------------------------------------------------------------------------

frequency = 2.4e9;

wavelength = 3e8/frequency;

antennaSeparation = .6 * wavelength ;

waveNumber = (2*pi)/wavelength;

% ------------------------------------------------------------------------

% Define the angular resolution of the simulation

az = ([0:360]/360) * 2 * pi;
el = ([-90:90]/360) * 2 * pi;

[azGrid,elGrid] = meshgrid(az,el);

% Set up cells to hold the spherical patterns

pattern = cell(1,noAngles);
azPattern = cell(1,noAngles);
cdfRange = cell(1,noAngles);

%% Perform multiple calculations of array pattern

for angleIndex = 1:noAngles
    
    pattern{angleIndex} = zeros(size(azGrid));
    
    % Calculate the degree of phase shifting to apply
    
    steeringAngle = -180 + ((angleIndex-1) * angleResolution)/360 * 2 * pi;
    
    % calculate the D-T weights given level of sidelobe attenuation
    
    weights = dolphTArray(noElements,sidelobeAttenuation);
    
    % apply regular phase shift to antenna weights
    
    weights = weights .* exp(1i*[1:noElements]*steeringAngle);
    
    for antennaIndex = 1:noElements
        
        for elIndex = 1:length(el)
            
            for azIndex = 1:length(az)
                
                pattern{angleIndex}(elIndex,azIndex) = pattern{angleIndex}(elIndex,azIndex) + (weights(antennaIndex) * exp(-1i * waveNumber * (antennaIndex-1) * antennaSeparation * cos(el(elIndex)) * sin(az(azIndex))));
            
            end
            
        end
        
    end
    
end

%% Generate statistical data on performance of antenna array

for angleIndex = 1:noAngles
       
    % Azimuth pattern (el=0) is centre row of pattern matrix
    
    azPattern{angleIndex} = abs(pattern{angleIndex}(ceil(length(el)/2),:));
    
    % Create CDF of the azimuth pattern array factor
    
    [azPatternCDF{angleIndex},cdfRange{angleIndex}] = histcounts(abs(pattern{angleIndex}),100,'Normalization','cdf');

    % Add in P(x<=0) element to CDF so that both vectors align for plotting
    
    azPatternCDF{angleIndex} = [0 azPatternCDF{angleIndex}];
    
end

%% Determine location and width of main lobe

for angleIndex = 1:noAngles
   
    % Determine maximum gain of antenna array from the array CDF
    
    arrayFactorMax(angleIndex) = cdfRange{angleIndex}(end-1);
   
    [mainLobeCentre(angleIndex),mainLobeWidth(angleIndex)] = beamwidth(azPattern{angleIndex},arrayFactorMax(angleIndex)/sqrt(2),(2*pi)/length(az));
      
end

% Azimuth distribution of directivity across beamformers

sumPattern = zeros(1,length(az));

for angleIndex = 1:noAngles
    
    sumPattern = sumPattern + azPattern{angleIndex};

end


%% Plot the results

% Plot the azimuth patterns for the various steering angles

figure;
subplot(1,2,1);
for angleIndex = 1:noAngles
        polar(az,azPattern{angleIndex});
        hold on;
end
title('Azimuth Pattern')

subplot(1,2,2);

polar(az,sumPattern);
hold on;
polar(az,ones(1,length(az))*mean(sumPattern));
title('Sum of beamformers');



% Plot the CDFs for the various steering angles

figure;
hold on;

for angleIndex = 1:noAngles
        plot(cdfRange{angleIndex},azPatternCDF{angleIndex},plotFormat(angleIndex,'bw'),'DisplayName',[num2str(-180 + (angleIndex-1) * angleResolution) '^{\circ} phasing']);
end

legend(gca,'show','Location','NorthWest');

% Plot the graph of main lobe spreading for various steering angles

figure;
hold on;
subplot(2,1,1);
plot((-180+[0:noAngles-1] * angleResolution), mainLobeCentre);
title('Main lobe angle');
xlabel('Angle of phasing (^{\circ})');
ylabel('Angle of deflection (^{\circ})');

subplot(2,1,2);
plot((-180+[0:noAngles-1] * (angleResolution)), mainLobeWidth * 360/(2*pi));
title('Main lobe width');
xlabel('Angle of phasing (^{\circ})');
ylabel('Main Lobe Width (^{\circ})');

