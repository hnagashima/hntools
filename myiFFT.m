function [time, td] = myiFFT(x,y, varargin)
% [time, td] = myiFFT(x,y) % perform inverse Fourier transformation
%
% - x : x-value (vector)
% - y : FT data. (vector or matrix)
%
% - x
% time 
narginchk(2,4);

% dt = 1/Fs;

% Inputs
if numel(varargin) >= 1
    % First term is N
    NFFT = varargin{1};
else
    NFFT = numel(x);
end

% fftshiftをする.
if numel(varargin) >= 2
    % second term is DIM

    y2 = ifftshift(y, varargin{2});
else
    y2 = ifftshift(y);
    
end

td = ifft(y2, varargin{:});

dt = abs(1/(x(2) - x(1)));
time = (0 : (NFFT-1) ) * dt;