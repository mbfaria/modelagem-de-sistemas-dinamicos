function [t,r,l,B]=myccf(c,lag,flag1,flag2,cor); 
 
% [t,r,l]=myccf(c,lag,flag1,flag2,cor); 
% c1=c(:,1); c2=c(:,2); 
% the ccf are calculated from -lag/2 to lag/2 if flag1 = 1; 
% the ccf are calculated from 0 to lag if flag1 = 0;
% plots the ccf between c1 and c2 if flag2 = 1; 
% if flag2=0 the ccf is returned in r (with respective
% lags in t), but not plotted;
% l is a scalar, the 95% confidence interval is +-l;
% if cor='w', white lines are used. If cor='k', black.
% r*B is the unnormalized value of r.
% 
% in case of intending the FI(eu) plot c MUST be =[e u] 
 
% Luis Aguirre - Sheffield - may 91 
%	       - Belo Horizonte - Jan 99, update
 
if flag1==1,
  lag=floor(lag/2);
end;

c1=c(:,1); 
c1=c1-mean(c1); 
c2=c(:,2); 
c2=c2-mean(c2); 
cc1=cov(c1); 
cc2=cov(c2); 
m=floor(0.1*length(c1)); 
r12=covf([c1 c2],lag+1); 
 
t=0:1:lag-1; 
l=ones(lag,1)*1.96/sqrt(length(c1)); 
 
% ccf 
 
% Mirror r12(3,:) in raux 
raux=r12(3,lag+1:-1:1);
%for i=1:lag+1 
%  raux(i)=r12(3,lag+2-i); 
%end; 
 
B=sqrt(cc1*cc2); 
r=[raux(1:length(raux)-1) r12(2,:)]/B; 

% if -lag to lag but no plots
if flag1 == 1,
   t=-(lag):1:lag;
else
   t=0:lag;
   r=r12(2,1:lag+1)/B;
end;
   
% if plot 
if flag2 == 1, 
      
% if -lag to lag 
  if flag1 == 1, 
    t=-(lag):1:lag; 
    l=ones(2*lag+1,1)*1.96/sqrt(length(c1)); 
    if cor=='w'
       plot(t,r,'w-',t,l,'w:',t,-l,'w:',0,1,'w.',0,-1,'w.'); 
    else
       plot(t,r,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.');
    end;   
    xlabel('lag'); 
 
  else 
    t=0:lag; 
    l=ones(lag+1,1)*1.96/sqrt(length(c1)); 
    if cor=='w'
       plot(t,r12(2,1:lag+1)/B,'w-',t,l,'w:',t,-l,'w:',0,1,'w.',0,-1,'w.'); 
    else
       plot(t,r12(2,1:lag+1)/B,'k-',t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.');
    end; 
    xlabel('lag'); 
  end; 

else
  % if -lag to lag, but no plots
  if flag1 == 1,
   t=-(lag):1:lag;
  else
   t=0:lag;
   r=r12(2,1:lag+1)/B;
  end;
 
end; 
l=l(1);
