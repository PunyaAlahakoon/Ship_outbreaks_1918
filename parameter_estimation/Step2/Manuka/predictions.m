
count=[6 18 12 24]; %6, 18 new cases. 12, 24--- deaths

N=[95 108]; %crew and passengers 
groups=2;
model=1;

k=1; %how mant times to repetat each parameter set 
paras=repmat(para_hie,k,1);
%inf_starts=repmat(inf_start,1,k);
B= size(paras,1);
t=13;
predicted_paths=zeros(t,B);
predicted_totals_day_7=zeros(1,B);
predicted_deaths=zeros(1,B);

ini_state=zeros(1,11*2);
ini_state(13)=1; ini_state(1)=N(1); ini_state(12)=N(2)-1;

parfor j=1:B
   para=paras(j,:); %run every parameter set k times
   [prev,daily_cases,inci]=manuka_sample_gen(groups,para,ini_state,count);
    predicted_paths(:,j)=(daily_cases(:,1)+daily_cases(:,2));
    predicted_totals_day_7(j)=sum(daily_cases(:,1:2),'all');
    predicted_deaths(j)=sum(daily_cases(:,3:4),'all');
end

save('manuka_predicted_paths_hie.mat','predicted_paths');
save('manuka_predicted_totals_day_7_hie.mat','predicted_totals_day_7');
save('manuka_predicted_deaths_hie.mat','predicted_deaths');

%save('infectiou.mat','inf');