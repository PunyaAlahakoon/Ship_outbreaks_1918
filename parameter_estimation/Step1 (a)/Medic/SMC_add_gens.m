
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
G=7; 
gen=5; %start genration 
eta=1; %number of samples to generate for each parameter set 

%store the final smc-sampled parameters and other needed values in a matrix 
para_smc=load('para_smc1.mat'); %parameters estimated
para_smc=para_smc.para_smc;
w_smc=load('w_smc1.mat'); % store weights
w_smc=w_smc.w_smc;
%E_smc=zeros(G+1,1);%tolerance values-- not neccssary unless you decide to
                       %use dynamic methods to calculate the tolarance 
AG_smc=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_start=load('inf_start1.mat'); %which group started the infection 
inf_start=inf_start.inf_start;
accepted_predicted_paths=zeros(Ty,B);
%Store the sets of tolerance values 
% S=[euDaily(1) s2=abs(xtroops-y2);  s3=abs(prevelance throughimes) eudeaths(1,3 groups) <---6 
% tolerances needed 
%E=[90 80 80 60 50]; 
%medic has 22 deaths, 1 crew, 21 troops, 0 passengers 
%eculidian dist data only = 105.8867
E=[100 3 10 2; 70 3 10 2;60 3 10 2;55 3 10 2;...
    50 3 10 2; 45 3 10 2;40 3 10 2;35 3 10 2]; 
%size of infections as a tolerance values:
pr=[50 100; 45 80; 40 75;  40 70;  35 65;  30 65; 25 60;20 55];
rems=[154 150; 100 100; 40 60; 35 55;30 50;25 45;20 35;15 30];% % 216.8825

%rems=[216; 150;100;90;80 ];% zeros removal distance: 154.7805  151.9243 
 % 216.8825
%starting tolerance levels for each pop: starting values 
ee=E(gen,:); %this has to be a vector 
pr_c=pr(gen,:);
rem=rems(gen,:);
sx=zeros(B,3); %summary statistics 

%N=[156 4 829];
%overall infections till the epidemic is over, qurantine included:
inf_g=[52 261]; 

%set a counter for number of iterations to run for each gen 
%AG=zeros(1,G);
    

    
while (gen<1+G) %number of generation 
    %store values for the current generation
    para0=zeros(B,np); %store the sub-pop based beta values from posterior 
    
    w0=zeros(1,B); %store weights 
    ag=0;%set the counter 
    ag0=zeros(1,B);%set the counter 
    rho_m=zeros(B,7);%store the distance values 
    inf_start0=zeros(1,B);
    predicted_paths0=zeros(Ty,B);
    %INPUTS:(gen,B,pars,inis,model,groups,N, w,Y,inf_groups,e)
    parfor a=1:B %particle number     
     [para0(a,:),w0(a),rho_m(a,:),ag0(a),inf_start0(a),predicted_paths0(:,a)]=abc_ship_Medic6(Ty,gen,B,para_smc,model,groups,w_smc,aly,ee,pr_c,inf_start,rem);
    end
    
    
      sx= rho_m;%save the distance criteria
      ee=E(gen+1,:);
      pr_c=pr(gen+1,:);
      rem=rems(gen+1,:);
        %normalize the weights 
        w0=normalize(w0,'norm',1);
        %replecae the previous gen values from the new gen values
        para_smc=para0; %store the cluster based beta values from posterior 
        w_smc=w0; %store weights 
        AG_smc(gen)=sum(ag0);
        inf_start= inf_start0;
        accepted_predicted_paths=predicted_paths0;
        gen=gen+1 %update the generation number 
end


%rems=[repmat(1000,1,6); 50 150 80 50 50 150; 40 100 70 45 40 100;...
  %   30 70 60 35 30 70; 20 60 50 25 20 60; ...
    % 15 50 40 20 15 50];
save('s_x_smc2.mat','sx');
save('para_smc2.mat','para_smc');
save('AG_smc2.mat','AG_smc');
save('w_smc2.mat','w_smc');
save('inf_start2.mat','inf_start');
save('accepted_predicted_paths2.mat','accepted_predicted_paths');
toc

