%NOTE---===

%This version adds another stae to the asymptomatics 
%AND larger variances and different priors--- lognormals 

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
para_smc=zeros(B,np); %parameters estimated
w_smc=zeros(1,B); % store weights
%E_smc=zeros(G+1,1);%tolerance values-- not neccssary unless you decide to
                       %use dynamic methods to calculate the tolarance 
AG_smc=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
accepted_predicted_paths=zeros(Ty,B);
death_on_B=zeros(Ty,B);
deaths_at_Q=zeros(Ty,B);

%Store the sets of tolerance values 

%medic has 22 deaths, 1 crew, 21 troops, 0 passengers 
%eculidian dist data only = 105.8867
E=[100 3 10 2; 70 3 10 2;60 3 10 2;55 3 10 2;...
    50 3 10 2; 45 3 10 2;40 3 10 2;35 3 10 2]; 
%size of infections as a tolerance values:
pr=[50 100; 45 80; 40 75;  40 70;  35 65;  30 65; 25 60;20 55];
rems=[154 150; 100 100; 40 60; 35 55;30 50;25 45;20 35;15 30];% % 216.8825
%starting tolerance levels for each pop: starting values 
ee=E(1,:); %this has to be a vector 
pr_c=pr(1,:);
rem=rems(1,:);
sx=zeros(B,3); %s ummary statistics 


%overall infections till the epidemic is over, qurantine included:
inf_g=[52 251]; %remove 10 troops who become infected after isolating 


    
gen=1; %start genration 
    
while (gen<1+G) %number of generation 
    %store values for the current generation
    para0=zeros(B,np); %store the sub-pop based beta values from posterior 
    
    w0=zeros(1,B); %store weights 
    ag=0;%set the counter 
    ag0=zeros(1,B);%set the counter 
    rho_m=zeros(B,7);%store the distance values 
    inf_start0=zeros(1,B);
    predicted_paths0=zeros(Ty,B);
    death_on_B0=zeros(Ty,B);
    deaths_at_Q0=zeros(Ty,B);
    %INPUTS:(gen,B,pars,inis,model,groups,N, w,Y,inf_groups,e)
    parfor a=1:B %particle number     
     [para0(a,:),w0(a),rho_m(a,:),ag0(a),inf_start0(a),predicted_paths0(:,a),death_on_B0(:,a),deaths_at_Q0(:,a)]=abc_ship_Medic6(Ty,gen,B,para_smc,model,groups,w_smc,aly,ee,pr_c,inf_start,rem);
     a
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
        death_on_B=death_on_B0;
        deaths_at_Q=deaths_at_Q0;
        gen=gen+1 %update the generation number 
end

%rems=[repmat(1000,1,6); 50 150 80 50 50 150; 40 100 70 45 40 100;...
  %   30 70 60 35 30 70; 20 60 50 25 20 60; ...
    % 15 50 40 20 15 50];

save('s_x_smc_Medic.mat','sx');
save('ind_para_Medic.mat','para_smc');
save('AG_smc_Medic.mat','AG_smc');
save('w_smc_Medic.mat','w_smc');
save('inf_start_Medic.mat','inf_start');
save('accepted_predicted_paths_Medic.mat','accepted_predicted_paths');
save('death_on_B.mat','death_on_B');
save('deaths_at_Q.mat','deaths_at_Q');

toc

