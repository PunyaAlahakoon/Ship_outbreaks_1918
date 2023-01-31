


function[output_summary]=simulator_Boonah(pars,k,ny)
outputs=zeros(k,46);
parfor j=1:k
model=1;
groups=2;
rt=7;
%inf_g=[52 261]; 
count=[6 12 29 35 13:19 36:42 20 22 43 45]; 
[ini_states,~]=ini_state_Boonah(model);
[~,daily_cases,~]=sample_gen_Boonah(groups,pars,ini_states,count);
Daily=daily_cases(:,3); %consider troops only 
deaths=sum(daily_cases(:,2))+ sum(daily_cases(:,4)); 
 ddiff=abs(deaths- 18);
props=([sum(daily_cases(:,1)) sum(daily_cases(:,3))]);   %total case sizes 
%ini3=((daily_cases(1:3,1)+ daily_cases(1:3,3))'); %initial grumbling  
%infectious removals of troops 
i_rt= abs(sum(daily_cases([18:25 29]-rt,21:22),2)-[150; 86; 64; 9; 8; 7; 4; 2;4]); 

i_E=sqrt(sum((i_rt.^2))); %euclidean distance for remomval of inf troops 

%healthy-- removals of troops at Fremantle 
h_rtF=abs(sum(daily_cases(18:26-rt,12:18),'all')-149);
%healthy-- removals of troops at Albany
h_rtA=abs(sum(daily_cases(21:31-rt,12:18),'all')-3);
he=[h_rtF h_rtA];   %healthy removals of troops absolute values
he_E=sqrt(sum((he.^2))); %euclidean distance for healthy removal of troops 

%removal of inf/ healthy crew
hi_rc=abs(sum(daily_cases(18:26-rt,[5:11 19:20]),'all')-78);

euDaily=dailyE_Boonah(model,groups,daily_cases,ny); %Only troop time-series is considered 
  
   outputs(j,:)=[Daily' euDaily ddiff props he i_rt' hi_rc i_E he_E];
   %nums= [Daily'=1:28 euDaily=29 ddiff=30 props=[31 32] he =[33 34] i_rt'=[35:43] hi_rc=44 i_E=45 he_E=46]
end
mo=mean(outputs,1); 
vo=var(outputs,1);
output_summary={mo vo};
end