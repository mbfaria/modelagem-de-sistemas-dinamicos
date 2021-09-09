function xdot=dvWaterSupply(x,ux,uy,t)

% x(1) = h1
% x(2) = h2
% x(3) = w3
% ux = w2

% Tipo do tubo
alpha=2;
% Massa especifica 
rho=1000;
% Area caixa dagua 1
a1=pi*(3/2)^2;
% Area caixa dagua 2
a2=pi*(1/2)^2;
% Area cano de ligacao
a3=pi*(0.03/2)^2;
% Altura caixa dagua 1
z1=3;
% Altura caixa dagua 2
z2=2;
% Tamanho do cano de ligacao
L=100;
% Inclinacao do cano de ligacao
b=0.261799; % 15º em rad
% Gravidade
g=9.83;

% d(h1)/dt
xd(1)=-x(3)/(rho*a1);

% d(h2)/dt
xd(2)=(-ux+x(3))/(rho*a2);

z=z1-z2;
hh=x(1)-x(2);
eq=(b*(x(3))^alpha)/(g*(rho*a3)^(alpha+1));

% d(w3)/dt
xd(3)=((z+hh-eq)*(g*rho*a3))/L;

xdot=xd';