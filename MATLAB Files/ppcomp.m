%PPCOMP Pretty-print a complex number.
%
%   [str] = ppcomp(c)
%   [str] = ppcomp(c, symbol, unit)
%   [str] = ppcomp(U1, 'U1', 'Volts')
%   Returns a string with a pretty printed complex number c.
%
%   phi       [-]    	Angle of complex number in degrees or radians
%   unit      [-]       String of the angles unit: 'deg' or 'rad'
%
%
%   See also: 
%   S. Burkhardt, Apr-2018

function [ans] = ppcomp(varargin)
    if nargin > 2
        unit = varargin{3};
    else
        unit = '';
    end
    
    if nargin > 1
        title = varargin{2};
    else
        title = 'Comp';
    end
    
    ans = strcat(title, " = ", num2str(abs(varargin{1})), " ", unit, " cis( ", num2str(rad2deg(angle(varargin{1}))), "° )");
end

