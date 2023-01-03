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


eta=1; %number of samples to generate for each parameter set 
B=1000;
%store the final smc-sampled parameters and other needed values in a matrix 
para_hie=zeros(B,np); %parameters estimated
w_smc=zeros(1,B); % store weights
AG=zeros(1,B);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
accepted_crew_paths=zeros(Ty,B);
accepted_troop_paths=zeros(Ty,B);

%tolerances
e=[3 24];

%load weights:
w=load("w_smc.mat","w_smc");
w=w.w_smc;

%load independent params:
Devon_ind_para=load("Devon_ind_para.mat","para_smc");
Devon_ind_para=Devon_ind_para.para_smc;


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
ross=ross(1:40:end,2:end); %take every 40th element 
%INPUTS

parfor a=1:B %particle number     
     [para_hie(a,:),rho_m(a,:),AG(a),accepted_crew_paths(:,a),accepted_troop_paths(:,a)]=abc_hie_devon(Devon_ind_para,w,ini_state,groups,y,e,hbs(a,:),hb_sigs(a,:),ross(a,:));
end
    
    
      sx= rho_m;%save the distance criteria
    


save('s_x_hie.mat','sx');
save('para_hie.mat','para_hie');
save('AG_hie.mat','AG');
save('accepted_crew_paths_hie.mat','accepted_crew_paths');
save('accepted_troop_paths_hie.mat','accepted_troop_paths');

toc
