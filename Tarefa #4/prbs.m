function y=prbs(N,b,m);

% y=prbs(N,b,m)
% generates a PRBS signal with length N and with b  
% bits each value is held during m sampling times.
% For b=8 the PRBS will not be an m-sequence.

% Luis A. Aguirre - BH 18/10/95
% - revision 01/02/1999



y=zeros(1,N);
x=rand(1,b)>0.5;
j=1; % for most cases the XOR of the last bit is with the
% one before the last. The exceptions are
if b==5
   j=2;
elseif b==7
   j=3;
elseif b==9
   j=4;
elseif b==10
   j=3;
elseif b==11
   j=2;
end;
for i=1:N/m
  y(m*(i-1)+1:m*i)=x(b)*ones(1,m);
  x=[ xor(y(m*(i-1)+1),x(b-j)) x(1:b-1)];
end;

