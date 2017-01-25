function [ dummy ] = drawArrow( xRange, yRange, location, angle, arrowLength)
%DRAWARROW Summary of this function goes here
%   Detailed explanation goes here

x1 = location(1) + xRange;

x2 = x1 + arrowLength*cos(angle);

y1 = location(2) + yRange;

y2 = y1 + arrowLength*sin(angle);

xParameter = [x1 x2]/(2*xRange);

yParameter = [y1 y2]/(2*yRange);

annotation('arrow',xParameter,yParameter);

end

