%%%This function only generates model parameters. 
%%% Time dependent parameters --- removals are generated sperately. seee 

function[prior]=model1_priors_Boonah(g)

psts=24; %under model 1 

%change this as desired!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
prior_params=zeros(1,psts);

%transmission rates: uniform(0.001,10) within groups
prior_params([1 11])=unifrnd(0.001,10,g,1);
%bji=repmat(unifrnd(0.001,5),1,2);
prior_params([9 12])=unifrnd(0.001,10,1,2);
%prior_params(1)=bij(1);prior_params(11)=bij(2);
%ASYMPTOMATIC 
% asymptomatic exposure: E -> A
t_a=lognrnd(0.4039,0.6); %mode=1.5 days 
delta=1/t_a;
prior_params(2)=delta;

tT=-1;
while tT<=0
%seriel interval, T: exposure, pre-symtomatic, and infectious period 
%taking T~lognormal(1.6086,0.04^2), E(T)=5.02 days , mode=5 days 
%t=lognrnd(1.6110,0.04,g,1);
t=lognrnd(2.1,0.7);%consider 0.5 var 

% symptomatic exposure: E -> I_p
%taking Exposure~lognormal(0.4080,0.05^2), mode(Exposure)=1.5 days 
%t_e=lognrnd(0.4080,0.05,g,1);
t_e=lognrnd(0.4039,0.25); %conisider 0.2 var

%rates:
omega=1/t_e;
prior_params(4)=omega;

%tau: proportion of people who leaves to become mild cases:
%tau=unifrnd(0.0001,1);
tau=0; %because not enough data about mild cases-- so take them to be zero. 
prior_params(7)=tau; %I_p -> M::

%presymtomatic: up-to one day I_p -> I_s::  mode=0.7 days 
t_ps=lognrnd(-0.2342,0.35); %consider 0.25 var
%rates:
alpha_s_tau=1/t_ps; %this is alpha*(1-tau)

%I_p ->I_s time:
alpha_s=1/(alpha_s_tau*(1-tau));
prior_params(5)= alpha_s; %I_p -> I_s::


%symptomatic infectious period: I_s -> C
t_s=t-t_e-t_ps; 
%I_p -> M:: 
%t_m=t(2)-t_e-t_s;
tT=t_s;
end

%rates:
gamma_s=1/t_s;
prior_params(3)= gamma_s;

%prior_params(7)= 1/t_m;
%prior_params(7)= 1/lognrnd(0.9163,0.2);  %I_p -> M:: average 2.5 days 

%recovering period: mode=4 days C~lognormal(1.3864,0.01^2) C -> R
%t_c=lognrnd(1.3864,0.01);
t_c=lognrnd(1.8318,0.6); %conisder 0.5 var 
%rates:
gamma_c=1./t_c;
prior_params(6)= gamma_c;



% asymptomatic recovery:::: assume half of gamma_s 
%gamma_a=(gamma_s+gamma_c)./2;
%gamma_a=gamma_s./2;
%prior_params(:,3)=gamma_a;

%deaths:
d=betarnd(1.5,30,1,1);
%d(1)=lognrnd(0.01000,0.1);%crew mode==1.8
%d(2)=0; %because 0 detahs in the passengers %%!!!!!!!!!!!!!!!!!!!!!!!!!
%d(3)=betarnd(1.5,8);%troops mode==3
prior_params(8)=d; prior_params(10)=d; %similar death rates because we don't know  who died 

%between parameters for 2 groups 


%thetas: 
prior_params(13:24)=unifrnd(0.001,1,1,12);
%prior_params(13)=unifrnd(0.1,2);
%prior_params(14)=unifrnd(0.01,2.5);
%prior_params(15)=unifrnd(0.001,0.15);
%prior_params(16)=unifrnd(0.15,0.7);
%prior_params(17)=unifrnd(0.001,10);
%prior_params(18)=unifrnd(1.5,15);
%prior=[reshape(prior_params.',1,[]) bji];
prior=prior_params;

end 