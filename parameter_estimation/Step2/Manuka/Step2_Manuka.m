% Mnuka doesn't have any removals. so removing model 1's removal
% transitions
tic
%load data:
y=load("manuka_data.mat");
y=y.data; %crew troops

Ty=length(y); %number of days %start day is the day they left Suez 

%pop size:
N=[95 108]; %crew and passengers 
model=1;
groups=2;

np=12; %number of parameters to estimate    


%initial condition:
%asssume there's only 1 exposed troop initially 
st=11; %states per group
ini_state=zeros(1,11*2);
ini_state(2)=1; ini_state(1)=N(1)-1; ini_state(12)=N(2); %first case was among crew 

%ABC-SMC requirements 
B=1000; % number of particles to sample 
G=4; 
eta=1; %number of samples to generate for each parameter set 
%store the final smc-sampled parameters and other needed values in a matrix 
para_hie=zeros(B,np); %parameters estimated

AG=zeros(1,B);%store the # of particles generated to get B parameters(if needed) 

accepted_case_paths=zeros(Ty,B);

%load weights:
w=load("w_smc.mat","w_smc");
w=w.w_smc;

%load independent params:
Manuka_ind_para=load("Manuka_ind_para.mat","para_smc");
Manuka_ind_para=Manuka_ind_para.para_smc;


%tolerances
%cre cases, passenger cases, day7 new cases, euclidean distance for rest,
%deaths 
E=[25 8 25 7 3; 18 7 18 6 2; 10 6 15 5 1; 8 5 12 4 1;14 2 15 4 1]; 

e=E(G,:);

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
rho_m=zeros(B,5);

parfor a=1:B %particle number     
     [para_hie(a,:),rho_m(a,:),AG(a),accepted_case_paths(:,a)]=abc_hie_manuka(ini_state,groups,w,y,e,Manuka_ind_para,hbs(a,:),hb_sigs(a,:),ross(a,:));
end
    

    sx= rho_m;%save the distance criteria

save('s_x_hie.mat','sx');
save('para_hie.mat','para_hie');
save('AG_hie.mat','AG');
save('accepted_case_paths_hie.mat','accepted_case_paths');

    toc
