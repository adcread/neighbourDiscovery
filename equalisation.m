%% Performs simulation of proposed MAC scheme for neighbour discovery - focusing on equalisation

% CHANGELOG

% Date                  Change
% ----                  --------------------------------------------------
% 07/06/16              Created file


%% Include paths to support scripts & functions

addpath('C:\PhD\neighbourDiscovery\General Functions');
addpath('C:\PhD\neighbourDiscovery\Channel');
addpath('C:\PhD\neighbourDiscovery\Encoding');


%% Initialise simulation with the following parameters:

% Wavelength of operation (only affects path loss calculation - must be
% much less than 1m)

wavelength = 3e8/2.4e9;

% Number of users in network

noUsers = 15;

% Size of network (square distance units)

networkSize = 10000;

% Path loss exponent (2 = free space, 3-5 = multipath propagation)

pathLossExponent = 4;

% Number of transmit/receive antennas for each user

txAntennas = 4 * ones(40,1);

rxAntennas = 4 * ones(40,1);

% Length of each sequence in symbol periods

noTraining1Slots = 10;

lengthTraining1 = 64;

noTraining2Slots = 5;

lengthTraining2 = 64;

lengthPayload = 128;

lengthTotal = (lengthTraining1*noTraining1Slots) + (lengthTraining2 * noTraining2Slots) + lengthPayload;

%% Create a set of users in an area using user placement model

% Place users randomly on unit square in 2 dimensions - permits use of
% Euclidean Distance for shadowing modelling

% userLocation = noUsers * [x y]

userLocation = sqrt(networkSize) * rand(noUsers, 2);


%% Create channels between each pair of users

% Measure distance between users using Euclidean Distance

userDistance = zeros(noUsers);

for user = 1:noUsers
    for otherUser = 1:noUsers
        userDistance(user, otherUser) = euclideanDistance(userLocation(user,:),userLocation(otherUser,:));
    end
end

% Assume Gaussian channel model, no antenna correlation. 

H = cell(noUsers);

for user = 1:noUsers
    for otherUser = user:noUsers
        if user ~= otherUser
            H{user,otherUser} = (wavelength/4*pi) * (1/userDistance(user,otherUser))^pathLossExponent * generateChannel(txAntennas(user),rxAntennas(otherUser),'complex');
            H{otherUser,user} = H{user,otherUser}';
        end
    end
end
               
%% Create data structures to hold transmitted signals

training1Symbol = cell(noUsers,1);

training2Symbol = cell(noUsers,1);

payloadSymbol = cell(noUsers,1);

transmittedSignal = cell(noUsers,1);

receivedSignal = cell(noUsers,1);

for user = 1:noUsers
    training1Symbol{user} = zeros(txAntennas(user),lengthTraining1);
    training2Symbol{user} = zeros(txAntennas(user),lengthTraining2);
    payloadSymbol{user} = zeros(txAntennas(user),lengthPayload);
    transmittedSymbol{user} = zeros(txAntennas(user),lengthTotal);
    transmittedSignal{user} = zeros(txAntennas(user),lengthTotal);
    receivedSignal{user} = zeros(rxAntennas(user),lengthTotal);   
end


%% First training period

% Select which users transmit in which slot - randomised

training1SlotAssignment = zeros(1,noUsers);

for user = 1:noUsers
    training1SlotAssignment(user) = randi(noTraining1Slots);
end

% Create training sequences for each user

training1Sequence = cell(noUsers,1);

for user = 1:noUsers
    training1Sequence{user} = randi(4,txAntennas(user),lengthTraining1);
end

% Encode training sequences into modulation scheme

for user = 1:noUsers
    for training1Slot = 1:noTraining1Slots
        if (training1Slot == training1SlotAssignment(user))
            transmittedSymbol{user}(:,(lengthTraining1*(training1Slot-1))+1:(lengthTraining1*training1Slot)) = training1Sequence{10};
        end
    end   
end

for user = 1:noUsers
    transmittedSignal{user} = modulationScheme(transmittedSymbol{user},4);
end

% Users transmit sequences

for user = 1:noUsers
    for otherUser = 1:noUsers
        if user ~= otherUser
            receivedSignal{user} = receivedSignal{user} + H{otherUser,user} * transmittedSignal{otherUser};
        end
    end
end

%% Detection of users and SINR estimation for uncoded transmission

% Estimate SINR of strongest signal

% 


%% Precoder calculation


%% Second training period


%% SINR estimation for precoded transmission


%% MST Creation


%% Data transmission

