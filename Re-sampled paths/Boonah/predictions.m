%Boonah is not considering mild cases 
count=[6 12 34 40 13:19 41:47 20 22 48 50 26:28 54:56]; 
%get the classes that are observed 6, 34== (severe) cases, 12, 40,26:28, 54:56 ==deaths, 
% 13:19 41:47= healthy removal, 20 22 48 50 infectious/inf removal 

groups=2;
model=1;

k=1; %how mant times to repetat each parameter set 
paras=repmat(para_hie,k,1);
%inf_starts=repmat(inf_start,1,k);
B= size(paras,1);
t=35;
predicted_paths=zeros(t,B);
%healthy_removals=zeros(t,B);
%inf_removals=zeros(t,B);
total_crew_cases=zeros(t,B);
total_passengers_cases=zeros(t,B);
predicted_deaths=zeros(t,B);

sc_paths_c=zeros(t,B);
sc_paths_T=zeros(t,B);
sc_d_B=zeros(t,B);

 [ini_states,~]=ini_state_Boonah(model); %always the same

parfor j=1:B
   para=paras(j,:); %run every parameter set k times
   [~,~,daily_cases,daily_no_int]=sample_gen_Boonah_countf(groups,para,ini_states,count);

    predicted_paths(:,j)=(daily_cases(:,1))+ (daily_cases(:,3));
    total_crew_cases(:,j)=(daily_cases(:,1));
    total_passengers_cases(:,j)=(daily_cases(:,3));
   % healthy_removals(:,j)=sum(daily_cases(:,5:18),2);
   % inf_removals(:,j)=sum(daily_cases(:,19:22),2);
      predicted_deaths(:,j)=(daily_cases(:,2))+(daily_cases(:,4))+(daily_cases(:,25))+(daily_cases(:,28))+(daily_cases(:,23))+(daily_cases(:,24))+(daily_cases(:,26))+(daily_cases(:,27));


      %scenario:
       sc_paths_c(:,j)=daily_no_int(:,1);
       sc_paths_T(:,j)=daily_no_int(:,3);
       sc_d_B(:,j)=(daily_no_int(:,2))+(daily_no_int(:,4))+(daily_no_int(:,25))+(daily_no_int(:,28));

end


save('boonah_hie_predicted_paths.mat','predicted_paths');
%save('boonah_predicted_healthy_removals_hie.mat','healthy_removals');
%save('boonah_predicted_inf_removals_hie.mat','inf_removals');
save('boonah_predicted_hie_crew.mat',"total_crew_cases");
save('boonah_predicted_hie_passengers.mat',"total_passengers_cases");
save('boonah_predicted_hie_deaths.mat',"predicted_deaths")
%save('infectiou.mat','inf');

save("boonah_sc_predicted_paths_c.mat","sc_paths_c");
save("boonah_sc_predicted_paths_T.mat","sc_paths_T");
save("boonah_sc_predicted_deaths.mat","sc_d_B");
