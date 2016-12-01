% Scans the beamformer around a MIMO-enabled user.

% elements = 12;

frequency = 2.4e9;

wavelength = 3e8/frequency;

antennaSeparation = 0.5 * wavelength ;

%sidelobeAttenuation = 6;

waveNumber = (2*pi)/wavelength;

%weights = dolphTArray(elements,sidelobeAttenuation);

az = ([0:360]/360) * 2 * pi;
el = ([-90:90]/360) * 2 * pi;

[azGrid,elGrid] = meshgrid(az,el);
 
pattern = zeros(size(azGrid));

for antennaIndex = 1:elements
    for elIndex = 1:length(el)
        for azIndex = 1:length(az)
            pattern(elIndex,azIndex) = pattern(elIndex,azIndex) + (weights(antennaIndex) * exp(-1i * waveNumber * (antennaIndex-1) * antennaSeparation * cos(el(elIndex)) * sin(az(azIndex))));
        end
    end
end

patternNormFactor = max(abs(pattern(91,:)));

logAzPolarPattern = 10*log10(pattern(91,:)/patternNormFactor);



% [patternX, patternY, patternZ] = sph2cart(azGrid,elGrid,pattern);
% 
% figure;
% plot3dPattern = mesh(real(patternX),real(patternY),real(patternZ));
% title('3D antenna radiation pattern');
% 
% figure;
% plotAzPattern = plot(az*360/(2*pi),((pattern(91,:))/patternNormFactor));
% title('Azimuth array radiation pattern');
% xlabel('\theta');
% ylabel('Array factor (dB)')
% 
% 
% figure;
% plotAzPolarPattern = polar(az,20*log10(abs(pattern(91,:))/patternNormFactor));
% title('Azimuth array radiation pattern');
% ylabel('Array factor (dB)')
% 

[azPatternCDF, cdfRange] = histcounts(abs(pattern(91,:)),360,'Normalization','cdf');

% figure;
% plotCdf = plot(cdfRange,azPatternCDF);
% title('Azimuth array factor CDF');
% xlabel('X');
% ylabel('F_{E}(x)');

