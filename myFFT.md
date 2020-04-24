# myFFT
高速フーリエ変換の結果と、x軸の変換を同時に返す.

    [freq,FT] = myFFT(x,varargin);
    [_] = myFFT(x,y);
    [_] = myFFT(x,y,NFFT,dim);
    

myFFTはyをフーリエ変換して、その結果をFTに、freqにはx(時間軸)を周波数軸へと変換した結果を返します。

NFFTはフーリエ変換のポイント数. 入力があれば、NFFTに合わせたゼロフィリングを行う.
dimが指定された場合はdimに沿って変換.
yはfftshiftされている(つまりfreq = 0が中心)として自動的に返されます.

x軸の変換は、
freq = Fs * (0:L/2)/L; の式に従います.
Fsはxの時間軸の刻み.



----------
# See also

[+Hiroki’s Library](https://paper.dropbox.com/doc/Hirokis-Library-FTsQvYTdtV3TU3DCBth1a) 
fft - Matlab

