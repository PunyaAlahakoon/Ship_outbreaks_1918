
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

function [para,w0,rho0,ag0,inf_num,predicted_paths,deaths_on_Board,deaths_at_Q]= abc_Boonah(gen,B,pars,model,groups,w,ny,ee,pr_c,inf_who,rem)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;w0=0;
rho0=0;

%Boonah is not considering mild cases 
count=[6 12 34 40 13:19 41:47 20 22 48 50 26:28 54:56]; 

parss=pars; 


while(aa<2)
    ag=ag+1;
 if gen==1 
            
           par=model1_priors_Boonah(groups);
           [ini_states,inf_num]=ini_state_Boonah(model);
            % nn=find(in_st~=0);%states that needs estimations ;
        %nn=length(ini_states)/groups;
 else    
        
       
        %find the index to the parameter set to use 
        ind=randsample(1:B,1,true,w);
        inf_num=inf_who(ind);
        ini_states=ini_state_perturb_Boonah(model,inf_num);
        par0=pars(ind,:);

         % perturbations:
        ss=std(parss);

        par=abs(normrnd(par0,ss));%compoenetwise purturbation 
        par(7)=0; %tau==0 
        par(8)=par(10); %death rates are the same!
           
 end  

    
    
                
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
                
         
                 [~,daily_cases,~]=sample_gen_Boonah(groups,par,ini_states,count);
                %#############################
                %overall infections till the epidemic is over, qurantine included:
                inf_g=[37 422]; %433-infectious while isolating at Adelaide 11 
                %toatal deaths shouls be 18, 5 of them MAYBE on board 
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
                cond2=(prod(all(props<=pr_c)) && (s1<=ee(1)) && (ddiff<=ee(2)) && (B_deaths<=ee(4))&& prod(all(props3<=d_prop3)) && prod(all(removals<=rem)));                 %if gen==G

            if  cond2 %must satisfy all the distance crtierias 
                 para=par;
                 %store s
                rho0=[s1 ddiff props removals];
                predicted_paths=(daily_cases(:,3)); %only consider troops 
                %deaths on board:
                deaths_on_Board=(daily_cases(:,2))+(daily_cases(:,4))+(daily_cases(:,25))+(daily_cases(:,28));
                %deaths at Qurantine station:
                deaths_at_Q=(daily_cases(:,23))+(daily_cases(:,24))+(daily_cases(:,26))+(daily_cases(:,27));
                    
                %store the weight w
                if gen==1
                    w0=1;
                else
                %denominator:
                %remove para 7 and 8:
                parr=[par(1:6) par(9:end)]; parsss=[parss(:,1:6) parss(:,9:end)]; sss=[ss(1:6) ss(9:end)];
                     pd1=normpdf(parr,parsss,sss); pd2=prod(pd1,2);
                        %pd2=prod(pd1,2);
                       
                        pd=pd2;
                     %pd=pd2; 
                     den=w'.*pd;
                     w0=p1/sum(den);   
                end
                %update a=a+1
                aa=aa+1;
                ag0=ag;
            end  
       
    end
end
end

