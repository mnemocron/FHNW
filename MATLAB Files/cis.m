%CIS Complex number in the Cos + i * Sin notation
%
%   [complex] = cis(phi, unit)
%   Returns a complex number with a magnitude of 1 and an argument of phi.
%
%   phi       [-]    	Angle of complex number in degrees or radians
%   unit      [-]       String of the angles unit: 'deg' or 'rad'
%
%
%   See also: 
%   S. Burkhardt, Apr-2018

function [comp] = cis(phi, unit)
    if ( strcmp(unit, 'grad') || strcmp(unit, 'deg') || strcmp(unit, '°') )
        comp = 1*exp(j* deg2rad(phi));
    end
    if ( strcmp(unit, 'radiant') || strcmp(unit, 'radians') || strcmp(unit, 'rad') || strcmp(unit, 'r') )
        comp = 1*exp(j* phi);
    end
end
