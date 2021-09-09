clear; clc; close all
set(0, 'DefaultLineLineWidth', 1.2);
%% Carrega os dados 
data=readtable('torneira3.txt', 'ReadVariableNames', false);
data.Properties.VariableNames = {'y', 'u'};
y = data.y;
u = data.u;
u = -u;

% variacao de saida
Delta_Y=mean(y(end-14:end))-mean(y(1:14));
% variacao da entrada
Delta_U=mean(u(end-14:end))-mean(u(1:14));

% vetor de tempo
t = [1:length(data.y)]';

% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=(u(14:end)-mean(u(1:14)))/Delta_U;
y=(y(14:end)-mean(y(1:14)))/Delta_Y;
t=t(14:end);
tt=t-14;

% Plot os dados

figure(1);
subplot(211);
uu = -u*Delta_U + 3600;
plot(t, uu, 'k');
grid;


subplot(212);
yy = y*Delta_Y + 1000;
plot(t, yy, 'k');
grid;
hold on;


figure(2);
subplot(211);
uu = -u*Delta_U + 3600;
plot(t, uu, 'k');
grid;

figure(3);
yy = y*Delta_Y + 1000;
plot(t, yy, 'k');
grid;
hold on;


%% Metodo da secao 3.2.1

K=1;
tal_d=4;
tal=12;

s = tf('s');
new = (K*exp(-tal_d*s))/(tal*s + 1); %tf(K, [tal 1]);%, 'ioDelay', 4);

y1 = lsim(new, u, tt);

figure(1);
subplot(212);
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#0072BD'); %azul

figure(3);
hold on; 
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#0072BD'); %azul

%% Metodo das areas
y0=0;
Ts = 1;
K1 = (y(end) - y(1))/(u(end) - u(1));
yn = y - y0;
yn = yn./K1;
area = sum(Ts*(u - yn));

tau1 = exp(1)*sum(Ts*yn(1:find(tt==round(area))));
theta1 = area - tau1;

G1a = tf(K1, [tau1 1], 'ioDelay', theta1-0.5);
y1 = lsim(G1a, u, tt) + y0;

figure(1); 
subplot(212); 
hold on; 
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#D95319'); %laranja 

figure(3);
hold on; 
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#D95319'); %laranja 

%% Metodo de Sundaresan
% ganho
K=Delta_Y/Delta_U;
% area m1
m1=6+(21-6)/2;
% inclinacao Mi
Mi=1/15;
% a reta tangeta intercepta o valor dinal de y(t)
tm=18;
lambda=(tm-m1)*Mi;

Eta=0.02:0.001:0.95;
Chi=log(Eta)./(Eta-1); % Eq. 3.17 do livro
Lambda=Chi.*exp(-Chi); % Eq. 3.16 do livro

figure(4)
plot(Lambda,Eta,'k',[lambda lambda],[0 1],'b')
% set(gca,'FontSize',16)
xlabel('\lambda')
ylabel('\eta')

% valor de eta obtido graficamente
eta=0.275;

% Calculando os parametros usando Eqs. 3.18
tau1=(eta^(eta/(1-eta)))/Mi;
tau2=(eta^(1/(1-eta)))/Mi;
taud=m1-tau1-tau2;

sys=tf(K,conv([tau1 1],[tau2 1]));
ym=lsim(sys,ones(length(t),1)*Delta_U,t)/Delta_Y;

figure(2)
subplot(212)
hold on;
yy = y*Delta_Y + 1000;
plot(t,yy,'k')
yym = ym*Delta_Y + 1000;
plot(t+taud,yym ,'Color', '#EDB120'); % amarelo
grid

figure(3);
hold on; 
yym = ym*Delta_Y + 1000;
plot(t+taud, yym,'Color', '#EDB120');

%% Validacao
% Carrega os dados 
data=readtable('torneira4.txt', 'ReadVariableNames', false);
data.Properties.VariableNames = {'y', 'u'};
y = data.y;
u = data.u;
u = -u;

t = [1:length(data.y)]';

% variacao de saida
Delta_Y=mean(y(end-8:end))-mean(y(1:8));
% variacao da entrada
Delta_U=mean(u(end-8:end))-mean(u(1:8));

% fazendo todos os ajuste, lembrando de retirar o offset tem-se
u=(u(8:end)-mean(u(1:8)))/Delta_U;
y=(y(8:end)-mean(y(1:8)))/Delta_Y;
t=t(8:end);
tt=t-8;
%% Plot os dados

figure(4);
% subplot(211);
% uu = -u*Delta_U + 3600;
% plot(t, uu, 'k');
% grid;

% subplot(212);
yy = y*Delta_Y + 1000;
plot(t, yy, 'k');
grid;
hold on;

%% Metodo da secao 3.2.1

y1 = lsim(new, u, t);

% subplot(212);
hold on;
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#0072BD'); %azul
grid;

%% Metodo das areas

y1 = lsim(G1a, u, tt);

% subplot(212); 
hold on;
yy1 = y1*Delta_Y + 1000;
plot(t, yy1, 'Color', '#D95319'); %laranja 

%% Metodo de Sundaresan

ym=lsim(sys,u*Delta_U,t)/Delta_Y;

% subplot(212)
hold on;
yym = ym*Delta_Y + 1000;
plot(t,yym,'Color', '#EDB120'); % amarelo
grid

