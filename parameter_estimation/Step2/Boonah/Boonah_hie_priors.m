%%%This function only generates model parameters. 
%%% Time dependent parameters --- removals are generated sperately. seee 

function[prior]=Boonah_hie_priors(Boonah_ind_para,w,hb,hb_sig,ros)

psts=24; %under model 1 

%lower and upper levels for hyper-means
lh=repmat(0.001,1,4);
uh=[10 10 6 5]; %b11, b12,b22, b21

%change this as desired!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
prior_params=zeros(1,psts);

%ros([1 6 11 16])=hb_sig;

ro=reshape(ros,4,4);
ss=diag(hb_sig);
sigma=ss*ro*ss;

betas=zeros(1,4);

while ~(all(betas>lh) && all(betas<uh))
betas= mvnrnd(hb,sigma,1);
end
prior_params([1 11 9 12])=betas;


parss=Boonah_ind_para(:,[2:6 8 13:24]); %7 is zeros, 10 and 8 are the same
ss=std(parss);
p=0;

while p==0
  prass1=parss;
 %find the index to the parameter set to use 
 ind=randsample(1:1000,1,true,w);
 par0=prass1(ind,:);
 par=abs(normrnd(par0,ss));%compoenetwise purturbation 


  p= prod(lognpdf(1/par(1), 0.4039,0.6))*... %asymptomatic recovery 
             prod(lognpdf(1/par(3), 0.4039,0.25))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1/(par(4)),-0.2342,0.35))*... %tau==0
             prod(lognpdf(1/par(2),0.4,0.7))*... %I_s->C
             prod(lognpdf(1/par(5),1.8318,0.6))*...%recovering period:C -> R
             betapdf(par(6),1.5,30)*... %deaths
             unifpdf(par(7),0.4,2)*...
             unifpdf(par(8),0.45,2)*...
             prod(unifpdf(par(9:14),0.0001,10))*...
             unifpdf(par(15),0.05,0.25)*...
             unifpdf(par(16),0.05,0.25)*...
             unifpdf(par(17),0.05,0.5)*... % 6 time dependent paramters 
             unifpdf(par(18),0.0001,10);
end


prior_params([2:8 10 13:24])= [par(1:5) 0 par(6) par(6) par(7:18)]; 

prior=prior_params;

%similar death rates because we don't know  who died 
%between parameters for 2 groups 

end 