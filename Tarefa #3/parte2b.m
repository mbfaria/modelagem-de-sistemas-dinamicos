clear; close all
rng(3);

size=3;
t0=1; % initial time
tfinal=1024*size; % final time
h=1; % integration interval
t=t0:h:tfinal; % time vector


% initial conditions
x0=[3; 2; 1]; % h1, h2, w3

% initialization
x=[x0 zeros(length(x0),length(t)-1)];

% step
u=prbs(1024*(size-1),10,17);
u=u*5;
u=[zeros(1024, 1); u'];

% run rk
for k=2:length(t)
    x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
end

x = x(:,1500+1:abs(length(x)));
t = t(1500+1:abs(length(t)));
u = u(1500+1:abs(length(u)));


% add some noise
x = x+(rand(3, length(x)).*max(x, [], 2)*0.05);

% plot w_2
fig = figure(1);
plot(t,u,'k');
ylim([min(u)-1 max(u)+1]);
title("Entrada");
xlabel('time')
ylabel('w_2')
saveplot(fig, 'images\2b\entrada');

% plot w_3
fig = figure(2);
hold on
plot(t,x(3,:),'k');
title("Saída");
xlabel('time')
ylabel('w_3');
saveplot(fig, 'images\2b\saida');

fig = figure(3);
[tt,ruy,l,B]=myccf([x(3,:)' u],1024*(size-2)*2,1,1,'k');
title("Função de correlação cruzada");
xlim([-1024*(size-2) 1024*(size-2)]);
saveplot(fig, 'images\2b\funcao_cc');
