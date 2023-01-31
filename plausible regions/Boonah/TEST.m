
count=[6 29 3 11 26 32]; 
groups=2;
model=1;
    params=model1_priors_Boonah(groups);
           [ini_states,inf_num]=ini_state_Boonah(model);

           
         % par=[params(1:12) zeros(1,16)];
         % [stoi,~,Ra,stop1]=model1(groups,par);  
   %[times1,paths1,counters1]=Gillespe7(ini_states,0,stoi,Ra,stop1,20,1,count);
   
tic
[prev,daily_c,inci]=sample_gen_Boonah(groups,params,ini_states,count);
plot(daily_c(:,2));
hold on
plot(data)

toc