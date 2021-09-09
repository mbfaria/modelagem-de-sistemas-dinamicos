function x=rkWaterSupply(x0,ux,uy,h,t)

% 1st evaluation
xd=dvWaterSupply(x0,ux,uy,t);
savex0=x0;
phi=xd;
x0=savex0+0.5*h*xd;

% 2nd evaluation
xd=dvWaterSupply(x0,ux,uy,t+0.5*h);
phi=phi+2*xd;
x0=savex0+0.5*h*xd;

% 3rd evaluation
xd=dvWaterSupply(x0,ux,uy,t+0.5*h);
phi=phi+2*xd;
x0=savex0+h*xd;

% 4th evaluation
xd=dvWaterSupply(x0,ux,uy,t+h);
x=savex0+(phi+xd)*h/6;
