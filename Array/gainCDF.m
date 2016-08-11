function [ cdf,scale ] = gainCDF( azimuthPattern, resolution )
%GAINCDF Summary of this function goes here
%   Detailed explanation goes here

azPatternHist = hist(abs(azimuthPattern),resolution);

scale = linspace(0,max(abs(azimuthPattern)),resolution);

cdf = zeros(1,resolution);
cdf(1) = azPatternHist(1);

for histIndex = 2:resolution
    cdf(histIndex) = cdf(histIndex-1) + azPatternHist(histIndex);
end

cdf = cdf/length(azimuthPattern);

end

