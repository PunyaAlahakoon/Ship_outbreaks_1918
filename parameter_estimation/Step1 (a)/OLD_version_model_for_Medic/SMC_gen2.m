
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
groups=3; %crew, passenger and troops
N=[156 4 829]; %initial pop size crew, passengers and troops


%the model to be tested:
model=1; 
%model conditions :
%t0=0; %start time at the source of infection 
%t_seq=1:Ty;
%stop2=Ty; 
B=500; %number of particles to calculate 

np=30;%number of parameters to estimate  


%ABC-SMC initilisation 
%number of generations to run 
G=3; 
eta=1; %number of samples to generate for each parameter set 

%store the final smc-sampled parameters and other needed values in a matrix 
par_abc=load('para_smc4.mat');
para_smc=par_abc.para_smc; %parameters estimated
w_smc=ones(1,size(para_smc,1)); % store weights
%E_smc=zeros(G+1,1);%tolerance values-- not neccssary unless you decide to
                       %use dynamic methods to calculate the tolarance 
AG_smc=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_sta_abc= load('inf_start4.mat');
inf_start=inf_sta_abc.inf_start; %which group started the infection 
%Store the sets of tolerance values 
% S=[euDaily(1) s2=abs(xtroops-y2);  s3=abs(prevelance throughimes) eudeaths(1,3 groups) <---6 
% tolerances needed 
%E=[90 80 80 60 50]; 
%medic has 22 deaths, 1 crew, 21 troops, 0 passengers 
%eculidian dist data only = 105.8867
E=[100 3 10 2; 50 2 8 2; 100 10 30 2;150 5 28 5;100 3 25 4 ; 90 2 23 3;...
    100 5 25 3]; 
%starting tolerance levels for each pop: starting values 
ee=E(2,:); %this has to be a vector 
sx=zeros(B,3); %summary statistics 

%N=[156 4 829];
%overall infections till the epidemic is over, qurantine included:
inf_g=[52 4 257]; 
%size of infections as a tolerance value:

pr=[50 1 160; 35 0 150; 35 1 160; 20 1 160; 15 1 75; 35 4 170];
    pr_c=pr(2,:);
%set a counter for number of iterations to run for each gen 
%AG=zeros(1,G);
    
gen=2; %start genration 
    
while (gen<1+G) %number of generation 
    %store values for the current generation
    para0=zeros(B,np); %store the sub-pop based beta values from posterior 
    
    w0=zeros(1,B); %store weights 
    ag=0;%set the counter 
    ag0=zeros(1,B);%set the counter 
    rho_m=zeros(B,6);%store the distance values 
    inf_start0=zeros(1,B);
    %INPUTS:(gen,B,pars,inis,model,groups,N, w,Y,inf_groups,e)
    parfor a=1:B %particle number     
     [para0(a,:),w0(a),rho_m(a,:),ag0(a),inf_start0(a)]=abc_ship_Medic3(Ty,gen,B,para_smc,model,groups,w_smc,aly,ee,pr_c,inf_start);
    end
    
    
      sx= rho_m;%save the distance criteria
      ee=E(gen+1,:);
      pr_c=pr(gen+1,:);
        %normalize the weights 
        w0=normalize(w0,'norm',1);
        %replecae the previous gen values from the new gen values
        para_smc=para0; %store the cluster based beta values from posterior 
        w_smc=w0; %store weights 
        AG_smc(gen)=sum(ag0);
        inf_start= inf_start0;
        gen=gen+1 %update the generation number 
end
save('s_x_smc_gen2.mat','sx');
save('para_smc_gen2.mat','para_smc');
save('AG_smc_gen2.mat','AG_smc');
save('w_smc_gen2.mat','w_smc');
save('inf_start_gen2.mat','inf_start');
toc

