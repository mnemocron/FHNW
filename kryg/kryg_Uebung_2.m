%******************************************************************************
% \details     : kryg 
% \autor       : Simon Burkhardt
% \file        : kryg_Uebung_2.m
% \date        : 01.03.2020
% \version     : 1.0
%******************************************************************************
clear all; close all; clc; format shorteng;

% permuted choice
PC1_C = [57 49 41 33 25 17 9 1 58 50 42 34 26 18 10 2 59 51 43 35 27 19 11 3 60 52 44 36];
PC1_D = [63 55 47 39 31 23 15 7 62 54 46 38 30 22 14 6 61 53 45 37 29 21 13 5 28 20 12 4];

PC2 = [14 17 11 24 1 5 3 28 15 6 21 10 23 19 12 4 26 8 16 7 27 20 13 2 41 52 31 37 47 55 30 40 51 45 33 48 44 49 39 56 34 53 46 42 50 36 29 32];

%%
KEY = zeros(64,1);

% Permute Choice 1
C0 = zeros(28,1);
for k=1:28
    C0(k) = KEY(PC1_C(k));
end

D0 = zeros(28,1);
for k=1:28
    D0(k) = KEY(PC1_D(k));
end

% see Table for number of left shifts per Iteration Number
C1 = circshift(C0, 1);
D1 = circshift(D0, 1);

K1 = zeros(28,1);
for k=1:28
    D0(k) = KEY(PC1_D(k));
end

%%

INPUT = ones(64,1);

% Initial Permutation
IP = [58 50 42 34 26 18 10 2 60 52 44 36 28 20 12 4 62 54 46 38 30 22 14 6 64 56 48 40 32 24 16 8 57 49 41 33 25 17 9 1 59 51 43 35 27 19 11 3 61 53 45 37 29 21 13 5 63 55 47 39 31 23 15 7];

IN_L = zeros(32,1);
IN_R = zeros(32,1);
for k=1:32
    IN_L(k) = INPUT(IP(k));
    IN_R(k) = INPUT(IP(k+32));
end
% Permuted Input
L0 = IN_L;
R0 = IN_R;

L1 = R0;
L1 = zeros(32,1);

% f(R0, K1) + L1
% Expansion Matrix
E = [32 1 2 3 4 5 4 5 6 7 8 9 8 9 10 11 12 13 12 13 14 15 16 17 16 17 18 19 20 21 20 21 22 23 24 25 24 25 26 27 28 29 28 29 30 31 32 1];

% expand R0
R0_e = zeros(48,1);
for k=1:48
    R0_e(k) = R0(E(k));
end
% add R (+) K
R_K = zeros(48,1);
for k=1:48
    R_K(k) = mod( R0_e(k) + K1(k) , 2)
end

%%
% Substitution Block
S1 = [14 4 13 1 2 15 11 8 3 10 6 12 5 9 0 7;
      0 15 7 4 14 2 13 1 10 6 12 11 9 5 3 8
      4 1 14 8 13 6 2 11 15 12 9 7 3 10 5 0
      15 12 8 2 4 9 1 7 5 11 3 14 10 0 6 13];

% S1(B) where B = [0 1 2 3 4 5]
% then row address = [0 5]     = i
% then col address = [1 2 3 4] = j
% select S1(i, j)

for k=1:8
    B = R_K( (k-1)*6+1 : k*6 );
    ii = [B(1), B(6)];
    jj = [ B(2), B(3), B(4), B(5) ];
    i = ii(1)*2 + ii(2) + 1;
    j = jj(1)*8 + jj(2)*4 + jj(3)*2 + jj(4) +1;
    out = dec2bin(S1(i, j) ) == '1'
end

