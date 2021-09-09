clear; close all; clc;
rng(0); %3

size_t=5;
t0=1; % initial time
tfinal=1024*size_t; % final time
h=1; % integration interval
t=t0:h:tfinal; % time vector


% initial conditions
x0=[3; 2; 1]; % h1, h2, w3

% initialization
x=[x0 zeros(length(x0),length(t)-1)];

% step
u=prbs(1024*(size_t-1),17,10);
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
e = rand(3, length(x)).*max(x, [], 2)*0.05;
e = e(3, :);
e = 0.05*(e-mean(e));
y = x(3, :);
y = y+e;


fig = figure(1);
plot(t,u,'k');
ylim([min(u)-0.5 max(u)+0.5]);
title("Entrada");
ylabel("w_2");
xlabel("time");
saveplot(fig, 'images\2c\entrada');

fig = figure(2);
plot(t,y,'k');
ylim([min(y)-0.5 max(y)+0.5]);
title("Saída");
ylabel("w_2");
xlabel("time");
saveplot(fig, 'images\2c\saida');

range_data=1000:3000;

fig = figure(3);
[~,ruu,~,B]=myccf([u(range_data) u(range_data)],4000,1,1,'k');

fig = figure(4);
[~,ruy,~,B1]=myccf([y(range_data)' u(range_data)],2000,0,1,'k');

samples_size=2001;
Ruu=B*ruu(samples_size:end)';
for i=1:length(ruy)-1
    Ruu=[Ruu B*ruu(samples_size-i:end-i)'];
end
h2=inv(Ruu)*ruy';

fig = figure(5);
plot(1:20:1000,B*h2(1:20:1000),'k+') %40
title("Resposta ao impulso");
xlabel("time");
ylabel("w_3");

h=ruy/var(u);

K=0.9;
wn=2*pi/650;
zeta=0.7/1.5;
sys = tf([K*wn^2], [1 2*zeta*wn wn^2]);

yi=impulse(sys,1:1000);

hold on; plot(1:1000, 5*yi, 'k-');
saveplot(fig, 'images\2c\resposta_impulso');
