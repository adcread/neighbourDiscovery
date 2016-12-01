function [ azimuthPattern ] = azimuthPattern( pattern, elevationAngle)
%AZIMUTHONLY Summary of this function goes here
%   Detailed explanation goes here

    noElevationElements = size(pattern,2);
    
    azimuthPattern = pattern((elevationAngle + 91),:);   
    
end

