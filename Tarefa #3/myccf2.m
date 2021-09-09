function [t,r,l,B]=myccf(c,lag,flag1,flag2,cor)
% [t,r,l,B]=myccf(c,lag,flag1,flag2,cor) returns the auto-correlation or cross-correlation
%	  function depending on the signals in the matrix c (c1=c(:,1); c2=c(:,2)).
%
% On entry
%	c     - signal vector or matrix.
%	lag   - scalar (positive number).
%	flag1 - the ccf are calculated from -lag/2 to lag/2 if flag1 = 1; (flag1=0 is the default).
% 		the ccf are calculated from 0 to lag if flag1 = 0;
% 	flag2 - plots the ccf between c1 and c2 if flag2 = 1; 
%                if flag2=0 the ccf is returned in r (with respective lags in t), but not plotted;
% 		 (the 95% confidence interval is the default)
% 	cor   - if cor='w', white lines are used. If cor='k', black.
%
% On return
%	t     - vector with lags;
%	r     - auto (or cross) correlation values
%	l     - 95% confidence value.
%	B     - maximum value of the auto(cross)-correlation
% 		r*B is the unnormalized value of r.
% 
% In case of intending the FI(eu) plot c MUST be =[e u] 
 
% Luis Aguirre - Sheffield - may 91 
%	       - Belo Horizonte - Jan 99, update
% Modified by E. Mendes on April, 25 2004.

if ((nargin<2) | (nargin > 5))
	error('myccf requires 2 .. 5 input arguments.');
elseif nargin == 2
	flag1=0;
	flag2=1;
	cor='k';
elseif nargin == 3
	flag2=1;
	cor='k';
elseif nargin == 4
	cor='k';
end;

% Tests

if (prod(size(lag)) ~= 1)
	error('lag is a scalar.');
end;

lag=abs(floor(lag));

if (prod(size(flag1)) ~= 1)
	error('flag1 is a scalar.');
end;

flag1=floor(flag1);

if (prod(size(flag2)) ~= 1)
	error('flag2 is a scalar.');
end;

flag2=floor(flag2);


if size(c,2) == 1  % Autocorrelation 
	c=[c c];
end;  


% Calculations


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
       plot(t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.');
       hold on
       stem(t,r,'k');
       hold off
    end;   
    xlabel('\tau'); %grid;
 
  else 
    t=0:lag; 
    l=ones(lag+1,1)*1.96/sqrt(length(c1)); 
    if cor=='w'
       plot(t,r12(2,1:lag+1)/B,'w-',t,l,'w:',t,-l,'w:',0,1,'w.',0,-1,'w.'); 
    else
       plot(t,l,'k:',t,-l,'k:',0,1,'k.',0,-1,'k.');
       hold on
       stem(t,r12(2,1:lag+1)/B,'k-');
       hold off
    end; 
    xlabel('\tau'); %grid;
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

function R=covf(z,M,maxsize)
%COVF  Computes the covariance function estimate for a data matrix.
%   R = COVF(Z,M)
%
%   Z : An   N x nz data matrix, typically Z=[y u]
%
%   M: The maximum delay - 1, for which the covariance function is estimated
%   R: The covariance function of Z, returned so that the entry
%   R((i+(j-1)*nz,k+1) is  the estimate of E Zi(t) * Zj(t+k)
%   The size of R is thus nz^2 x M.
%   For complex data z, RESHAPE(R(:,k+1),nz,nz) = E z(t)*z'(t+k)
%   (z' is complex conjugate, transpose)
%
%   For nz<3, an FFT algorithm is used, memory size permitting.
%   For nz>2, straightforward summation is used (in COVF2)
%
%   The memory trade-off is affected by
%   R = COVF(Z,M,maxsize)
%   See also AUXVAR  for how to use this option.

%   L. Ljung 10-1-86,11-11-94
%   Copyright 1986-2001 The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 2001/04/06 14:21:37 $

if nargin<2
        disp('Usage: R = covf(z,M);')
        return
end
[Ncap,nz]=size(z);
maxsdef=idmsize(Ncap);
if nargin<3,maxsize=maxsdef;end
if isempty(maxsize),maxsize=maxsdef;end
if nz>Ncap, error('The data should be arranged in columns'),return,end

if nz>2  |  Ncap>maxsize/8 | any(any(imag(z)~=0)) , R=covf2(z,M); return,end

nfft = 2.^ceil(log(2*Ncap)/log(2));
Ycap=fft(([z(:,1)' zeros(1,Ncap)]),nfft);
if nz==2, Ucap=fft(([z(:,2)'  zeros(1,Ncap)]),nfft);
           YUcap=Ycap.*conj(Ucap);
           UAcap=abs(Ucap).^2;
           clear Ucap
end
YAcap=abs(Ycap).^2;
clear Ycap
RYcap=fft(YAcap,nfft);
n=length(RYcap);
R=real(RYcap(1:M))/Ncap/n;
clear RYcap
if nz==1,return,end
         RUcap=fft(UAcap,nfft);
         ru=real(RUcap(1:M))/Ncap/n;
         clear RUcap
         RYUcap=fft(YUcap,nfft);
         ryu=real(RYUcap(1:M))/Ncap/n;
         ruy=real(RYUcap(n:-1:n-M+2))/Ncap/n;
         clear RYUcap
R = [R;[ryu(1) ruy];ryu;ru];
function maxdef = idmsize(N,d)
%IDMSIZE   Sets default value for the variable maxsize 
%   See IDPROPS ALGORITHM.
%
%   maxdef = idmsize(N,d)
%
%   N : Number of data points to be processed
%   d : Number of parameters to be estimated
%   maxdef : Default value of maxsize
%
%   USERS WHO WORK WITH VERY LARGE DATA RECORDS AND LARGE MODELS SHOULD
%   TRIM THIS ALGORITHM TO HIS OR HER COMPUTER

%   L. Ljung 10-1-89
%   Copyright 1986-2001 The MathWorks, Inc.
%   $Revision: 1.5 $ $Date: 2001/04/06 14:21:56 $

if nargin<2,
	d=6;
end
if nargin<1,
	N=1000;
end
[cmp,mem] = computer;
if mem<8192, 
	maxdef = 4096;
 else
	 maxdef = 250000;
 end
% The value of maxdef that gives the most efficient computing time
% in the parameter estimation algorithms depends on the memory available
% in the computer.
% The algorithms will work with matrices that are N by d, provided the
% number of elements is less than maxsize. Note that the number d is
% not provided by all of teh estimation algorithms.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            