%prioirs for model 0 

%%%This function only generates model parameters. 
%%% there are no time dependent parameters for this model 

function[prior]=Manuka_priors(g)

psts=12; %under model 0 and no death rates to estimate  

%change this as desired!!!!!!
prior_params=zeros(1,psts);

%transmission rates: uniform(0.001,10) within groups
prior_params(1)=unifrnd(0.001,6,1,1);
prior_params(11)=unifrnd(0.001,6,1,1);
%bji=repmat(unifrnd(0.001,5),1,2);
prior_params(9)=unifrnd(0.001,1.5,1,1);
prior_params(12)=unifrnd(0.001,3,1,1);
%prior_params(1)=bij(1);prior_params(11)=bij(2);
%ASYMPTOMATIC 
% asymptomatic exposure: E -> A
t_a=lognrnd(0.4039,0.6); %mode=1.5 days 
delta=1/t_a;
prior_params(2)=delta;




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
t_s=lognrnd(0.4,0.7);
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




%deaths:
d=betarnd(1.5,30,1,1);
prior_params(8)=d; prior_params(10)=d; %1 death



prior=prior_params;

end 