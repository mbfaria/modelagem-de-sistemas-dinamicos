clear; clc; close all;
rng(0);
%% 4.20

T_b=[1 100 1000 10000];

for i=1:length(T_b)
    
    str = int2str(T_b(i));
    u=prbs(100000, 8, T_b(i));
    t=1:length(u);
    y=lsim(1,[1000 1],u, t);

    fig = figure(i);
    subplot(211);
    plot(t,u,'k');
    ylim([min(u)-0.5 max(u)+0.5]);
    title(strcat("Entrada (T_b=",str,")"));

    subplot(212);
    plot(t,y,'k');
    title(strcat("Saída (T_b=",str,")"));
    
    saveplot(fig, ['images\420\resposta_tb_' str]);
end
