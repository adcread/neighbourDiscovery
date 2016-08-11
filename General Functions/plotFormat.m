function [ formatDefString ] = plotFormat( plotIndex, colorSwitch )
%PLOTFORMAT Returns a string that defines the formatting for a plot with a
%given index - permits use of colour and b&w printing.
%   Detailed explanation goes here

lineDef = {'-','--',':','-.'};

markerDef = [' ' '+' 'o' '*' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'];

colorDef = ['r' 'g' 'b' 'c' 'm' 'y' 'k'];

if strcmp(colorSwitch,'color')
    
    
elseif strcmp(colorSwitch,'bw')
    
    lineIndex = floor((plotIndex-1)/13) + 1;
    
    lineSpec = lineDef{lineIndex};
    
    markerIndex = mod(plotIndex-1,13);
    
    markerSpec = markerDef(markerIndex+1);
    
    colorSpec = 'k';
    
end

formatDefString = strcat(lineSpec,markerSpec,colorSpec);

end

