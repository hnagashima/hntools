function [freq,FT] = myFFT(x,varargin)
% myFFT performs Fourier transformation and x-axis conversion.
% [freq,FT] = myFFT(x,y) % Fourier transformation
% [____,__] = myFFT(___,NFFT) % zero-padding.
% [____,__] = myFFT(________,dim) % specify dimension
% 
% Input:
% x: time domain vector.
% y: data (vector or matrix)
% NFFT: performs NFFT-point fft. (padding with zeros)
% DIM: applies the fft operation across the dimension DIM.
% 
% Output:
% f = Fs*(0:(L/2))/L; (Fs; sampling frequency, L number of datas)
% FT = Fourier transformation data.
%


narginchk(2,4);
Fs = 1/(x(1) - x(2))/2;

if nargin > 2
     NFFT = varargin{2};
else
    NFFT = length(x);
end
if nargin < 4
    shiftopt = 1;
else
    shiftopt = varargin{3};
end
freq=(linspace(-1,1,NFFT+1)*Fs).';
freq(end) = [];
FT = fftshift(fft(varargin{:}),shiftopt);