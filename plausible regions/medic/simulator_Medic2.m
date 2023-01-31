


function[output_summary]=simulator_Medic2(pars,k,ny)
outputs=zeros(k,35);
parfor j=1:k
model=1;
groups=2;
%inf_g=[52 261]; 
count=[5 11 26 32 8 29 12:17 33:38 18:21 39:42]; %which rates to count 
[ini_states,~]=ini_state_calc(model);
[~,daily_cases,~]=Medic_sample_gen_qurantine(groups,pars,ini_states,count);
Daily=daily_cases(:,1)+daily_cases(:,3);
deaths=[sum(daily_cases(:,2)) sum(daily_cases(:,4))]; 
  ddiff=abs(deaths- [1 21]);
props=([sum(daily_cases(:,1)) sum(daily_cases(:,3))]);   %total severe case sizes 
%ini3=((daily_cases(1:3,1)+ daily_cases(1:3,3))'); %initial grumbling    
h_d10=abs(sum(daily_cases(10,7:18))-34);%day 10
h_d11=abs(sum(daily_cases(11,13:18))-151);%day 11 only troops
he=[h_d10 h_d11];   %healthy removals 
%count infectious/ infected removals: days 8,9, 12, 14
i_d8=abs(sum(daily_cases(8,[19 23 21 22 25 26]))- 82); %crew and troops: severe 32, troops:mild 50
i_d9=abs(sum(daily_cases(9,19:26)) - 57); %crew and troops: severe 14, mild 43
i_d12=abs(sum(daily_cases(12,[19 23 21 25]))-38); %38 cot cases: troops or crew
i_d14=abs(sum(daily_cases(14,19:26))- 108); %crew and troops: 108, include all mild, severe together 
in=[i_d8 i_d9 i_d12 i_d14];  
removals=[sqrt(sum((he.^2))) sqrt(sum((in.^2)))];
[euDaily]=dailyE(model, groups,daily_cases, ny'); %u_group_count is not needed
  
   outputs(j,:)=[Daily' euDaily ddiff props he in removals];
end
mo=mean(outputs,1); 
vo=var(outputs,1);
output_summary={mo vo};
end