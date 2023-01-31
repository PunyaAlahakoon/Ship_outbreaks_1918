%SEAAICR model 


function[R]=R0_calc(b11, b12, b22,b21,delta,omega,ep1, ep2,alpha,tau,d1,gama,d2)
F=[0 0 b11 b12 b11 b12 b11 b12 b11 b12 b11 b12;...
   0 0 b21 b22 b21 b22  b21 b22 b21 b22 b21 b22;...
   zeros(10,12)];

V=[delta zeros(1,11);
    0 delta zeros(1,10);
    -delta*(1-omega) 0 ep1 0 0 0 0 0 0 0 0 0;
    0 -delta*(1-omega) 0 ep1 0 0 0 0 0 0 0 0;
    0 0 -ep1 0 ep2 0 0 0 0 0 0 0;
    0 0 0 -ep1 0 ep2 0 0 0 0 0 0;
    -delta*omega zeros(1,5) alpha 0 0 0 0 0;
    0 -delta*omega zeros(1,5) alpha 0 0 0 0;
    zeros(1,6) -alpha*tau 0 gama 0 0 0;
    zeros(1,7) -alpha*tau 0 gama 0 0;
    zeros(1,6) -alpha*(1-tau) 0 0 0 (gama+d1) 0;
    zeros(1,7) -alpha*(1-tau) 0 0 0 (gama+d2)];


in_V=inv(V);

A=F*in_V;

%R=max(abs(eig(A)));
R=(abs(eig(A)));

end

