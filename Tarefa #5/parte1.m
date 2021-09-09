clear; clc; close all;
%% Carregando os dados e separando um conjunto para validacao
data=readtable('dados_tarefa5.txt', 'ReadVariableNames', false);
data.Properties.VariableNames = {'t', 'u', 'y'};

t = data.t;
u = data.u - mean(data.u);
y = data.y - mean(data.y);

% Dados de identificacao
t_id = t(1:3000);
u_id = u(1:3000);
y_id = y(1:3000);

% Dados de validacao
t_val = t(3000:end);
u_val = u(3000:end);
y_val = y(3000:end);


%%dados de entrada
fig = figure();
subplot(3, 1, 1)
plot(t, u)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de entrada')
axis([0 200 -1 1]);

%dados de identificacao
subplot(3, 1, 2)
plot(t_id, u_id)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de identificacao')
axis([0 200 -1 1]);

%dados de validacao
subplot(3, 1, 3)
plot(t_val, u_val)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de validacao')
axis([0 200 -1 1]);

% saveplot(fig, './images/parte1/entradas.pdf');

%%dados de saida
fig = figure();
subplot(3, 1, 1)
plot(t, y)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de saída')
axis([0 200 -1 1]);

%dados de identificacao
subplot(3, 1, 2)
plot(t_id, y_id)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de identificacao')
axis([0 200 -1 1]);

%dados de validacao
subplot(3, 1, 3)
plot(t_val, y_val)
xlabel('Time (seconds)')
ylabel('Amplitude')
title('dados de validacao')
axis([0 200 -1 1]);

% saveplot(fig, 'images/parte1/saidas.pdf');

%% Analise tempo de amostragem 

fig = figure();
[~,ry,~,~]=myccf([y_id y_id],1500,0,1,'k');
% saveplot(fig, 'images/parte1/fac.pdf');
fig = figure();
y_id_2 = y_id.^2 - mean(y_id.^2);
[~,ry2,~,~]=myccf([y_id_2 y_id_2],1500,0,1,'k');
% saveplot(fig, 'images/parte1/fac_2.pdf');

tau_m_inicial = min(find(ry==min(ry)), find(ry2==min(ry2)));

% -------------------------------------------------------------------------
% tau minimo possui valor de 33
% Para que o novo tau minimo esteja entre 10 <= tau_m <= 20
% eh preciso fazer uma decimacao de 2, onde o novo tau_m será de 17
% -------------------------------------------------------------------------

y_id_dec = y_id(1:2:end);
u_id_dec = u_id(1:2:end);
t_id_dec = 1:length(y_id_dec);
fig = figure();
[~,ry,~,~]=myccf([y_id_dec y_id_dec],1500,0,1,'k');
% saveplot(fig, 'images/parte1/fac+ajustada.pdf');

fig = figure();
y_id_dec_2 = y_id_dec.^2 - mean(y_id_dec.^2);
[~,ry2,~,~]=myccf([y_id_dec_2 y_id_dec_2],1500,0,1,'k');
% saveplot(fig, 'images/parte1/fac_2_ajustada.pdf');

tau_m = min(find(ry==min(ry)), find(ry2==min(ry2)));


%% Analise FCC entrada e saida

fig = figure();
[~,ry,~,~]=myccf([y_id_dec u_id_dec],1500,0,1,'k');
% saveplot(fig, 'images/parte1/fcc.pdf');

%% Letra B
%% Selecao de estrutura

% Criterio de Akaike
degree = 12;
num_delay = degree / 2;
Y = y_id_dec(num_delay+1:end);
idx_aic = 1;

psi = [];
AIC = zeros(degree, 1);

for delay = 1:num_delay
    
    psi = [psi y_id_dec(num_delay-delay+1:end-delay)];
    theta_hat = pinv(psi)*Y;
    residual = Y-psi*theta_hat;

    AIC(idx_aic) = length(residual)*log(var(residual))+2*length(theta_hat);
    
    psi = [psi u_id_dec(num_delay-delay+1:end-delay)];
    theta_hat = pinv(psi)*Y;
    residual = Y-psi*theta_hat;

    AIC(idx_aic+1) = length(residual)*log(var(residual))+2*length(theta_hat);
    
    idx_aic = idx_aic + 2;
end

fig = figure();
plot(1:length(AIC), AIC, 'k-o');
xlabel('Número de regressores');
ylabel('AIC');
xlim([0 degree+1]);
% saveplot(fig, 'images/parte1/aic.pdf');


%% Metodo do agrupamento de termos
degree=12;
num_delay = degree / 2;
idx_sigma = 1;

psi = [];
sigma = zeros(degree, 1);

yt=zeros(length(y_id_dec), 1);
for k=2:length(y_id_dec)
    yt(k)=yt(k-1)+y_id_dec(k);
end

Y = yt(num_delay+1:end);

