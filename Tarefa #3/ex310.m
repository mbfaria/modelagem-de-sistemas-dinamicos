clear; clc; close all;
rng(0);
%% 3.10
% Entrada aleatoria
% u=[1 zeros(1,9)];
u=prbs(10,2,1);
u=u-0.5;
lu=length(u);

y=dlsim(1,[1 0.2 0.8],u);
yk=y+(rand(lu, 1)*0.05);

yi=dimpulse(1,[1 0.2 0.8],lu);

fig = figure(1);
sgtitle ('Entrada aleatoria');
plot(1:10,u,'k-',1:10,u,'ko');
%saveplot(fig, 'images\310\entrada_aleatoria');

fig = figure(2);
sgtitle ('Resposta a entrada aleatoria');
subplot(211)
plot(1:10,y,'k-', 1:10,y,'ko')
title('Sem ruido');
subplot(212)
plot(1:10,yk,'k-', 1:10,yk,'ko');
title('Com ruido');
%saveplot(fig, 'images\310\y_entrada_aleatoria');

U=u';
for i=1:9
U=[U [zeros(i,1); u(1:lu-i)']];
end

h=inv(U)*(y);
hk=inv(U)*(yk);

fig = figure(3);
sgtitle ('Resposta ao impulso medida');
subplot(211);
plot(1:10,yi,'k-',1:10,h,'k+');
title('Sem ruido');
subplot(212);
plot(1:10,yi,'k-',1:10,hk,'k+');
title('Com ruido');
%saveplot(fig, 'images\310\resposta_ao_impulso_1');

%% Impulso
u=[zeros(1,10)];
u(1)=1;
lu=length(u);

y=dlsim(1,[1 0.2 0.8],u);
yk=y+(rand(lu, 1)*0.05);

yi=dimpulse(1,[1 0.2 0.8],lu);

fig = figure(4);
sgtitle ('Entrada impulso');
plot(1:10,u,'k-',1:10,u,'ko');
% saveplot(fig, 'images\310\entrada_impulso');

fig = figure(5);
subplot(211)
sgtitle ('Resposta ao impulso');
plot(1:10,y,'k-', 1:10,y,'ko')
title('Sem ruido');
subplot(212)
plot(1:10,yk,'k-', 1:10,yk,'ko');
title('Com ruido');
% saveplot(fig, 'images\310\y_entrada_impulso');

U=u';
for i=1:9
U=[U [zeros(i,1); u(1:lu-i)']];
end

h=inv(U)*(y);
hk=inv(U)*(yk);

fig = figure(6);
sgtitle ('Resposta ao impulso medida');
subplot(211);
plot(1:10,yi,'k-',1:10,h,'k+');
title('Sem ruido');
subplot(212);
plot(1:10,yi,'k-',1:10,hk,'k+');
title('Com ruido');
% saveplot(fig, 'images\310\resposta_ao_impulso_2');
