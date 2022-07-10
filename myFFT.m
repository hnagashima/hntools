function [freq,FT] = myFFT(x,varargin)
% myFFT performs Fourier transformation and x-axis conversion.
% [freq,FT] = myFFT(x,y) % Fourier transformation
% [____,__] = myFFT(___,NFFT) % zero-padding.
% [____,__] = myFFT(___,____,dim) % specify dimension
% [____,__] = myFFT(___,____,___,window)
% 
% Input:
% - x: time domain vector.
% - y: data (vector or matrix)
% - NFFT: performs NFFT-point fft. Default is same number of x.
% - DIM: applies the fft operation across the dimension DIM. Default is 1st
%        dimension
% - window: Filter function name. (default is rectungler).
%           See help apowin.
% 
% Output:
% - f = Fs*(0:(L/2))/L; (Fs; sampling frequency, L number of datas)
% - FT = Fourier transformation data.
%

% varargin{1} : y
% varargin{2} : NFFT
% varargin{3} : DIM
% varargin{4} : window
% varargin{5} : treatment

narginchk(2,4);
if numel(x) <= 1
    error('Number of elements of x is not enough');
end

Fs = abs(1/(x(2) - x(1))/2); % Sampling frequency

% Determine number of zero-padding
if nargin > 2 && ~isempty(varargin{2})
     NFFT = varargin{2}; 
else
    NFFT = length(x);   % default. No padding.
end

% In the default, zero frequency is at the center by fftshift.
% shiftopt specifis the dimension of fftshift.
shiftopt = [];% default value
if nargin >= 4 && isempty(varargin{3} == 0)
    shiftopt = varargin{3};
end

% apply window function.
if nargin >= 5 && ~isempty(varargin{4})
    filterfun = apowin(varargin{4}, NFFT);
    if shiftopt == 1
        filterfun = reshape(filterfun,1,[]);
    else
        filterfun =  reshape(filterfun,[],1);
    end
    varargin{1} = filterfun .* varargin{1};
end

% Frequency
freq=(linspace(-1,1,NFFT+1)*Fs).';
freq(end) = [];

% Fourier transformation.
if isempty(shiftopt)
    FT = fftshift(fft(varargin{:}));
else
    FT = fftshift(fft(varargin{:}), shiftopt);
end




