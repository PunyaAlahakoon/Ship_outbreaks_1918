%Posterior predictives:



%N=[156 4 829]; %initial pop size crew, passengers and troops

%the model to be tested:
model=1; 
groups=2;
count=[5 8 22 25 ...
    9	10	11	12	13	14	26	27	28	29	30 31 ... %healthy removal
    15 16 17 32 33 34]; %infectious removal 
%paras=[repmat(para_smc(1,:),500,1);repmat(para_smc(3,:),500,1); repmat(para_smc(5,:),500,1)] ;
k=5; %how mant times to repetat each parameter set 
paras=repmat(para_smc,k,1);
inf_starts=repmat(inf_start,1,k);
B=length(inf_starts);
t=22;
predicted_paths=zeros(t,B);
healthy_removals=zeros(t,B);
inf_removals=zeros(t,B);
sus=zeros(t,B); %sample paths 
inf=zeros(t,B); %sample paths 

parfor j=1:B
     para=paras(j,:); %run every parameter set 10 times
     ini_sta=ini_state_perturb(model,inf_starts(j));
     [path_prev,daily_cases,~]=Medic_sample_gen_qurantine(groups,para,ini_sta,count);
    predicted_paths(:,j)=(daily_cases(:,1))+ (daily_cases(:,3));
    healthy_removals(:,j)=sum(daily_cases(:,5:16),2);
    inf_removals(:,j)=sum(daily_cases(:,17:22),2);
    sus(:,j)=path_prev(:,1)+path_prev(:,9);
    inf(:,j)=path_prev(:,5)+path_prev(:,13);
end

save('predicted_paths.mat','predicted_paths');
save('healthy_removals.mat','healthy_removals');
save('inf_removals.mat','inf_removals');
save('susceptibles.mat','sus');
save('infectiou.mat','inf');
