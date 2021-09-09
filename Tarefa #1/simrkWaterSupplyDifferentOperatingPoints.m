clear; close all


t0=0; % initial time
tf=1000; % final time
h=1; % integration interval
t=t0:h:tf; % time vector


% initial conditions
x0=[3; 2; 1]; % h1, h2, w3

% initialization
x=[x0 zeros(length(x0),length(t)-1)];

% % step
% u=[zeros(round(length(t)*0.25),1);5*ones(round(length(t)*0.75),1)];

% pulse
u=zeros(length(t),1);
half_signal=(length(t)*0.5)+300; % -300 0 +300
half_pulse=length(t)*0.1;
for i=1:length(t)
    if (i > (half_signal-half_pulse)) && (i < (half_signal+half_pulse))
        u(i)=5;
    end
end

for k=2:length(t)
    x(:,k)=rkWaterSupply(x(:,k-1),u(k),u(k),h,t(k));
end

% plot w_3
figure(4)
plot(t,x(3,:));
set(gca,'FontSize',18)
xlabel('time')
ylabel('w_3')

% plot h_2
figure(3)
plot(t,x(2,:));
set(gca,'FontSize',18)
xlabel('time')
ylabel('h_2')

% plot h_1
figure(2)
plot(t,x(1,:));
set(gca,'FontSize',18)
xlabel('time')
ylabel('h_1')

% plot w_2
figure(1)
plot(t,u);
set(gca,'FontSize',18)
xlabel('time')
ylabel('w_2')



