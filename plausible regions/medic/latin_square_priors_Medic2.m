%psts=number of parameters per group
%groups=number of groups 

%number of samples to generate 
function[prior_params]=latin_square_priors_Medic2(B)
%model 1; 
psts=7; %under model 1 
groups=3;
n=psts*groups;
x= lhsdesign(B,n+2); %2 is for passengers excluded, theta=1; all the time 
%prior distribution intervals:
ino= repmat([0.0005 1.5], n-(groups),1);
inb=repmat([0.001 10], groups,1);
%overall infections till the epidemic is over, qurantine included:
inf_g=[52 257]; 
%proportions of the infections:
N=[156 829]; %initial pop size crew, passengers(excluded) and troops
a=inf_g./N;
inth=[a' ones(2,1)];
in=[inb(1,:); ino(1:6,:); inb(2,:); ino(7:12,:); inb(3,:);  ino(13:18,:); inth];

%use the cdf of a uniform distribution to calculate the sampled values for
%the priors 
priors=zeros(B,n+2);
for i=1:n+2
    ini=in(i,:);%lower and upper level
    xi=x(:,i); %cdf of ith variable 
    priors(:,i)=(xi.*(ini(2)-ini(1)))+ini(1);
end
prior_params=[priors(:,1:n+1) ones(B,1) priors(:,n+2)];
%1:n<-parameters, others: thetas 


end