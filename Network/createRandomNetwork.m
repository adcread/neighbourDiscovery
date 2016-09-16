function [ locationX, orientation ] = createRandomNetwork( networkRadius, networkDensity )
%CREATERANDOMNETWORK Summary of this function goes here
%   Detailed explanation goes here

numberOfUsers = poissrnd(networkDensity*(networkRadius*2)^2);

locationX = unifrnd(-networkRadius,networkRadius,numberOfUsers,2);

orientation = unifrnd(0,360,numberOfUsers,1);

end

