%Inputs: B=number of samples
%rng default % For reproducibility
tic 
p=23;%number of parameters to estimate %tau=0 
n=75; %train the emulator 

%construct the parameter space:
lx=lhsdesign(n*p,p,'Criterion','correlation'); % 'correlation', which minimizes the sum of between-column squared correlations. 
lx=[lx(:,1:6) zeros(n*p,1) lx(:,7:23)]; %to make sure tau=0
    
x=zeros(n*p,p+1); %parameter space 
%transmission rates and removal rates p 1,9, 11:18
%ui=[repmat([0.001 5],4,1);repmat([0.001 5],6,1)];
ui=[0.0001 10;0.0001 1.5;0.0001 10;0.0001 1;0.25 1.5;... 
    0.0001 2.5;repmat([0.0001 10],6,1);...
    0.0001 0.5; 0.05 0.8;...
    repmat([0.0001 10],2,1)];
%ui=[0.0001 10;0.0001 10; 0.0001 10; 0.0001 10;0.0001 10;0.0001 10;0.0001 10;0.0001 10;0.0001 10;0.0001 10];

x(:,[1 9 11:24])=(lx(:,[1 9 11:24]).* repmat((ui(:,2)-ui(:,1))',n*p,1))+repmat(ui(:,1)',n*p,1);

% para 2: asymptomatic exposure: E -> A lognrnd(0.4039,0.04); %mode=1.5 days 
p2=logninv(lx(:,2),0.4039,0.04);
x(:,2)=1./p2;

%seriel interval, T: exposure, pre-symtomatic, and infectious period 
p36=logninv(lx(:,3),1.6058,0.06);

% symptomatic exposure: E -> I_p lognrnd(0.4039,0.04);
p4=logninv(lx(:,4),0.4039,0.04);
x(:,4)=1./p4;

%presymtomatic: up-to one day I_p -> I_s::  mode=0.7 days lognrnd(-0.3667,0.11); 
p5=logninv(lx(:,5),-0.3667,0.1); %this is alpha*(1-tau)



%symptomatic infectious period: I_s -> C
p3=p36-p4-p5;
x(:,3)=abs(1./p3);

%I_p -> M:: Tau
%p6=p36(:,2)-p4-p3;
%p7=lx(:,5).*(1-0.0001)+0.0001;
%x(:,7)=p7;
x(:,7)=0;

%alpha:
%x(:,5)=1./(p5.*(1-p7));
x(:,5)=1./p5;
%recovering period:
p6=logninv(lx(:,6),1.8318,0.2);
x(:,6)=1./p6;

%deaths:
x(:,[8 10])=betainv(lx(:,[8 10]),1.5,30);  
%data=[y deaths props he in];
y=load('boonah_data.mat');
y=y.data;
deaths=18;


J=46;

%simulator:
k=25; %number of times the simulator runs 
%for each k, run the simulator and get the outputs:
 gx=zeros(n*p,J);%mean 
 sx=zeros(n*p,J); %variance 
 %Ijs=zeros(n*p,J);


 %training data: simulator
parfor i=1:n*p
   %run the simulation 10 times and get the outputs:
   out=simulator_Boonah(x(i,:),k,y);
   gx(i,:)=out{1,1};%means 
   sx(i,:)=out{1,2}; %variances
 
end                 

 save('x3.mat','x');
save('gx3.mat','gx');
save('sx3.mat','sx');

toc