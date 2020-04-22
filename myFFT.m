function [freq,FT] = myFFT(x,varargin)
%f = Fs*(0:(L/2))/L;
% [freq,FT] = myFFT(x,y,NFFT,dim)
% [freq,FT] = myFFT(x,y) % non-zero filling

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