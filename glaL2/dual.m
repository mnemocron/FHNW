%**************************************************************************
% \file     dual.m
% \author   Simon Burkhardt
% \brief    
% \details  
% \date     2018-03-01
% \version  1.0
%**************************************************************************
% used functions:   
%                   nargin
%                   power
% input files:      -
% output files:     -
%**************************************************************************
% global variables: -
%**************************************************************************
function [add, sub, mult, div, pow] = dual(a, b)
narginchk(2,2);     % validate input arguments
add =  (a) +  (b);
sub =  (a) -  (b);
mult = (a) .* (b);

% if(b == 0)        % not necessary, since MATLAB returns NaN / Inf
%     div = Inf;
% else
%     div = a./b;
% end

div = (a) /  (b);
pow = power((a), (b));
end
%**************************************************************************




