tic
%inset data. day 1 is the source of infection---Wellington 
%ny=[0	0	2	3	0	0	2	0	17	36	41	50	52]; %untial Sydeny Qurantine 
aly=[0 2 0	17	36	41	50	52	35	36	8	11	0	0	5	1	0	1	2	0	1	0];
%aly=[0 17 36	41	50	52	35	36	8	11	0	0	5	1	0	1	2	0	1	0];

%cases on board above 
%there are also some cases that occured while iolating in the qurarantine
%station. They are not included here 

Ty=length(aly); %day 0 is  17 cases 
uy=zeros(1,Ty); dy=zeros(1,Ty); udy=zeros(1,Ty); 
groups=2; %crew, passenger and troops
N=[156 833]; %initial pop size crew, passengers and troops


%the model to be tested:
model=1; 
%model conditions :
%t0=0; %start time at the source of infection 
%t_seq=1:Ty;
%stop2=Ty; 
B=1000; %number of particles to calculate 
np=18;%number of parameters to estimate  


%ABC-SMC initilisation 
%number of generations to run 
G=5; 
eta=1; %number of samples to generate for each parameter set 

%store the final smc-sampled parameters and other needed values in a matrix 
para_hie=zeros(B,np); %parameters estimated

%E_smc=zeros(G+1,1);%tolerance values-- not neccssary unless you decide to
                       %use dynamic methods to calculate the tolarance 
AG=zeros(1,B);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
INT_paths_C=zeros(Ty,B);
NO_paths_C=zeros(Ty,B);
INT_paths_T=zeros(Ty,B);
NO_paths_T=zeros(Ty,B);
INT_d_B=zeros(Ty,B);
NO_d_B=zeros(Ty,B);
INT_d_Q=zeros(Ty,B);

E=[100 3 10 2; 70 3 10 2;60 3 10 2;55 3 10 2;...
    50 3 10 2; 45 3 10 2;40 3 10 2;35 3 10 2]; 

%size of infections as a tolerance values:
pr=[50 100; 45 80; 40 75;  40 70;  35 65; 30 65; 25 60;20 55];
rems=[154 150; 100 100; 40 60; 35 55;30 50;25 45;20 35;15 30];% % 216.8825
%starting tolerance levels for each pop: starting values 
ee=E(G,:); %this has to be a vector 
pr_c=pr(G,:);
rem=rems(G,:);


%N=[156 4 829];
%overall infections till the epidemic is over, qurantine included:
inf_g=[52 251]; %remove 10 troops who become infected after isolating 

%load weights:
w=load("w_smc.mat","w_smc");
w=w.w_smc;

%load independent params:
Medic_ind_para=load("Medic_ind_para.mat","para_smc");
Medic_ind_para=Medic_ind_para.para_smc;

%load hyper parameters
hbs=readtable('hb8.csv');
hbs=table2array(hbs);
hbs=hbs(10001:end,:); %burn-in 
hbs=hbs(1:40:end,2:end); %take every 40th elemnet 

hb_sigs=readtable('hb_sig8.csv');
hb_sigs=table2array(hb_sigs);
hb_sigs=hb_sigs(10001:end,:); %burn-in 
hb_sigs=hb_sigs(1:40:end,2:end); %take every 40th elemnet 


ross=readtable('ros8.csv');
ross=table2array(ross);
ross=ross(10001:end,:); %burn-in 
ross=ross(1:40:end,2:end); %take every 40th element0

%INT_paths_C,INT_paths_T,NO_paths_C,NO_paths_T

parfor a=1:B %particle number     
     [para_hie(a,:),rho_m(a,:),AG(a),inf_start(a),INT_paths_C(:,a),INT_paths_T(:,a),NO_paths_C(:,a),NO_paths_T(:,a),INT_d_B(:,a),NO_d_B(:,a),INT_d_Q(:,a)]...
         =abc_hie_Medic(Medic_ind_para,Ty,model,groups,w,aly,ee,pr_c,rem,hbs(a,:),hb_sigs(a,:),ross(a,:));
     a
end


    sx= rho_m;%save the distance criteria
save('s_x_hie.mat','sx');
save('para_hie.mat','para_hie');
save('AG_hie.mat','AG');
save('inf_start_hie.mat','inf_start');
save('INT_paths_C.mat','INT_paths_C'); %WITH INTERVENTIONS
save('NO_paths_C.mat',"NO_paths_C"); %WITHOUT INTERVENTIONS 
save('INT_paths_T.mat','INT_paths_T'); %WITH INTERVENTIONS
save('NO_paths_T.mat',"NO_paths_T"); %WITHOUT INTERVENTIONS
save('INT_d_B.mat','INT_d_B');
save('INT_d_Q.mat','INT_d_Q');
save('NO_d_B.mat',"NO_d_B");


    toc