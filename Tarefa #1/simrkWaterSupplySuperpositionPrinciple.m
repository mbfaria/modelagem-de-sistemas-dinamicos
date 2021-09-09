clear; close all


t0=0; % initial time
tf=1000; % final time
h=1; % integration interval
t=t0:h:tf; % time vector


% initial conditions
x0=[3; 2; 1]; % h1, h2, w3

% initialization
x=[x0 zeros(length(x0),length(t)-1)];

% step
u=[zeros(round(length(t)*0.5)-1,1);5*ones(round(length(t)*0.5),1)];

for k=2:length(t)
    x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
end

xStep=x;
x=[x0 zeros(length(x0),length(t)-1)];


% sine
u=5*sin(2*pi*0.01*t)+5;

for k=2:length(t)
    x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
end

xSine=x;
x=xStep+xSine;


% plot w_3
figure(4)
plot(t,x(3,:));
set(gca,'FontSize',18)
xlabel('time (s)')
ylabel('w_3 (kg/s)')

% plot h_2
figure(3)
plot(t,x(2,:));
set(gca,'FontSize',18)
xlabel('time (s)')
ylabel('h_2 (m)')

% plot h_1
figure(2)
plot(t,x(1,:));
set(gca,'FontSize',18)
xlabel('time (s)')
ylabel('h_1 (m)')

% plot w_2
figure(1)
plot(t,u);
set(gca,'FontSize',18)
xlabel('time (s)')
ylabel('w_2 (kg/s)')

% % ---------------------------------------
% % step + sine
% step=[zeros(round(length(t)*0.5)-1,1);5*ones(round(length(t)*0.5),1)].';
% sine=5*sin(2*pi*0.01*t)+5;
% u=step+sine;
% 
% for k=2:length(t)
%     x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
% end
% 
% % plot w_3
% figure(4)
% plot(t,x(3,:));
% set(gca,'FontSize',18)
% xlabel('time (s)')
% ylabel('w_3 (kg/s)')
% 
% % plot h_2
% figure(3)
% plot(t,x(2,:));
% set(gca,'FontSize',18)
% xlabel('time (s)')
% ylabel('h_2 (m)')
% 
% % plot h_1
% figure(2)
% plot(t,x(1,:));
% set(gca,'FontSize',18)
% xlabel('time (s)')
% ylabel('h_1 (m)')
% 
% % plot w_2
% figure(1)
% plot(t,u);
% set(gca,'FontSize',18)
% xlabel('time (s)')
% ylabel('w_2 (kg/s)')


