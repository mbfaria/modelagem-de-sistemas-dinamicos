clear; clc; close all;
rng(0);

ts = 1; %1

z = tf('z', ts);

t = 1:ts:(300*ts); %300

G = (z + 0.5)/(z^2 -1.5*z +0.7);

tb = 1;

u = prbs(length(t),10,tb);

y = lsim(G, u, t);

fig = figure(1);
subplot(2, 1, 1)
plot(t, u, 'k');
xlabel('Time (seconds)')
ylabel('Amplitude')
ylim([-0.1, 1.1])

subplot(2, 1, 2)
plot(t, y, 'k');
xlabel('Time (seconds)')
ylabel('Amplitude')
saveplot(fig, 'images/parte-2/entrada_saida');

starts_at = 10;

y_ = y(starts_at:end);
y_ = y_ - mean(y_);

u_ = u(starts_at:end);
u_ = u_ - mean(u_);

t_ = t(starts_at:end);

fig = figure(2);
subplot(2, 1, 1)
plot(t, y, 'k')
xlabel('Time (seconds)')
ylabel('Amplitude')
hold on; xline(starts_at);
hold on; yline(mean(y));

subplot(2, 1, 2)
plot(t_, y_, 'k')
xlabel('Time (seconds)')
ylabel('Amplitude')


saveplot(fig, 'images/parte-2/entrada_saida_normalizada');

% segunda ordem
psi = [y_(2:end-1) y_(1:end-2) u_(2:end-1)' u_(1:end-2)'];

theta_hat = inv(psi'*psi)*psi'*y_(3:end);
%%

G_hat_2_degree = (theta_hat(3) + theta_hat(4)*z)/(z^2 -theta_hat(1)*z -theta_hat(2));

fig = figure(3);
step(G, 'k');
hold on;
step(G_hat_2_degree, 'k-.');

saveplot(fig, 'images/parte-2/segunda_ordem');

residual_2_degree = y_(3:end) - psi*theta_hat;

fprintf("\nUsing degree 2\n")
fprintf("Mean = %s\n", mean(residual_2_degree))
fprintf("Standard deviation  = %s\n", std(residual_2_degree))


% 3 ordem

psi = [y_(3:end-1) y_(2:end-2) y_(1:end-3) u_(3:end-1)' u_(2:end-2)'];

theta_hat = inv(psi'*psi)*psi'*y_(4:end);

G_hat_3_degree = (theta_hat(4) + theta_hat(5)*z)/(z^3 -theta_hat(1)*z^2 -theta_hat(2)*z -theta_hat(3));

fig = figure(4);
step(G, 'k');
hold on;
step(G_hat_3_degree, 'k-.');

saveplot(fig, 'images/parte-2/terceira_ordem');

residual_3_degree = y_(4:end) - psi*theta_hat;

fprintf("\nUsing degree 3\n")
fprintf("Mean = %s\n", mean(residual_3_degree))
fprintf("Standard deviation  = %s\n", std(residual_3_degree))


% 1 ordem
psi = [y_(1:end-1) u_(2:end)' u_(1:end-1)'];

theta_hat = inv(psi'*psi)*psi'*y_(2:end);

G_hat_1_degree = (theta_hat(2) + theta_hat(3)*z) / (z - theta_hat(1));

fig = figure(5);
step(G, 'k');
hold on;
step(G_hat_1_degree, 'k-.');

saveplot(fig, 'images/parte-2/primeira_ordem');

residual_1_degree = y_(2:end) - psi*theta_hat;

fprintf("\nUsing degree 1\n")
fprintf("Mean = %s\n", mean(residual_1_degree))
fprintf("Standard deviation  = %s\n", std(residual_1_degree))

%%
fig = figure(6);
subplot(3, 1, 1)
plot(1:length(residual_1_degree), residual_1_degree, 'k')
title('1ª order')
xlabel('Samples')
ylabel('Residual')

subplot(3, 1, 2)
plot(1:length(residual_2_degree), residual_2_degree, 'k')
title('2ª order')
xlabel('Samples')
ylabel('Residual')

subplot(3, 1, 3)
plot(1:length(residual_3_degree), residual_3_degree, 'k')
title('3ª order')
xlabel('Samples')
ylabel('Residual')


saveplot(fig, 'images/parte-2/vetor-de-residuos');

%%
fig = figure(7);
subplot(3, 1, 1)
plot(1:length(residual_1_degree), residual_1_degree.^2, 'k')
title('1ª order')
xlabel('Samples')
ylabel('Residual')

subplot(3, 1, 2)
plot(1:length(residual_2_degree), residual_2_degree.^2, 'k')
title('2ª order')
xlabel('Samples')
ylabel('Residual')

subplot(3, 1, 3)
plot(1:length(residual_3_degree), residual_3_degree.^2, 'k')
title('3ª order')
xlabel('Samples')
ylabel('Residual')


saveplot(fig, 'images/parte-2/vetor-de-residuos-quadrado');
%%

fig = figure(8);
step(d2c(G), 'k')
hold on;step(d2c(G_hat_1_degree), 'r');
hold on;step(d2c(G_hat_2_degree), 'b');
hold on;step(d2c(G_hat_3_degree), 'y');
legend({'G(s)', '1º order', '2º order','3º order'}, 'Location','southeast')
ylim([-0.2, 10])

saveplot(fig, 'images/parte-2/comparacao_continua');




