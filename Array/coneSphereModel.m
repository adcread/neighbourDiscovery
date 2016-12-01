function [ theta, antennaPattern ] = coneSphereModel( mainlobeWidth, mainlobeLevel, sidelobeLevel, angularResolution )
%CONESPHEREMODEL Creates the 'cone plus sphere' antenna array pattern with defined angular resolution
%   Detailed explanation goes here

    patternLength = 360/angularResolution;
    
    theta = linspace(0,2*pi,patternLength);
    
    antennaPattern = ones(1,patternLength) * sidelobeLevel;
    
    antennaPattern(1:round(mainlobeWidth/(2*angularResolution))) = mainlobeLevel;

    antennaPattern(patternLength-round(mainlobeWidth/(2*angularResolution)):patternLength) = mainlobeLevel;

end

