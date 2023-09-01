

function[prior]=model1_priors(g)

psts=8; %under model 1 %estimable parameters per group
h=6; %between parameters transmisions%transmission rates: uniform(0.001,5) between groups for medic <-----
%change this as desired!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
prior_params=zeros(g,psts);

%transmission rates: uniform(0.001,10) within groups
bii=unifrnd(0.1,10,g,1);
prior_params(:,1)=bii;

tT=-1;
while tT<=0
%seriel interval, T: exposure, pre-symtomatic, and infectious period 
%taking T~lognormal(1.6086,0.04^2), E(T)=5.02 days , mode=5 days 
%t=lognrnd(1.6110,0.04,g,1);
t=repmat(lognrnd(1.6058,0.06),g,1);

% symptomatic exposure: E -> I_p
%taking Exposure~lognormal(0.4080,0.05^2), mode(Exposure)=1.5 days 
%t_e=lognrnd(0.4080,0.05,g,1);
t_e=repmat(lognrnd(0.4039,0.04),g,1);

%rates:
omega=1./t_e;
prior_params(:,4)=omega;

%presymtomatic: up-to one day I_p -> I_s:: mode=0.7 days 
t_p=repmat(lognrnd(-0.3667,0.1),g,1); 
%rates:
alpha_s=1./t_p;
prior_params(:,5)= alpha_s;

%symptomatic infectious period: I_s -> C
t_s=t-t_e-t_p;
tT=prod(t_s);
end

%rates:
gamma_s=1./t_s;
prior_params(:,6)= gamma_s;

%recovering period: mode=4 days C~lognormal(1.3864,0.01^2) C -> R
t_c=lognrnd(1.3864,0.01,g,1);
%rates:
gamma_c=1./t_c;
prior_params(:,7)= gamma_c;

%ASYMPTOMATIC 
% asymptomatic exposure: E -> A
t_a=repmat(lognrnd(0.4039,0.04),g,1); %mode=1.5 days 
delta=1./t_a;
prior_params(:,2)=delta;

% asymptomatic recovery:::: assume half of gamma_s 
%gamma_a=(gamma_s+gamma_c)./2;
gamma_a=gamma_s./2;
prior_params(:,3)=gamma_a;

%deaths:
d=betarnd(1.5,30,g,1);
%d(1)=lognrnd(0.0100,0.1);%crew mode==1.8
%d(2)=0; %because 0 detahs in the passengers %%!!!!!!!!!!!!!!!!!!!!!!!!!
%d(3)=betarnd(1.5,8);%troops mode==3
prior_params(:,8)=d;

%between parameters for 2 groups 
%bji=repmat(unifrnd(0.001,5),1,2);
bji=unifrnd(0.001,5,1,2);

prior=[reshape(prior_params.',1,[]) bji];
end 