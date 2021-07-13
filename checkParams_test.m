clc; clear;
% A=load('magicFun');% function mat
% B=load('magicFun_ori');% original mat


A.S = 1/2;
A.g = [2.1 2.2 2.3];
A.A = 1;
A.g1.Frame = [0 2 0];
A.g1.Name = 'test';

B = A;
B.S = 1;
B.g1.Name = [0 0 0];
B.g1 = rmfield(B.g1, 'Frame');
B.g3 = 3;


A.g2 = 2;
checkParams(A,B)