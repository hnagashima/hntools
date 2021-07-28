function [unique_val, counts] = uniquecount(A , varargin)
% Return unique values and count it.
%  [unique_val, counts] = uniquecount(A)
%

[counts, unique_val] = hist(A, unique(A, varargin{:}));