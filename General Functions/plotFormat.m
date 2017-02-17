function [ formatDefString ] = plotFormat( plotIndex, colorSwitch )
%PLOTFORMAT Returns a string that defines the formatting for a plot with a
%given index - permits use of colour and b&w printing.
%   Detailed explanation goes here

lineDef = {'-','--',':','-.'};

markerDef = [' ' '+' 'o' '*' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'];

colorDef = ['r' 'g' 'b' 'c' 'm' 'y' 'k'];

if strcmp(colorSwitch,'c')
    
    colorIndex = floor((plotIndex-1)/7) + 1;
    
    lineIndex = mod(plotIndex-1,7) + 1;
    
    lineSpec = lineDef{lineIndex};
    
    colorSpec = colorDef(colorIndex);
    
    markerSpec = markerDef(1);
    
elseif strcmp(colorSwitch,'bw')
    
    markerIndex = mod(plotIndex-1,13) + 1 ;
    
    lineIndex = floor((plotIndex-1)/13) + 1;
    
    colorSpec = 'k';
               
    markerSpec = markerDef(markerIndex+1);
    
    lineSpec = lineDef{lineIndex};

end

formatDefString = strcat(lineSpec,markerSpec,colorSpec);

end

