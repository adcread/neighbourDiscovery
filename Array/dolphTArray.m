function [ weights ] = dolphTArray( elements, sidelobeAtten )
%DOLPHTARRAY Calculates the Dolph-Tschebycheff array weights for a desired attenuation
%   Usage: weights = dolphTArray(elements, sidelobeAtten)
%
%   elements      = number of antenna elements
%   sidelobeAtten = desired attenuation of sidelobes (cf to main lobe) 

if (nargin ~= 2)
    help dolphTArray;
    return;
end

mainLobeGain = 10^(sidelobeAtten/20);

scaleFactor = cosh(acosh(mainLobeGain)/(elements-1));

i = 1:(elements-1);

x = cos(pi*(i-0.5)/(elements-1));
psi = 2 * acos(x/scaleFactor);
z = exp(1i*psi);

weights = real(poly(z));

weights = weights/max(weights);

end

