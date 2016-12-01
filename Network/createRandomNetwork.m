function [ location, orientation ] = createRandomNetwork( networkRadius, networkDensity, domainShape)
%CREATERANDOMNETWORK Creates a set of marked nodes with PPP in given domain.
%   Detailed explanation goes here

numberOfUsers = poissrnd(networkDensity*(networkRadius*2)^2);

location = unifrnd(-networkRadius,networkRadius,numberOfUsers,2);

orientation = unifrnd(0,360,numberOfUsers,1);

if domainShape == 'disc'
    
    % If domain is a disc of radius x, delete all elements for which  d > x
    
    for i = 1:length(orientation)
       
        distance(i) = euclideanDistance(location(i,:),[0 0]);

    end
    
    retentionVector = find(distance <= networkRadius);
    
    location = location(retentionVector,:);
    orientation = orientation(retentionVector);
    
elseif domainShape == 'square'
    
end

end

