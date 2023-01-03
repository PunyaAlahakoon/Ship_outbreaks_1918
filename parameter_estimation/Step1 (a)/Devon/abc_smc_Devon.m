% Devon doesn't have any removals. so removing model 1's removal
% transitions
tic
%load data:
y=load("devon_data.mat");
y=y.data; %crew troops

Ty=length(y); %number of days %start day is the day they left Suez 

%pop size:
N=[110 924]; %crew and passengers 
model=1;
groups=2;

np=12; %number of parameters to estimate no death rates to estimate! no deaths!!!   
 %but keeping death rates in the model

%initial condition:
%asssume there's only 1 exposed troop initially 
st=11; %states per group
ini_state=zeros(1,11*2);
ini_state(13)=1; ini_state(1)=N(1); ini_state(12)=N(2)-1;

%ABC-SMC requirements 
B=4; % number of particles to sample 
G=2; 
eta=1; %number of samples to generate for each parameter set 
%store the final smc-sampled parameters and other needed values in a matrix 
para_smc=zeros(B,np); %parameters estimated
w_smc=zeros(1,B); % store weights
AG_smc=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
accepted_crew_paths=zeros(Ty,B);
accepted_troop_paths=zeros(Ty,B);

%tolerances
E=[5 31; 4 28; 3 26; 3 24; 2 20;1 15];
%E=[5 31; 4 28; 3 26; 3 24; 2 20;1 15];

gen=1; %start genration

e=E(1,:);



while (gen<1+G) %number of generation 
    %store values for the current generation
    para0=zeros(B,np); %store the sub-pop based beta values from posterior 
    
    w0=zeros(1,B); %store weights 
    ag=0;%set the counter 
    ag0=zeros(1,B);%set the counter 
    rho_m=zeros(B,2);%store the distance values 
  
    crew_paths0=zeros(Ty,B);
    troop_paths0=zeros(Ty,B);
    %INPUTS:(gen,B,pars,inis,model,groups,N, w,Y,inf_groups,e)
    parfor a=1:B %particle number     
     [para0(a,:),w0(a),rho_m(a,:),ag0(a),crew_paths0(:,a),troop_paths0(:,a)]=abc_devon(gen,B,para_smc,ini_state,groups,w_smc,y,e);
    end
    
    
      sx= rho_m;%save the distance criteria
      e=E(gen+1,:);
   
        %normalize the weights 
        w0=normalize(w0,'norm',1);
        %replecae the previous gen values from the new gen values
        para_smc=para0; %store the cluster based beta values from posterior 
        w_smc=w0; %store weights 
        AG_smc(gen)=sum(ag0);
        accepted_crew_paths=crew_paths0;
        accepted_troop_paths=troop_paths0;
        gen=gen+1 %update the generation number 
end


save('s_x_smc1.mat','sx');
save('para_smc1.mat','para_smc');
save('AG_smc1.mat','AG_smc');
save('w_smc1.mat','w_smc');
save('accepted_crew_paths1.mat','accepted_crew_paths');
save('accepted_troop_paths1.mat','accepted_troop_paths');
toc
