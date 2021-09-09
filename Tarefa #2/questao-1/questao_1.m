clear; clc; close all;
%% Carrega os dados 
data=readtable('DS100g_prato_2.txt', 'ReadVariableNames', false);
data.Properties.VariableNames = {'t', 'y'};

plot(data.t, data.y)
hold on

Ts = 0.0001;
u0 = 0; y0 = 0;
t = [0:Ts:4-Ts]';
% t = data.t;
u = [0; ones(length(t)-1,1)] + u0;


K=0.97;
wn=100*pi/3;
zeta=1/60;

new = tf([K*wn^2], [1 2*zeta*wn wn^2]);

y1 = lsim(new, u, t) + y0;

plot(t, y1, 'r-.','LineWidth',2); 
xlabel('t(s)'); 
ylabel('G(t)');











