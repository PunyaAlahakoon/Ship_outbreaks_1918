%b11=1; 
b12= 0.01;
b22=0.1; b21=0.01; 
gama=2;
delta=2; omega=0.1; ep1=2;ep2=2;
nu=2;
alpha=2;
d1=0.001;d2=0.0015;
tau=0.001;

b11=.00001:0.01:20;

%ini_state=[999 1 zeros(1,9) 500 zeros(1,10)];
N=[2000 500];

%N=[164 916]; %boonah
%N=[110 924]; %crew and passengers devon
%N=[156 833]; %in medic
%N=[95 108]; %crew and passengers manka 
ini_state=zeros(1,11*2);
ini_state(2)=1; ini_state(1)=N(1)-1; ini_state(12)=N(2);

R_nought=zeros(1,length(b11));
f_s=zeros(1,length(b11));

times=1:1:1000;

for i=1:length(b11)

    b=b11(i);
    para=[b b12 b22 b21 delta omega ep1 ep2 alpha tau d1 gama nu d2];
   R_nought(i)=R0_calc(b, b12, b22,b21,delta,omega,ep1, ep2,alpha,tau,d1,gama,d2);

   a=ODE_F(para,times,ini_state,N);
   f_s(i)=sum(N)-(a(times(end),1)+a(times(end),12));
end

%save("medic_final_size.mat")
hold on 
scatter(R_nought,f_s./sum(N));
%xline(1)