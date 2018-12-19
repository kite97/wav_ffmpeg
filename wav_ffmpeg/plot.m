% GNU Octave file (may also work with MATLAB(R) )
Fs=8000;minF=10;maxF=Fs/2;
sweepF=logspace(log10(minF),log10(maxF),200);
[h,w]=freqz([1.526008445288920e-01 3.052016890577839e-01 1.526008445288920e-01],[1 -6.328855625361093e-01 2.432889406516772e-01],sweepF,Fs);
semilogx(w,20*log10(h))
title('SoX effect: lowpass gain=0 frequency=1320 Q=0.707107 (rate=8000)')
xlabel('Frequency (Hz)')
ylabel('Amplitude Response (dB)')
axis([minF maxF -35 25])
grid on
disp('Hit return to continue')
pause
