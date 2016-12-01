function [ outputPattern ] = generateAntennaPattern(az, el, weights, waveNumber, antennaSeparation)
%GENERATEANTENNAPATTERN Summary of this function goes here
%   Detailed explanation goes here

    noAntennas = length(weights);

    % Create combined spherical coordinate grids

    [azGrid,~] = meshgrid(az,el);
    
    outputPattern = zeros(size(azGrid));
    
    for antennaIndex = 1:noAntennas

        for elIndex = 1:length(el)

            for azIndex = 1:length(az)

                outputPattern(elIndex,azIndex) = outputPattern(elIndex,azIndex) + (weights(antennaIndex) * exp(-1i * waveNumber * ((noAntennas-1)/2 + (antennaIndex-1)) * antennaSeparation * cos(el(elIndex)) * sin(az(azIndex))));

            end

        end

    end

end

