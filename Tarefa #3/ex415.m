clear; clc; close all;
rng(0);
%% 4.15
u=prbs(180,6,1);
t=1:length(u);

fig = figure(1);
plot(t,u,'k');
ylim([min(u)-0.5 max(u)+0.5]);
title("Entrada aleatória");
saveplot(fig, 'images\415\entrada_aleatoria');

fig = figure(2);
myccf([u' u'], 180, 0, 1, 'k');
title("Função de autocorrelação");
saveplot(fig, 'images\415\funcao_autocorrelacao');