%SEAAICR model 


function[R]=R0_calc_ships(par)

b11=par(1); b12=par(2); b22=par(3); b21=par(4); delta=par(5); omega=par(6);
ep1=par(7); ep2=par(8); alpha=par(9); tau=par(10); d1=par(11); 
gama=par(12); d2=par(13);


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

R=max(abs(eig(A)));

end

