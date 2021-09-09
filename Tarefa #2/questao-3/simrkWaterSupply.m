clear; close all


t0=0; % initial time
tfinal=4000; % final time
h=1; % integration interval
t=t0:h:tfinal; % time vector


% initial conditions
x0=[3; 2; 1]; % h1, h2, w3

% initialization
x=[x0 zeros(length(x0),length(t)-1)];

% step
u=[zeros(round(length(t)*0.25),1);1*ones(round(length(t)*0.75),1)];
% u=[zeros(length(t), 1)];

% run rk
for k=2:length(t)
    x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
end

x = x(:,abs(length(x)/4):abs(length(x)*3/4));
t = t(abs(length(t)/4):abs(length(t)*3/4));
u = u(abs(length(u)/4):abs(length(u)*3/4));

% plot w_3
figure(1)
hold on
plot(t,x(3,:));
set(gca,'FontSize',18)
xlabel('time')
ylabel('w_3')

%% Modelo 1a ordem
K=0.91;
tal_d=1/200;
tal=130;
y0=0;

new = tf((K*exp(-tal_d)), [tal 1], 'ioDelay', 140);

y1 = lsim(new, u, t) + y0;

figure(1);
plot(t, y1, 'g-.','LineWidth',2); 

%% 2a ordem

K=0.91;
wn=2*pi/550;
zeta=0.6/1.5;

new = tf([K*wn^2], [1 2*zeta*wn wn^2], 'ioDelay', 110);

y1 = lsim(new, u, t) + y0;

plot(t, y1, 'r-.','LineWidth',2); 


