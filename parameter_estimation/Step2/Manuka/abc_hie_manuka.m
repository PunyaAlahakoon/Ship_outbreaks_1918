
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

function [para,rho0,ag0,case_paths]= abc_hie_manuka(ini_states,groups,w,ny,ee,Manuka_ind_para,hb,hb_sig,ros)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;
rho0=0;

count=[6 19 12 13 25 26]; %6, 19 new cases. 12,13  25 26--- deaths 

%get the parameters that only needs perturbations: pars 7 is zero, 8, 10
%are death rates. 8 and 10 are the same. so only perturbating 10



while(aa<2)
    ag=ag+1;
            
           par=Manuka_hie_priors(Manuka_ind_para,w,hb,hb_sig,ros);
       
             p00=unifpdf(par(1),0.001,6)*... %transmission crew
                 unifpdf(par(11),0.001,6)*...
                 unifpdf(par(9),0.001,1.5)*...
                 unifpdf(par(12),0.001,3)*...
             prod(lognpdf(1/par(2), 0.4039,0.6))*... %asymptomatic recovery 
             prod(lognpdf(1/par(4), 0.4039,0.25))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1/(par(5)),-0.2342,0.35))*... %tau==0
             prod(lognpdf(1/par(3),0.4,0.7))*... %I_s->C
             prod(lognpdf(1/par(6),1.8318,0.6))*...%recovering period:C -> R
             betapdf(par(10),1.5,30);
           
         p1=p00;
        %  p1=p00;
         
    if p1>0
                
                %t_seq=1:stp2;
                %[stoi,~,rates,stp1]=model_medic(model,groups,par);
                %create eta sample sets using Rj:
               % t_seq=1:T; stp2=T;
                %t0=0;
                 [~,daily_cases,~]=manuka_sample_gen(groups,par,ini_states,count);
                %#############################
                %overall infections:
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
                  deaths=abs(1-sum(daily_cases(:,3:6),'all'));

                cond= all(Tt_cases<=ee(1:2)) && (d7_cases<=ee(3)) && (ot_E<=ee(4)) && (deaths<=ee(5));
     
             
            if  cond%must satisfy all the distance crtierias 
                para=par;
                 %store s
                rho0=[Tt_cases d7_cases ot_E deaths];
                case_paths=sum(daily_cases(:,1:2),2);
              
                %update a=a+1
                aa=aa+1;
                ag0=ag;
            end  
       
    end
end
end