for delay = 1:num_delay
    
    psi = [psi yt(num_delay-delay+1:end-delay)];
    theta_hat = pinv(psi)*Y;
    residual = Y-psi*theta_hat;

    sigma(idx_sigma) = sum(theta_hat(1:2:end));
    
    psi = [psi u_id_dec(num_delay-delay+1:end-delay)];
    theta_hat = pinv(psi)*Y;
    residual = Y-psi*theta_hat;

    sigma(idx_sigma+1) = sum(theta_hat(1:2:end));
    
    idx_sigma = idx_sigma + 2;
end

fig = figure();
plot(1:length(sigma), abs(sigma-1), 'k-o');
xlabel('Número de regressores + 1');
ylabel('|\Sigma_y - 1|');
xlim([0 degree+1]);

% saveplot(fig, 'images/parte1/metodo_agrupamentos.pdf');


% Baseado nas duas formas de selecao 5 regressores parece
% ser o que melhor representa esse conjunto de dados
% pois no metodo AIK ele foi o que obteve um patamar aceitavel e deixou de
% decair depois disso, e no metodo do agrupamento, apenas do número 
% obtido ser 5-1=4, é possivel consluir que 5 regressores é um valor condizente
% OBS: VOU FAZER COM 5 PARAMETROS, PORÉM TODOS OS VALORES DE THETA QUE
% USAM A ENTRADA POSSUI UM VALOR MUITO BAIXO

%% Estimacao de parâmetros
delay = 3;
Y = y_id_dec(delay+1:end);

psi = [y_id_dec(3:end-1) u_id_dec(3:end-1) y_id_dec(2:end-2) u_id_dec(2:end-2) y_id_dec(1:end-3)];
theta_hat = pinv(psi)*Y;
residual = Y-psi*theta_hat;

% (iv) da letra d
fig = figure();
[~,r_rr,~,~]=myccf([residual residual],1000,0,1,'k');
axis([-50 1050 -1.1 1.1]);
title('Função de autocorrelação do resíduos');
% saveplot(fig, 'images/parte1/FAC_residuos.pdf');

fig = figure();
[~,r_ur,~,~]=myccf([u_id_dec(delay+1:end) residual],1000,0,1,'k');
axis([-50 1050 -1.1 1.1]);
title('Função de correlação cruzada entre a entrada e os resíduos');
% saveplot(fig, 'images/parte1/FCC_residuos.pdf');

%% Simulacao de um passo a frente

delay = 3;
psi = [y_val(delay:end-delay+2) u_val(delay:end-delay+2) y_val(delay-1:end-delay+1) u_val(delay-1:end-delay+1) y_val(delay-2:end-delay)];
y_osp_val = psi*theta_hat;
RMSE = sqrt(mean((y_val(delay+1:end) - y_osp_val).^2));
fprintf("RMSE da simulacao de um passo a frente = %s\n", RMSE)

fig = figure();
plot(t_val, y_val, 'k');
axis([150 200 -1 1]);
hold on;
plot(t_val(delay+1:end), y_osp_val, 'k--');
axis([150 200 -1 1]);

% saveplot(fig, 'images/parte1/simulacao_passo_a_frente.pdf');



%% Simulacao livre
delay = 3;

y_free_hat = zeros(length(y_val)-delay, 1);

y_free_hat(1) = [y_val(delay) u_val(delay) y_val(delay-1) u_val(delay-1) y_val(delay-2)]*theta_hat;
y_free_hat(2) = [y_free_hat(1) u_val(delay+1) y_val(delay) u_val(delay) y_val(delay-1)]*theta_hat;
y_free_hat(3) = [y_free_hat(2) u_val(delay+2) y_free_hat(1) u_val(delay+1) y_val(delay)]*theta_hat;
y_free_hat(4) = [y_free_hat(3) u_val(delay+3) y_free_hat(2) u_val(delay+2) y_free_hat(1)]*theta_hat;

for i = 5:length(y_val)-delay
    y_free_hat(i) = [y_free_hat(i-1) u_val(delay+i-1) y_free_hat(i-2) u_val(delay+i-2) y_free_hat(i-3)]*theta_hat;
end

RMSE = sqrt(mean((y_val(delay+1:end) - y_free_hat).^2));
fprintf("RMSE da simulacao livre = %s\n", RMSE)

fig = figure();
plot(t_val, y_val, 'k');
axis([150 200 -1 1]);
hold on;
plot(t_val(delay+1:end), y_free_hat, 'k--');
axis([150 200 -1 1]);

% saveplot(fig, 'images/parte1/simulacao_livre.pdf');


% Usando a simulacao livre eh possível perceber que o modelo que 
% na simulaçao anterior parecia se ajustar perfeitamente aos dados, 
% na realidadade não se ajusta não tem bem assim, obtendo um desempenho
% muito abaixo do esperado
