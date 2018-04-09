function [R] = par(varargin)
%PAR Equal parallel resistance of elements
%   Examples:
%       R1 = 47; R2 = 68;
%       Rp = par(R1, R2);
%
%       Z1 = 5+j*4;
%       Z2 = 3-j*4;
%       Zp = par(Z1, Z2);
%

R = 1/sum(1./cell2mat(varargin));
