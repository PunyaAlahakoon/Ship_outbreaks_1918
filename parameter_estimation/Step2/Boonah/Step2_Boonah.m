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
para_hie=zeros(B,np); %parameters estimated

AG=zeros(1,G);%store the # of particles generated to get B parameters(if needed) 
inf_start=zeros(1,B); %which group started the infection 
INT_paths_T=zeros(Ty,B);
INT_paths_C=zeros(Ty,B);
NO_paths_T=zeros(Ty,B);
NO_paths_C=zeros(Ty,B);
INT_d_B=zeros(Ty,B);
NO_d_B=zeros(Ty,B);
INT_d_Q=zeros(Ty,B);

%tolerances
E=[115 17 6 10; 100 15 6 8; 80 10 6 6; 65 8 6 5; 60 6 6 4; 50 5 6 4]; %euclidean distances
pr=[35 400; 25 300; 20 250; 15 200; 10 150;8 100]; %total cases
rems=[184 149 77; 150 120 70;120 100 60;100 80 50;50 50 30; 45 45 25]; %removals


e=E(G,:); %this has to be a vector 
pr_c=pr(G,:);
rem=rems(G,:);


%load weights:
w=load("w_smc.mat","w_smc");
w=w.w_smc;

%load independent params:
Boonah_ind_para=load("Boonah_ind_para.mat","para_smc");
Boonah_ind_para=Boonah_ind_para.para_smc;

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

%INT_paths_T,INT_paths_C,INT_d_B,NO_d_B,INT_d_Q

parfor a=1:B %particle number     
     [para_hie(a,:),rho_m(a,:),AG(a),inf_start(a),INT_paths_T(:,a),INT_paths_C(:,a),...
         NO_paths_C(:,a),NO_paths_T(:,a),INT_d_B(:,a),NO_d_B(:,a),INT_d_Q(:,a)]=...
         abc_hie_Boonah(Boonah_ind_para,w,hbs(a,:),hb_sigs(a,:),ross(a,:),model,groups,y,e,pr_c,rem)
     a
end
    

 sx= rho_m;%save the distance criteria
 
save('s_x_hie.mat','sx');
save('Boonah_hie_para.mat','para_hie');
save('AG_hie.mat','AG');
%save('w_smc1.mat','w_smc');
save('inf_start_hie.mat','inf_start');
save('INT_paths_T.mat','INT_paths_T'); %troop paths 
save('INT_paths_C.mat','INT_paths_C');
save('NO_paths_T.mat','NO_paths_T'); %troop paths 
save('NO_paths_C.mat','NO_paths_C');
save('INT_d_B.mat',"INT_d_B");
save("NO_d_B.mat","NO_d_B");
save("INT_d_Q.mat","INT_d_Q");

toc