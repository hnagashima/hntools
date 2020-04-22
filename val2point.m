function [point, M] = val2point(x,xval)
% [point, M] = val2point(x,xval)
% This function searches point: x(point) = xval
% x: vector
% xval, value of x (single scaler or vectors)
% point: same size of xval
% M error
point = zeros(size(xval));
M = zeros(size(xval));
xval(xval == Inf) = max(x);
xval(xval == -Inf) = min(x);
for k = 1:length(xval)
    [M(k), point(k)] = min(abs(x-xval(k)));   
end
