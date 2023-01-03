
%input hb, hb_sig and ros as vectors 
%l and u are lower and upper levels for hbs

function[prior]=Devon_hie_priors(Devon_ind_para,w,hb,hb_sig,ros)

%lower and upper levels for hyper-means
lh=repmat(0.001,1,4);
uh=[10 10 6 5]; %b11, b12,b22, b21
psts=12; %under model 0 and no death rates to estimate  

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




parss=Devon_ind_para(:,2:6); %7 is zeros, 10 and 8 are the same
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
             prod(lognpdf(1/par(5),1.8318,0.6)); %recovering period:C -> R
             
end


prior_params(2:6)= par(1:5);

prior=prior_params;

end