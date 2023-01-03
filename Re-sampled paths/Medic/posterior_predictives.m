%Posterior predictives::



%N=[156 4 829]; %initial pop size crew, passengers and troops

%the model to be tested:
model=1; 
groups=2;
count=[6 12 34 40 9 37 13:19 41:47 20:23 48:51 26 27 28 54 55 56];
%paras=[repmat(para_smc(1,:),500,1);repmat(para_smc(3,:),500,1); repmat(para_smc(5,:),500,1)] ;
k=1; %how mant times to repetat each parameter set 
paras=repmat(para_hie,k,1);
inf_starts=repmat(inf_start,1,k);
B=length(inf_starts);
t=22;
predicted_paths=zeros(t,B);
healthy_removals=zeros(t,B);
inf_removals=zeros(t,B);
total_crew_cases=zeros(t,B);
total_passengers_cases=zeros(t,B);
predicted_deaths=zeros(t,B);

scenario_predicted_paths=zeros(t,B);
scenario_predicted_deaths=zeros(t,B);

%sus=zeros(t,B); %sample paths 
%inf=zeros(t,B); %sample paths 

for j=1:5
     para=paras(j,:); %run every parameter set k times
     ini_sta=ini_state_perturb(model,inf_starts(j));
    [~,daily_cases,daily_no_int,~]=Medic_sample_gen_qurantine_countf(groups,para,ini_sta,count);
    predicted_paths(:,j)=(daily_cases(:,1))+ (daily_cases(:,3));
        total_crew_cases(:,j)=(daily_cases(:,1));
    total_passengers_cases(:,j)=(daily_cases(:,3));
     predicted_deaths(:,j)=(daily_cases(:,2))+ (daily_cases(:,4))+ (daily_cases(:,31))+ (daily_cases(:,34))+(daily_cases(:,29))+ (daily_cases(:,30))+ (daily_cases(:,32))+ (daily_cases(:,33));
    healthy_removals(:,j)=sum(daily_cases(:,5:18),2);
    inf_removals(:,j)=sum(daily_cases(:,19:26),2);
  %  sus(:,j)=path_prev(:,1)+path_prev(:,9);
  
    %inf(:,j)=path_prev(:,5)+path_prev(:,13);
scenario_predicted_paths(:,j)=(daily_no_int(:,1))+ (daily_no_int(:,3));
scenario_predicted_deaths(:,j)=(daily_no_int(:,2))+ (daily_no_int(:,4))+ (daily_no_int(:,31))+ (daily_no_int(:,34));

end



save("medic_scenario_predicted_paths.mat","scenario_predicted_paths");
save("medic_scenario_predicted_deaths.mat","scenario_predicted_deaths");
%save('susceptibles.mat','sus');
save('medic_hie_predicted_paths.mat','predicted_paths');
save('medic_predicted_healthy_removals_hie.mat','healthy_removals');
save('medic_predicted_inf_removals_hie.mat','inf_removals');
save('medic_predicted_hie_crew.mat',"total_crew_cases");
save('medic_predicted_hie_passengers.mat',"total_passengers_cases");
save('medic_predicted_hie_deaths.mat',"predicted_deaths");

%save('infectiou.mat','inf');
