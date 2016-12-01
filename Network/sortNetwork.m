function [ sortedNodeLocation, sortedNodeOrientation ] = sortNetwork( nodeLocation, nodeOrientation, referencePoint )
%SORTNETWORK Sorts the elements of the network by distance from arbitrary point.
%   Detailed explanation goes here

noNodes = length(nodeOrientation);

nodeDistance = zeros(noNodes,1);

for nodeIndex = 1:noNodes
    
    nodeDistance(nodeIndex) = euclideanDistance(referencePoint,nodeLocation(nodeIndex,:));
    
end

%% Concatenate the information together so it can be sorted by distance

nodeSorted = sortrows([nodeLocation nodeOrientation nodeDistance],4);

sortedNodeLocation = nodeSorted(:,1:2);

sortedNodeOrientation = nodeSorted(:,3);
end

