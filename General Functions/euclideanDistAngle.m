function [ euclideanDistance, euclideanAngle ] = euclideanDistAngle( startPosition, endPosition )
%EUCLIDEANDISTANGLE Summary of this function goes here
%   Detailed explanation goes here

if (length(startPosition) == 2) && (length(endPosition) > 2)
       
    startPosition = repmat(startPosition,length(endPosition),1);
end

chord = endPosition - startPosition;

[euclideanAngle,euclideanDistance] = cart2pol(chord(:,1),chord(:,2));

euclideanAngle = mod(euclideanAngle+2*pi,2*pi);

end

