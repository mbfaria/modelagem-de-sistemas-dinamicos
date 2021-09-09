clear; close all; clc;
%% Questão D
K=0.91;
wn=2*pi/550;
zeta=0.6/1.5;
N=1024*5;
u=prbs(N,20,1);
u=u-0.5;
lu=length(u);
t=1:lu;
y=lsim([K*wn^2], [1 2*zeta*wn wn^2],u,t);
e=0.05*randn(N,1);
Y=fft(y+e);
U=fft(u');
H=Y./U;

fig = figure(1);
freq=1/(length(y))*(0:length(y)/2); 
semilogx(freq,20*log10(abs(H(1:length(freq))))); 


w=logspace(-2.5,-0.1,100);
mw=max(w);
I=find(2*pi*freq<=mw);
freq=freq(I);
[mag,pha,w]=bode([K*wn^2], [1 2*zeta*wn wn^2], w);
subplot(211)
set(gca,'FontSize',14)
semilogx(w,20*log10(mag),'k-',2*pi*freq,20*log10(abs(H(1:length(freq)))),'k--');
title('(a)');
ylabel('|H(j\omega)| (dB)');
xlim([0.001 0.3]);
subplot(212)
set(gca,'FontSize',14)
semilogx(w,pha,'k-',2*pi*freq,angle(H(1:length(freq)))*180/pi,'k--');
title('(b)');
ylabel('fase de H(j\omega) (graus)');
xlabel('frequencia (rad/s)')
xlim([0.001 0.3]);
saveplot(fig, 'images\2d\metodo_H');

[t,ruy,l,B]=myccf([y+e u'],N,0,0,'k');
Ruy=fft(ruy*B);
[t,ruu,l,B]=myccf([u' u'],N,0,0,'k');
Ruu=fft(ruu*B);
Hr=Ruy./Ruu;

fig = figure(2);
w=logspace(-2.5,-0.1,100);
mw=max(w);
I=find(2*pi*freq<=mw);
freq=freq(I);
[mag,pha]=bode([K*wn^2], [1 2*zeta*wn wn^2],w);
subplot(211)
set(gca,'FontSize',14)
semilogx(w,20*log10(mag),'k-',2*pi*freq,20*log10(abs(Hr(1:length(freq)))),'k--');
title('(a)');
ylabel('|H(j\omega)| (dB)');
xlim([0.001 0.3]);
subplot(212)
set(gca,'FontSize',14)
semilogx(w,pha,'k-',2*pi*freq,angle(Hr(1:length(freq)))*180/pi,'k--');
title('(b)');
ylabel('fase de H(j\omega) (graus)');
xlim([0.001 0.3]);
saveplot(fig, 'images\2d\metodo_melhor');