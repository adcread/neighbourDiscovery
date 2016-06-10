function [ outputSignal ] = modulationScheme( inputSymbol, M )
%MODULATIONSCHEME Summary of this function goes here
%   Detailed explanation goes here

[noStreams, noSymbols] = size(inputSymbol);

outputSignal = zeros(noStreams,noSymbols);

for symbol = 1:noSymbols
    for stream = 1:noStreams
        if inputSymbol(stream,symbol) ~= 0
        outputSignal(stream,symbol) = qammod(inputSymbol(stream,symbol)-1,M);
        end
    end
end

end

