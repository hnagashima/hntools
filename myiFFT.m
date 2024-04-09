function [time, td] = myiFFT(x,y, varargin)
% [time, td] = myiFFT(x,y) % perform inverse Fourier transformation
%
% - x : x-value (vector)
% - y : FT data. (vector or matrix)
%
% - x
% time 
% 

%warning('Time may not be proper');

narginchk(2,4);

% dt = 1/Fs;
%rawN = numel(x);
% Inputs
if numel(varargin) >= 1
    % First term is N
    NFFT = varargin{1};
    warning('Time may not be proper because NFFT is specified');
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

dt = 1/((NFFT + 1) * (x(2) - x(1)));
%dt = (numel(x) + 1) * abs(1/(x(2) - x(1)))/2; % 多分このあたりに補正が必要
time = (0 : (NFFT-1) ) * dt;