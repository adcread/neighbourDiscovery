% Create a PPP to generate the locations and orientations of the network,
% then sort the nodes by distance from the origin

%% Set up environment variables and delete variables used in this simulation
% that might change dimension due to PPP

origin = [0 0];

clear nodeLocation;
clear nodeOrientation;
clear nodeToBeSorted;
clear nodeSorted;

%% Create random network

% Create a list of unsorted node locations (x,y coordinates) and
% orientations of Uniform Linear Array (ULA) posessed by each node



