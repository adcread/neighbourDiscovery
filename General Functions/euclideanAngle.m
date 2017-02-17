function [ angle ] = euclideanAngle( point1, point2 )
%EUCLIDEANANGLE Returns the angle in radians between two sets of
%coordinates
%   Detailed explanation goes here

    chord = point2 - point1;
    
    [angle,~] = cart2pol(chord(1),chord(2));
    
    angle = mod(angle+2*pi,2*pi);
    
end

