%% Parte 2, letra a

u=prbs(1024,10,1);
u=u-0.5;

% plot w_2
fig = figure(1);
plot(1:1024,u, 'k-');
axis([0 1025 -0.8 0.8]);
title("Entrada aleatória");
xlabel('time');
ylabel('u');
saveplot(fig, 'images\2a\entrada_aleatoria');


fig = figure(2);
[t,ruu,l,B]=myccf2([u' u'],30,0,1,'k');
title("Função de autocorrelação");
axis([-0.5 30.5 -1.1 1.1]);
saveplot(fig, 'images\2a\funcao_autocorrelacao');
