clear; clc; close all;
rng(0);
%% 4.16
for n = [ 4 ] %8 16 32]
    str = int2str(n);
    
    u=prbs(180,6,n);
    t=1:length(u);

    fig = figure(1);
    plot(t,u,'k');
    ylim([min(u)-0.5 max(u)+0.5]);
    title(strcat("Entrada aleatória (T_b=", str, ")"));
%     saveplot(fig, ['images\416\entrada_aleatoria_' str]);

    fig = figure(2);
    myccf([u' u'], 180, 0, 1, 'k');
    title(strcat("Função de autocorrelação (T_b=", str, ")"));
%     saveplot(fig, ['images\416\funcao_autocorrelacao_' str]);

    fig = figure(3);
    plot(fft(t),fft(u),'k');
%     ylim([min(u)-0.5 max(u)+0.5]);
%     title(strcat("Entrada aleatória (T_b=", str, ")"));

      
    
end