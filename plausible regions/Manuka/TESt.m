N=[95 108];%crew and passengers 
count=[6 18]; 
groups=2;
model=1;
    params=Manuka_priors(groups);
         st=11; %states per group
ini_state=zeros(1,11*2);
ini_state(13)=1; ini_state(1)=N(1); ini_state(12)=N(2)-1;
           
       %   par=[params(1:12) zeros(1,16)];
        %  [stoi,~,Ra,stop1]=model1(groups,par);  
   %[times1,paths1,counters1]=Gillespe7(ini_states,0,stoi,Ra,stop1,20,1,count);
   
tic
[prev,daily_c,inci]=manuka_sample_gen(groups,params,ini_state,count);

figure(1)
plot(sum(daily_c,2));
hold on
plot(data(:,1))




toc