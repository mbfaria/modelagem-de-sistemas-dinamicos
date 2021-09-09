clear; clc; close all;
rng(1);
%% Letra A
s = tf('s');

ts = 1; %1
t = 1:ts:(300*ts); %300

K = 1;
delay = 5; %5
tal = 10; %10

G = (K*exp(-delay*s))/(tal*s + 1);

tb = 2;

if ((tb >= (tal/10)) && (tb <= (tal/3)))
    fprintf("Tb é compatível!\n");
else
    fprintf("Tb não é compatível!\n");
end

u = prbs(length(t),6,tb);

fig = figure(1);
subplot(2,1,1)
plot(t, u, 'k');
xlabel("Time (seconds)")
ylabel("Amplitude")
ylim([-0.1, 1.1])

y = lsim(G, u, t);

subplot(2,1,2)
plot(t, y, 'k');
xlabel("Time (seconds)")
ylabel("Amplitude")
ylim([-0.1, 1.1])

saveplot(fig, "./images/parte-1/sinal-prbs-e-resposta.pdf")
%% Letra B

fig = figure(2);
[~,ruu,l,B]=myccf2([y u'],20,0,1,'k');
saveplot(fig, "./images/parte-1/funcao-coorelacao-cruzada.pdf")

delay_hat = 5;

%% Letra C

starts_at = 50;
y_ = y(starts_at:end) - 0.5;
t_ = t(starts_at:end);
u_ = u(starts_at-delay:end-delay) - 0.5;

fig = figure(3);
subplot(2, 1, 1)
plot(t, y, 'k');
xlabel("Time (seconds)")
ylabel("Amplitude")
ylim([-0.1, 1.1])
hold on; xline(starts_at);
hold on; yline(0.5);

subplot(2, 1, 2)
plot(t_, y_, 'k')
xlabel("Time (seconds)")
ylabel("Amplitude")
ylim([-0.6, 0.5])

saveplot(fig, "./images/parte-1/saida-normalizada.pdf")

%%


psi = [y_(1:end-1) u_(1:end-1)'];

theta_hat = inv(psi'*psi)*psi'*y_(2:end);

tal_hat = -ts / (theta_hat(1) - 1);

K_hat = (theta_hat(2)*tal_hat) / ts;

G_hat = (K_hat*exp(-delay_hat*s))/(tal_hat*s + 1);

fig = figure(4);
step(G, 'k-');
hold on;
step(G_hat, 'k-.');

saveplot(fig, "./images/parte-1/resultado-theta-7.pdf")
