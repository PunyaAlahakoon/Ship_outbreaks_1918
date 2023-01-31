
function[output_summary]=simulator_Devon(pars,k,ny)
outputs=zeros(k,2);
parfor j=1:k
groups=2;
%st=11; %states per group
N=[110 924]; %crew and passengers 
ini_state=zeros(1,11*2);
ini_state(13)=1; ini_state(1)=N(1); ini_state(12)=N(2)-1;

count=[6 18]; %Devon only have time-series data for crew and troops
[~,daily_cases,~]=devon_sample_gen(groups,pars,ini_state,count);
   crw_cases=abs(ny(:,1)-daily_cases(:,1));
     crw_E=sqrt(sum((crw_cases.^2))); %euclidean distance
                
     trp_cases=abs(ny(:,2)-daily_cases(:,2));
     trp_E=sqrt(sum((trp_cases.^2))); %euclidean distance
    rho0=[crw_E trp_E];
    outputs(j,:)=rho0;

end
mo=mean(outputs,1); 
vo=var(outputs,1);
output_summary={mo vo};
end