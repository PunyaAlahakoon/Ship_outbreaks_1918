
function[output_summary]=simulator_Manuka(pars,k,ny)
outputs=zeros(k,5);
parfor j=1:k
groups=2;
%st=11; %states per group
N=[95 108]; %crew and passengers 
ini_state=zeros(1,11*2);
ini_state(2)=1; ini_state(1)=N(1)-1; ini_state(12)=N(2); %first case was among crew 


count=[6 18 12 24]; %6, 18 new cases. 12, 24--- deaths 
[~,daily_cases,~]=manuka_sample_gen(groups,pars,ini_state,count);
                inf_g=[32 9];  
                %proportions of the infections: 
                crw_cases=daily_cases(:,1);
                trp_cases=daily_cases(:,2);
                
                Tt_cases=abs(inf_g-[sum(crw_cases) sum(trp_cases)]);
                
                all_cases=sum(daily_cases,2);
                d7_cases=abs(29-sum(all_cases(1:7)));
                
                oth_cases=abs(ny(8:end)-all_cases(8:end));
                ot_E=sqrt(sum((oth_cases.^2))); %euclidean distance

                %deaths:
                deaths=abs(1-sum(daily_cases(:,3:4),'all'));

                rho0=[Tt_cases d7_cases ot_E deaths];
                outputs(j,:)=rho0;

end
mo=mean(outputs,1); 
vo=var(outputs,1);
output_summary={mo vo};
end