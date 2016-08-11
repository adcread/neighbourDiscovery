function [ beamCentre, beamwidth ] = beamwidth( radiationPattern, threshold, angularResolution )
    %BEAMWIDTH Summary of this function goes here
    %   Detailed explanation goes here

    searchField = find(radiationPattern > threshold);

    diffSearchField = diff(searchField);
       
    upperBound = ceil(length(searchField)/2.5);
    lowerBound = upperBound;

    % step the upper bound up by 1, testing for continuity

    while (diffSearchField(upperBound) == 1) && (upperBound < length(diffSearchField))

        upperBound = upperBound + 1;

    end

    % step the lower bound down by 1, testing for continuity

    while (diffSearchField(lowerBound) == 1) && (lowerBound > 1)

        lowerBound = lowerBound - 1;

    end

    % back off by one to limit of continuity
    
    lowerBound = lowerBound + 1;

    beamCentre = ceil(( searchField(upperBound) + searchField(lowerBound) ) / 2);
    
    % beamwidth in radians
    
    beamwidth = (upperBound - lowerBound) * angularResolution;
    
end

