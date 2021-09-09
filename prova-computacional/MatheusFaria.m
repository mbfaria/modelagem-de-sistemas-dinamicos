%% Prova de Tecnicas de Modelagem de Sistemas Dinamicos

% Aluno: Matheus Brito Faria
% Numero de matricula: 2017074386
% Data: 31/08/2021

clear; clc; close all;
%% Carregando os dados
% Numero na chamada: 14
data=load('data_prova_tmsd_14.dat');

% Dados de entrada
u = data(:, 2);

% Dados de saida
y = data(:, 3);

% Dito no enunciado
ts = 1;

% Vetor de tempo
t = 1:ts:length(y);

figure();
subplot(2, 1, 1);
plot(t, u);
xlabel("Time (seconds)")
ylabel("Amplitude")
subplot(2, 1, 2);
plot(t, y);
xlabel("Time (seconds)")
ylabel("Amplitude")

% Separando os dados em identificacao e validacao em
% 70% para identificacao e 30% para validacao

% Removendo o degrau incial para remover informacoes do transiente inicial.

% E importante fazer esse tipo e abordagem para que possamos observar se os
% parametros realmente foram bem estimados, onde o sistema e colocar a
% prova com um outro conjunto de dados.

t_id = t(5:140);
u_id = u(5:140);
y_id = y(5:140);


% Fazendo a mesma coisa com os dados de validacao
t_val =t(141:end);
u_val =u(141:end);
y_val =y(141:end);


figure()

subplot(2, 1, 1);
plot(t_id, u_id);
hold on;plot(t_val, u_val);
xlabel("Time (seconds)")
ylabel("Amplitude")

subplot(2, 1, 2);
plot(t_id, y_id);
hold on;plot(t_val, y_val);
xlabel("Time (seconds)")
ylabel("Amplitude")


%% Encontrando o tempo morto theta usando a funcao de correlacao cruzada

figure();
[~,ry,~,~]=myccf([y_id u_id],100,0,1,'k');

% Ao analisar a funcao de correlacao cruzada e possivel considerar que ela 
% possui um pico no tempo 1 segundo, logo concluimos que o sistema possui 
% uma primeira elevação antes desse tempo e como estamos observando a 
% funcao em tempo discreto podemos considerar o tempo morto como zero.

% theta
delay_hat = 0;

%% Avaliando K e tau

% Usando a aproximacao 
% y(k) = a*y(k-1) + b*u(k-1), 
% onde a=1 - (T_s/tau) e b=T_s*K/tau
% que vem da aproximacao dy/dt = (y(k+1) - y(k))/T_s
% conseguimos obter tau_hat = T_s / (a_hat - 1) e K_hat = b_hat*tau_hat/T_s
% Podemos analisar o sistema e gerar os parametros a partir do algoritmo de
% minimos quadrados.

% Criando a matriz Psi
psi = [y_id(1:end-1-delay_hat) u_id(1:end-1-delay_hat)];

% Calculando a pseudo inversa e multiplicando pelo y
Theta_hat = inv(psi'*psi)*psi'*y_id(2+delay_hat:end);

% Convertendo os parametros do algoritmo de minimos quadrados para os
% parametros de requeridos
tal_hat = -ts / (Theta_hat(1) - 1);
K_hat = (Theta_hat(2)*tal_hat) / ts;

% Recriando a funcao com os valores obtidos onde temos
% K = 3.5      theta = 0        tau = 5.5167

s=tf('s');
G_hat = (K_hat*exp(-delay_hat*s))/(tal_hat*s + 1);

% Fazendo a simulacao da funcao com os dados de validacao
y_hat = lsim(G_hat, u_val, t_val);

% Comparando os resultados
figure();
plot(t_val, y_val, 'k');
hold on;
plot(t_val, y_hat);
xlabel("Time (seconds)")
ylabel("Amplitude")

% Observando o resultado e possivel notar que o sistema conseguiu
% representar muito bem os dados de validacao, salvo a parte inicial que
% ficou menos precisa. Isso ocorre devido as interferencias das condicoes
% iniciais do sistema, ao fazer a simulacao dos dados com a entrada
% (validacao) o MatLab considera condicoes inciais nulas, enquanto na
% realidade os dados de validacao nao estao sob condicoes inciais nulas e
% isso causa uma interferencia de maneira mais abrupta nos primeiros 10
% segundos, um pouco menos abrupta nos proximos 10 segundos e a partir de
% entao o modelo consegue acompanhar muito bem o sistema.










