%**************************************************************************
% \file     hex2dez.m
% \author   Simon Burkhardt
% \brief    wandelt eine hexadezimalzahl in dezimal um
% \details  
% \date     2018-03-01
% \version  1.0
%**************************************************************************
% used functions:   
%                   isfloat
%                   isstring
%                   ischar
%                   length
%                   contains
%                   strfind
%                   power
%                   narginchk
% input files:      -
% output files:     -
%**************************************************************************
% global variables: -
%**************************************************************************
function [ dez ] = hex2dez( hex )
%    dez = hex2dec( hex );
    narginchk(1,1);     % validate input arguments
    if(isfloat(hex))    % not working, on hex2dec doesn't either
        hex=int2str(hex);
    end
    dez = 0;
    if(isstring(hex))
        hex = char(hex);
    end
    if(ischar(hex))
        n = length(hex);
        for k = 1:n
            if( ~contains('0123456789abcdef', hex(n-(k-1))) )
                error("Input to hex2dec should have just 0-9, a-f, or A-F.");
            else
                dez = dez + power(16, k-1)*(strfind('0123456789abcdef', hex(n-(k-1)))-1);
            end
        end
    else
        error("Input argument is not of type int / string / char.");
    end
end 
%**************************************************************************

