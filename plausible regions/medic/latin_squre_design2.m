%Inputs: B=number of samples
%rng default % For reproducibility

p=18;%number of parameters to estimate 
n=5; %train the emulator 

%construct the parameter space:
lx=lhsdesign(n*p,p,'Criterion','correlation'); % 'correlation', which minimizes the sum of between-column squared correlations. 

    
x=zeros(n*p,p); %parameter space 
%transmission rates and removal rates p 1,9, 11:18
%ui=[repmat([0.001 5],4,1);repmat([0.001 5],6,1)];
ui=[0.001 10;0.001 5; 0.001 10; 0.001 5;0.001 2;0.001 10;0.001 10; 0.001 10;0.001 10;0.001 10];

x(:,[1 9 11:18])=(lx(:,[1 9 11:18]).* repmat((ui(:,2)-ui(:,1))',n*p,1))+repmat(ui(:,1)',n*p,1);

% para 2: asymptomatic exposure: E -> A lognrnd(0.4039,0.04); %mode=1.5 days 
p2=logninv(lx(:,2),0.4039,0.04);
x(:,2)=1./p2;

%seriel interval, T: exposure, pre-symtomatic, and infectious period 
p36=logninv(lx(:,3),1.6058,0.06);

% symptomatic exposure: E -> I_p lognrnd(0.4039,0.04);
p4=logninv(lx(:,4),0.4039,0.04);
x(:,4)=1./p4;

%presymtomatic: up-to one day I_p -> I_s::  mode=0.7 days lognrnd(-0.3667,0.11); 
p5=logninv(lx(:,5),-0.3667,0.11);
x(:,5)=1./p5;

%symptomatic infectious period: I_s -> C
p3=p36-p4-p5;
x(:,3)=1./p3;

%I_p -> M:: 
%p6=p36(:,2)-p4-p3;
p6=logninv(lx(:,6),1,0.25);
x(:,6)=1./p6;

%recovering period:
p7=logninv(lx(:,7),1.8318,0.2);
x(:,7)=1./p7;

%deaths:
x(:,[8 10])=betainv(lx(:,[8 10]),1.5,30);  
%data=[y deaths props he in];
y=[0 2 0 17 36	41	50	52	35	36	8	11	0	0	5	1	0	1	2	0	1	0];
deaths=[1 21];
inf_g=[52 261]; 
he=[34 151];
in=[82 57 38 108];
data=[y 105 deaths inf_g he in];

J=length(data)+2;

%simulator:
k=2; %number of times the simulator runs 
%for each k, run the simulator and get the outputs:
 gx=zeros(n*p,J);%mean 
 sx=zeros(n*p,J); %variance 
 Ijs=zeros(n*p,J);


 %training data: simulator
parfor i=1:n*p
   %run the simulation 10 times and get the outputs:
   out=simulator_Medic2(x(i,:),k,y);
   gx(i,:)=out{1,1};%means 
   sx(i,:)=out{1,2}; %variances
 
end                                                  

 save('x2.mat','x');
save('gx2.mat','gx');
save('sx2.mat','sx');
