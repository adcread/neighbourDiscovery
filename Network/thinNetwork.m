function [ thinnedNodeLocation, thinnedNodeOrientation ] = thinNetwork( nodeLocation, nodeOrientation, thinningProbability, nodesToPreserve)
%THINNETWORK 'thins' the node location point process with given probability
%   Detailed explanation goes here

% create a vector of random values to use as the ALOHA thinning random
% variable

if nodesToPreserve
    thinningVector = 1:nodesToPreserve;
else
    thinningVector = [];
end

thinningVector = [thinningVector find(rand(1, length(nodeLocation-nodesToPreserve))>(1-thinningProbability))];

thinnedNodeLocation = nodeLocation(thinningVector,:);
thinnedNodeOrientation = nodeOrientation(thinningVector);

end

