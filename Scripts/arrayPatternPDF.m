% Plot the PDF of the gain experienced by randomly-aligned antenna arrays

%% State the parameters of the gain function

directivity = 0.7;

noLobes = 5;

%% Comopute the empirical PDF of the gain

gainAxis = linspace(0,2,360);

% Create 1000 instances of random alignment

angle = 2 * pi * rand(1,1e6);

% Determine the gain exprienced at the receiver

empiricalGain = 1 + directivity * cos (noLobes * angle);

% Compute the empirical PDF of the gains

empiricalDensity = hist(empiricalGain,gainAxis);

%% Calculate the PDF of the gain from prob theory

% Determine the solutions to the inverse of the gain function for range
% [1-d,1+d]

x1 = acos((gainAxis-1)./ directivity) / noLobes;

% Remove non-real solutions to x1 and set to invalid (NaN)

x1(find(imag(x1)~=0)) = NaN;

x2 = 2*pi/noLobes - acos((gainAxis-1)./ directivity) / noLobes;

% Remove non-real solutions to x1 and set to invalid (NaN)

x2(find(imag(x2)~=0)) = NaN;

probDensity = (noLobes/(2*pi)) * (1./abs(-noLobes * directivity * sin(noLobes * x1)) + 1./abs(-noLobes * directivity * sin(noLobes * x2)));

%% Plot the antenna pattern for context

thetaAxis = linspace(0,2*pi,360);

antennaPattern = 1 + directivity * cos(noLobes * thetaAxis);

figure;

subplot(1,2,1);

polar(thetaAxis,antennaPattern);

title('Antenna Array Radiation Pattern');

%% Plot the resulting PDFs on the same graph

dGain = diff(gainAxis(1:2));

subplot(1,2,2);

bar(gainAxis, empiricalDensity/sum(empiricalDensity * dGain));

hold on;

plot(gainAxis, probDensity);


