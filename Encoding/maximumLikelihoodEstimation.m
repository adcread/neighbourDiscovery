function [ output, decision ] = maximumLikelihoodEstimation( input, symbolSet )
%MAXIMUMLIKELIHOODESTIMATION Performs ML detection, returning index of most likely symbol from the symbol set
%   Detailed explanation goes here

likelihood = zeros(1,length(symbolSet));

for candidate = 1:length(symbolSet)
   likelihood(candidate) = 1/((symbolSet(candidate) - input)^2);
end

% Find the most likely symbol from the set

[~,decision] = max(likelihood);

% Return the perfect symbol 
output = symbolSet(decision);

end

