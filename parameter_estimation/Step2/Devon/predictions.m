
count=[6 18]; %Devon only have time-series data for crew and troops


N=[110 924]; %crew and passengers 
groups=2;
model=1;

k=1; %how mant times to repetat each parameter set 
paras=repmat(para_hie,k,1);
%inf_starts=repmat(inf_start,1,k);
B= size(paras,1);
t=14;
predicted_crew_paths=zeros(t,B);
predicted_troop_paths=zeros(t,B);


ini_state=zeros(1,11*2);
ini_state(13)=1; ini_state(1)=N(1); ini_state(12)=N(2)-1;

parfor j=1:B
   para=paras(j,:); %run every parameter set k times
   [prev,daily_cases,inci]=devon_sample_gen(groups,para,ini_state,count);
    predicted_crew_paths(:,j)=(daily_cases(:,1));
    predicted_troop_paths(:,j)=(daily_cases(:,2));
end

save('devon_hie_predicted_crew_paths.mat.mat','predicted_crew_paths');
save('devon_hie_predicted_troop_paths.mat.mat','predicted_troop_paths');

%save('infectiou.mat','inf');