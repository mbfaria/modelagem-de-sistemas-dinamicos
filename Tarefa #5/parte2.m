clear; clc; close all; rng(0);
%% Definindo funcao H(z)
H_s = tf([0.2 2], [1 1 0.2]);

H = c2d(H_s,1,'zoh');

fig = figure();
step(H_s);hold on;step(H);
[y_step, t_step] = step(H);
u_step = ones(length(y_step), 1); 
% saveplot(fig, './images/parte2/sistema.pdf');

theta_real = [H.Denominator{:}(2) H.Numerator{:}(2) H.Denominator{:}(3) H.Numerator{:}(3)];

% Fazendo 10*0.632=6.32 e procurando o tempo correpondente na resposta
% ao degrau chegamos a tau (constante de tempo) = 5.21 

% O valor T_b do sinal PRBS precisa estar entre 
% (tau/10) <= T_b <= (tau/3)  
%  0.521   <= T_b <=  1.7367
% Logo o T_b que vamos usar será igual a 1

T_b = 1;
t = 1:1:300;
u = prbs(length(t),10,T_b);
y = lsim(H, u, t); 

fig = figure();
subplot(2, 1, 1);
plot(t, u);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Entrada')
ylim([-0.2 1.2]);

subplot(2, 1, 2);
plot(t, y);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída')
ylim([-0.2 10]);

% saveplot(fig, './images/parte2/resposta_ao_prbs.pdf');

% Retirando a media e o transiente inicial

t = t(20:end);
u = u(20:end) - mean(u);
y = y(20:end) - mean(y);


fig = figure();
subplot(3, 1, 1);
plot(t, u);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Entrada')
ylim([-0.7 0.7]);

subplot(3, 1, 2);
plot(t, y);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída')
ylim([-5.2 5.2]);

noise = 0.8*randn(length(y),1);
SNR = 20*log(std(y) / std(noise));

ym = y + noise;

subplot(3, 1, 3);
plot(t, ym);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída ruidosa')
ylim([-5.2 5.2]);

% saveplot(fig, './images/parte2/resposta_ruidosa.pdf');

%% Estimacao de parametros (segunda ordem)

Y = y(3:end);
psi = [-y(2:end-1) u(2:end-1)' -y(1:end-2) u(1:end-2)'];
theta_hat = pinv(psi)*Y;
y_hat = psi*theta_hat;
residual = Y-y_hat;

Y = ym(3:end);
psi = [-ym(2:end-1) u(2:end-1)' -ym(1:end-2) u(1:end-2)'];
theta_hat_noise = pinv(psi)*Y;
y_hat_noise = psi*theta_hat_noise;
residual_noise = Y-psi*theta_hat_noise;

fig = figure();

subplot(3, 1, 1);
plot(t, y);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída real')
ylim([-5.2 5.2]);

subplot(3, 1, 2);
plot(t(3:end), y_hat);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada')
ylim([-5.2 5.2]);

subplot(3, 1, 3);
plot(t(3:end), y_hat_noise);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada usando dados ruidosos')
ylim([-5.2 5.2]);

%% Simulacao um passo a frente (segunda ordem)
y_step_zeros = [zeros(2, 1); y_step];
u_step_zeros = [zeros(2, 1); u_step];
psi = [-y_step_zeros(2:end-1) u_step_zeros(2:end-1) -y_step_zeros(1:end-2) u_step_zeros(1:end-2)];

y_hat_step = psi*theta_hat;
y_hat_step_noise = psi* theta_hat_noise;

fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_hat_step, 'o'); hold on;
plot(t_step, y_hat_step_noise, '*');
legend({'Original', 'Estimação sem ruído (2ª ordem)', 'Estimação com ruído (2ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)');
ylabel('Amplitude');
title('Simulação um passo a frente');

% saveplot(fig, './images/parte2/segunda_ordem_step.pdf');

%% Simulacao livre (segunda ordem)
delay=2;
% Dados sem ruido
y_free_hat = zeros(length(y_step), 1);

y_free_hat(1) = [-y_step_zeros(2) u_step_zeros(2) -y_step_zeros(1) u_step_zeros(1)]*theta_hat;
y_free_hat(2) = [-y_free_hat(1) u_step_zeros(3) -y_step_zeros(2) u_step_zeros(2)]*theta_hat;

for i = 3:length(y_step)+delay
    y_free_hat(i) = [-y_free_hat(i-1) u_step_zeros(i-1) -y_free_hat(i-2) u_step_zeros(i-2)]*theta_hat;
end
y_free_hat = y_free_hat(3:end);

% Dados com ruido
y_free_hat_noise = zeros(length(y_step), 1);

y_free_hat_noise(1) = [-y_step_zeros(2) u_step_zeros(2) -y_step_zeros(1) u_step_zeros(1)]*theta_hat_noise;
y_free_hat_noise(2) = [-y_free_hat_noise(1) u_step_zeros(1) -y_step_zeros(2) u_step_zeros(2)]*theta_hat_noise;

for i = 3:length(y_step)+delay
    y_free_hat_noise(i) = [-y_free_hat_noise(i-1) u_step_zeros(i-1) -y_free_hat_noise(i-2) u_step_zeros(i-2)]*theta_hat_noise;
end
y_free_hat_noise = y_free_hat_noise(3:end);


fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_free_hat, 'o'); hold on;
plot(t_step, y_free_hat_noise, '*');
legend({'Original', 'Estimação sem ruído (2ª ordem)', 'Estimação com ruído (2ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Simulação livre');

% saveplot(fig, './images/parte2/segunda_ordem_livre_step.pdf');

%% Estimacao de parametros (primeira ordem)

Y = y(2:end);
psi = [-y(1:end-1) u(1:end-1)'];
theta_hat = pinv(psi)*Y;
y_hat = psi*theta_hat;
residual = Y-y_hat;

Y = ym(2:end);
psi = [-ym(1:end-1) u(1:end-1)'];
theta_hat_noise = pinv(psi)*Y;
y_hat_noise = psi*theta_hat_noise;
residual_noise = Y-psi*theta_hat_noise;

fig = figure();

subplot(3, 1, 1);
plot(t, y);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída real')
ylim([-5.2 5.2]);

subplot(3, 1, 2);
plot(t(2:end), y_hat);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada')
ylim([-5.2 5.2]);

subplot(3, 1, 3);
plot(t(2:end), y_hat_noise);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada usando dados ruidosos')
ylim([-5.2 5.2]);

% saveplot(fig, './images/parte2/primeira_ordem_dados.pdf');


%% Simulacao um passo a frente (primeira ordem)
y_step_zeros = [zeros(1, 1); y_step];
u_step_zeros = [zeros(1, 1); u_step];
psi = [-y_step_zeros(1:end-1) u_step_zeros(1:end-1)];

y_hat_step = psi*theta_hat;
y_hat_step_noise = psi* theta_hat_noise;

fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_hat_step, 'o'); hold on;
plot(t_step, y_hat_step_noise, '*');
legend({'Original', 'Estimação sem ruído (1ª ordem)', 'Estimação com ruído (1ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)');
ylabel('Amplitude');
title('Simulação um passo a frente');

% saveplot(fig, './images/parte2/primeira_ordem_step.pdf');

%% Simulacao livre (primeira ordem)
delay=1;
% Dados sem ruido
y_free_hat = zeros(length(y_step), 1);

y_free_hat(1) = [ -y_step_zeros(1) u_step_zeros(1)]*theta_hat;

for i = 2:length(y_step)+delay
    y_free_hat(i) = [-y_free_hat(i-1) u_step_zeros(i-1)]*theta_hat;
end
y_free_hat = y_free_hat(2:end);

% Dados com ruido
y_free_hat_noise = zeros(length(y_step), 1);

y_free_hat_noise(1) = [-y_step_zeros(1) u_step_zeros(1)]*theta_hat_noise;
y_free_hat_noise(2) = [-y_step_zeros(2) u_step_zeros(2)]*theta_hat_noise;

for i = 2:length(y_step)+delay
    y_free_hat_noise(i) = [-y_free_hat_noise(i-1) u_step_zeros(i-1)]*theta_hat_noise;
end
y_free_hat_noise = y_free_hat_noise(2:end);


fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_free_hat, 'o'); hold on;
plot(t_step, y_free_hat_noise, '*');
legend({'Original', 'Estimação sem ruído (1ª ordem)', 'Estimação com ruído (1ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Simulação livre');

% saveplot(fig, './images/parte2/primeira_ordem_livre_step.pdf');

%% Estimacao de parametros (terceira ordem)

Y = y(4:end);
psi = [-y(3:end-1) u(3:end-1)' -y(2:end-2) u(2:end-2)' -y(1:end-3) u(1:end-3)'];
theta_hat = pinv(psi)*Y;
y_hat = psi*theta_hat;
residual = Y-y_hat;

Y = ym(4:end);
psi = [-ym(3:end-1) u(3:end-1)' -ym(2:end-2) u(2:end-2)' -ym(1:end-3) u(1:end-3)'];
theta_hat_noise = pinv(psi)*Y;
y_hat_noise = psi*theta_hat_noise;
residual_noise = Y-y_hat_noise;

fig = figure();

subplot(3, 1, 1);
plot(t, y);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída real')
ylim([-5.2 5.2]);

subplot(3, 1, 2);
plot(t(4:end), y_hat);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada')
ylim([-5.2 5.2]);

subplot(3, 1, 3);
plot(t(4:end), y_hat_noise);
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Saída estimada usando dados ruidosos')
ylim([-5.2 5.2]);

% saveplot(fig, './images/parte2/terceira_ordem_dados.pdf');

%% Simulacao um passo a frente (terceira ordem)
y_step_zeros = [zeros(3, 1); y_step];
u_step_zeros = [zeros(3, 1); u_step];
psi = [-y_step_zeros(3:end-1) u_step_zeros(3:end-1) -y_step_zeros(2:end-2) u_step_zeros(2:end-2) -y_step_zeros(1:end-3) u_step_zeros(1:end-3)];

y_hat_step = psi*theta_hat;
y_hat_step_noise = psi* theta_hat_noise;

fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_hat_step, 'o'); hold on;
plot(t_step, y_hat_step_noise, '*');
legend({'Original', 'Estimação sem ruído (3ª ordem)', 'Estimação com ruído (3ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)');
ylabel('Amplitude');
title('Simulação um passo a frente');

% saveplot(fig, './images/parte2/terceira_ordem_step.pdf');

%% Simulacao livre (terceira ordem)
delay=3;
% Dados sem ruido
y_free_hat = zeros(length(y_step), 1);

y_free_hat(1) = [-y_step_zeros(3) u_step_zeros(3) -y_step_zeros(2) u_step_zeros(2) -y_step_zeros(1) u_step_zeros(1)]*theta_hat;
y_free_hat(2) = [-y_free_hat(1) u_step_zeros(4) -y_step_zeros(3) u_step_zeros(3) -y_step_zeros(2) u_step_zeros(2)]*theta_hat;
y_free_hat(3) = [-y_free_hat(2) u_step_zeros(5) -y_free_hat(1) u_step_zeros(4) -y_step_zeros(3) u_step_zeros(3)]*theta_hat;

for i = 4:length(y_step)+delay
    y_free_hat(i) = [-y_free_hat(i-1) u_step_zeros(i-1) -y_free_hat(i-2) u_step_zeros(i-2) -y_free_hat(i-3) u_step_zeros(i-3)]*theta_hat;
end
y_free_hat = y_free_hat(4:end);

% Dados com ruido
y_free_hat_noise = zeros(length(y_step), 1);

y_free_hat_noise(1) = [-y_step_zeros(3) u_step_zeros(3) -y_step_zeros(2) u_step_zeros(2) -y_step_zeros(1) u_step_zeros(1)]*theta_hat_noise;
y_free_hat_noise(2) = [-y_free_hat_noise(1) u_step_zeros(4) -y_step_zeros(3) u_step_zeros(3) -y_step_zeros(2) u_step_zeros(2)]*theta_hat_noise;
y_free_hat_noise(3) = [-y_free_hat_noise(2) u_step_zeros(5) -y_free_hat_noise(1) u_step_zeros(4) -y_step_zeros(3) u_step_zeros(3)]*theta_hat_noise;

for i = 4:length(y_step)+delay
    y_free_hat_noise(i) = [-y_free_hat_noise(i-1) u_step_zeros(i-1) -y_free_hat_noise(i-2) u_step_zeros(i-2) -y_free_hat_noise(i-3) u_step_zeros(i-3)]*theta_hat_noise;
end
y_free_hat_noise = y_free_hat_noise(4:end);


fig = figure();
plot(t_step, y_step); hold on;
plot(t_step, y_free_hat, 'o'); hold on;
plot(t_step, y_free_hat_noise, '*');
legend({'Original', 'Estimação sem ruído (3ª ordem)', 'Estimação com ruído (3ª ordem)'}, 'Location','southeast')
xlabel('Tempo (segundos)')
ylabel('Amplitude')
title('Simulação livre');

% saveplot(fig, './images/parte2/terceira_ordem_livre_step.pdf');
