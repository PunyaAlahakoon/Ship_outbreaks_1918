
%ABC step 
%INPUT PARAMETERS:
%gen = current generation number 
%B = # of particles to obtain from posterior 
%pars = samples particles in the previous generation 
%inis= inistial states in the previous generation 
%w= weights in the previous generation 
%y= data
%inf_groups= overall infection group counts as a matrix. first row=counts for influnza
%             %by group. second row= counts fo non-influenza by group. Columns=groups 1 2 3  
%e = tolerance value 
%obs=# observed variables to consider as vector 
%G=how many genrations to run. 

function [para,rho0,ag0,inf_num,INT_paths_T,INT_paths_C,NO_paths_c,NO_paths_T,INT_d_B,NO_d_B,INT_d_Q]= abc_hie_Boonah(Boonah_ind_para,w,hb,hb_sig,ros,model,groups,ny,ee,pr_c,rem)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;
rho0=0;

%Boonah is not considering mild cases 
count=[6 12 34 40 13:19 41:47 20 22 48 50 26:28 54:56]; 
%get the classes that are observed 6, 34== (severe) cases, 12, 40,26:28, 54:56 ==deaths, 
% 13:19 41:47= healthy removal, 20 22 48 50 infectious/inf removal 


while(aa<2)
    ag=ag+1;

            
           par=Boonah_hie_priors(Boonah_ind_para,w,hb,hb_sig,ros);
           [ini_states,inf_num]=ini_state_Boonah(model);
            % nn=find(in_st~=0);%states that needs estimations ;
        %nn=length(ini_states)/groups;

         %calculate ini states pdf 
    
    
                
      p00=prod(unifpdf([par(1) par(11)],0.001,10))*... %transmission crew
             prod(unifpdf( [par(9) par(12)],0.001,3.5))*...  %transmission troops
             prod(lognpdf(1/par(2), 0.4039,0.6))*... %asymptomatic recovery 
             prod(lognpdf(1/par(4), 0.4039,0.25))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1/(par(5)),-0.2342,0.35))*... %tau==0
             prod(lognpdf(1/par(3),0.4,0.7))*... %I_s->C
             prod(lognpdf(1/par(6),1.8318,0.6))*...%recovering period:C -> R
             prod(betapdf(par(8),1.5,30))*... %deaths for crew and passengers  only 
             prod(betapdf(par(10),1.5,30))*... %deaths for  troops only            
             unifpdf(par(13),0.4,2)*...
             unifpdf(par(14),0.45,2)*...
             prod(unifpdf(par(15:20),0.0001,10))*...
             unifpdf(par(21),0.05,0.25)*...
             unifpdf(par(22),0.05,0.25)*...
             unifpdf(par(23),0.05,0.5)*... % 6 time dependent paramters 
             unifpdf(par(24),0.0001,10); % 6 
           
         p1=p00;
        %  p1=p00;
         
    if p1>0
                %prev,prev_N,daily_c,daily_no_int
                [~,~,daily_cases,daily_no_int]=sample_gen_Boonah_countf(groups,par,ini_states,count);
                %#############################
                %overall infections till the epidemic is over, qurantine included:
                inf_g=[37 422]; %433-infectious while isolating at Adelaide 11 
                %proportions of the infections: 
                deaths=sum(daily_cases(:,2))+sum(daily_cases(:,4))+  sum(daily_cases(:,23:28),"all");
                ddiff=abs(deaths- 18);
  
                deaths_on_B=sum(daily_cases(:,2))+sum(daily_cases(:,4))+sum(daily_cases(:,25))+sum(daily_cases(:,28));
                B_deaths=abs(deaths_on_B);

                    props=abs([sum(daily_cases(:,1)) sum(daily_cases(:,3))]-inf_g); %total severe case sizes 
                    props3=abs(daily_cases(1:5,3)-ny(1:5)); %initial grumbling 
                    d_prop3=repmat(ee(3),1,5);
          %infectious removals of troops 
i_rt= abs(sum(daily_cases([18:25 29],21:22),2)-[150; 86; 64; 9; 8; 7; 4; 2;4]); 

i_E=sqrt(sum((i_rt.^2))); %euclidean distance for remomval of inf troops 

%healthy-- removals of troops at Fremantle 
h_rtF=abs(sum(daily_cases(18:26,12:18),'all')-149);
%healthy-- removals of troops at Albany
h_rtA=abs(sum(daily_cases(21:31,12:18),'all')-3);
he=[h_rtF h_rtA];   %healthy removals of troops absolute values
he_E=sqrt(sum((he.^2))); %euclidean distance for healthy removal of troops 

%removal of inf/ healthy crew
hi_rc=abs(sum(daily_cases(18:26,[6 5:11 19:20]),'all')-78);
                    
     %all removals
        removals=[i_E he_E hi_rc];
                   % removals=sqrt(sum((rems.^2)));
                %########################################
                euDaily=dailyE_Boonah(model, groups,daily_cases, ny);
                s1=euDaily; 
                cond2=(prod(all(props<=pr_c)) && (s1<=ee(1)) && (ddiff<=ee(2)) && (B_deaths<=ee(4)) && prod(all(props3<=d_prop3)) && prod(all(removals<=rem)));   %if gen==G

            if  cond2 %must satisfy all the distance crtierias 
                 para=par;
                 %store s
                rho0=[s1 ddiff props removals];
                INT_paths_C=(daily_cases(:,1)); 
                INT_paths_T=(daily_cases(:,3)); %only consider troops 
                NO_paths_c=daily_no_int(:,1);
                NO_paths_T=daily_no_int(:,3);
               
                INT_d_B=(daily_cases(:,2))+(daily_cases(:,4))+(daily_cases(:,25))+(daily_cases(:,28));
                INT_d_Q=(daily_cases(:,23))+(daily_cases(:,24))+(daily_cases(:,26))+(daily_cases(:,27));
                NO_d_B=(daily_no_int(:,2))+(daily_no_int(:,4))+(daily_no_int(:,25))+(daily_no_int(:,28));
                %update a=a+1
                aa=aa+1;
                ag0=ag;
            end  
       
    end
end
end

