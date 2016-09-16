function [ rotatedArrayPattern ] = rotateArrayPattern( originalArrayPattern, rotationAngle )
%ROTATEARRAYPATTERN Summary of this function goes here
%   Detailed explanation goes here

arrayPatternResolution = 360/length(originalArrayPattern);

% round the rotation angle to a multiple of the arrayPatternResolution

rotationAngleToApply = round(rotationAngle/arrayPatternResolution);

% rotate the array pattern by circular shift

rotatedArrayPattern = circshift(originalArrayPattern,[0,rotationAngleToApply]);

end

