%Boonah is not considering mild cases 
count=[6 12 29 35 13:19 36:42 20 22 43 45]; 
%get the classes that are observed 6, 29== (severe) cases, 12, 35==deaths, 
% 13:19 36:42= healthy removal, 20 22 43 45 infectious/inf removal 

groups=2;
model=1;

k=1; %how mant times to repetat each parameter set 
paras=repmat(para_hie,k,1);
%inf_starts=repmat(inf_start,1,k);
B= size(paras,1);
t=35;
predicted_paths=zeros(t,B);
healthy_removals=zeros(t,B);
inf_removals=zeros(t,B);
total_crew_cases=zeros(t,B);
total_passengers_cases=zeros(t,B);
predicted_deaths=zeros(1,B);

 [ini_states,~]=ini_state_Boonah(model); %always the same

parfor j=1:B
   para=paras(j,:); %run every parameter set k times
   [prev,daily_cases,inci]=sample_gen_Boonah(groups,para,ini_states,count);
    predicted_paths(:,j)=(daily_cases(:,1))+ (daily_cases(:,3));
    total_crew_cases(:,j)=(daily_cases(:,1));
    total_passengers_cases(:,j)=(daily_cases(:,3));
    healthy_removals(:,j)=sum(daily_cases(:,5:18),2);
    inf_removals(:,j)=sum(daily_cases(:,19:22),2);
      predicted_deaths(j)=sum(daily_cases(:,2)+daily_cases(:,4));
end

save('boonah_hie_predicted_paths.mat','predicted_paths');
save('boonah_predicted_healthy_removals_hie.mat','healthy_removals');
save('boonah_predicted_inf_removals_hie.mat','inf_removals');
save('boonah_predicted_hie_crew.mat',"total_crew_cases");
save('boonah_predicted_hie_passengers.mat',"total_passengers_cases");
save('boonah_predicted_hie_deaths.mat',"predicted_deaths")
%save('infectiou.mat','inf');