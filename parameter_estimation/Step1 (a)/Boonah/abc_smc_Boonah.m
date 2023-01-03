tic

%load data:
y=load('boonah_data.mat');
y=y.data;

Ty=length(y);
N=[164 916]; %initial population sizes of crew and troops 
model=1;
groups=2;

np=24; %number of parameters to estimate 
%ABC-SMC initialisation 
B=1000; % number of particles to sample 
G=3; 
eta=1; %number of samples to generate for each parameter set 
%store the final smc-sampled parameters and other needed values in a matrix 
para_smc=zeros(B,np); %parameters estimated
w_smc=zeros(1,B); % store weights
AG_smc=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
accepted_predicted_paths=zeros(Ty,B);
deaths_on_Board=zeros(Ty,B);
deaths_at_Q=zeros(Ty,B);
%tolerances
E=[115 17 6 10; 100 15 6 8; 80 10 6 6; 65 8 6 5; 60 6 6 4; 50 5 6 4]; %euclidean distances
pr=[35 400; 25 300; 20 250; 15 200; 10 150;8 100]; %total cases
rems=[184 149 77; 150 120 70;120 100 60;100 80 50;50 50 30; 45 45 25]; %removals

ee=E(1,:); %this has to be a vector 
pr_c=pr(1,:);
rem=rems(1,:);
sx=zeros(B,3); %s ummary statistics 

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
    deaths_on_Board0=zeros(Ty,B);
    deaths_at_Q0=zeros(Ty,B);
    %INPUTS:(gen,B,pars,inis,model,groups,N, w,Y,inf_groups,e)
    parfor a=1:B %particle number     
     [para0(a,:),w0(a),rho_m(a,:),ag0(a),inf_start0(a),predicted_paths0(:,a),deaths_on_Board0(:,a),deaths_at_Q0(:,a)]=...
         abc_Boonah(gen,B,para_smc,model,groups,w_smc,y,ee,pr_c,inf_start,rem);
     
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
        deaths_on_Board=deaths_on_Board0;
        deaths_at_Q=deaths_at_Q0;
        gen=gen+1 %update the generation number 
end


save('s_x_smc.mat','sx');
save('Boonah_para.mat','para_smc');
save('AG_smc.mat','AG_smc');
save('w_smc.mat','w_smc');
save('inf_start.mat','inf_start');
save('accepted_predicted_paths.mat','accepted_predicted_paths');

toc

