function [point, M] = val2point(x,xval)
% [point, M] = val2point(x,xval)
% val2point searches an index (point) which matches: x(point) = xval
%
% #Inputs:
% x: vector
% xval: value of x (single scaler or vectors)
%
% #Outputs:
% point: same size of xval
% M: error. M = x(point) - xval.
point = zeros(size(xval));
M = zeros(size(xval));
xval(xval == Inf) = max(x);
xval(xval == -Inf) = min(x);
for k = 1:length(xval)
    [M(k), point(k)] = min(abs(x-xval(k)));   
end
