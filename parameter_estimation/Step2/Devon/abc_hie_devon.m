
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

function [para,rho0,ag0,crew_paths,troop_paths]= abc_hie_devon(Devon_ind_para,w,ini_states,groups,ny,ee,hb,hb_sig,ros)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;
rho0=0;

count=[6 18]; %Devon only have time-series data for crew and troops



while(aa<2)
    ag=ag+1;

            
           par=Devon_hie_priors(Devon_ind_para,w,hb,hb_sig,ros);
  
                
             p00=unifpdf(par(1),0.001,5)*... %transmission 
                 unifpdf(par(12),0.001,3)*... 
             unifpdf(par(9),0.001,6)*...  %transmission troops
             unifpdf(par(11),0.001,3)*... 
             prod(lognpdf(1/par(2), 0.4039,0.6))*... %asymptomatic recovery 
             prod(lognpdf(1/par(4), 0.4039,0.25))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1/(par(5)),-0.2342,0.35))*... %tau==0
             prod(lognpdf(1/par(3),0.4,0.7))*... %I_s->C
             prod(lognpdf(1/par(6),1.8318,0.6));%recovering period:C -> R
         
           
         p1=p00;
        %  p1=p00;
         
    if p1>0
                

                 [~,daily_cases,~]=devon_sample_gen(groups,par,ini_states,count);
                %#############################
                %overall infections:
             
                %proportions of the infections: 
                crw_cases=abs(ny(:,1)-daily_cases(:,1));
                crw_E=sqrt(sum((crw_cases.^2))); %euclidean distance
                
                trp_cases=abs(ny(:,2)-daily_cases(:,2));
                trp_E=sqrt(sum((trp_cases.^2))); %euclidean distance

                cond= (crw_E<=ee(1)) && (trp_E<=ee(2));
     
             
            if  cond%must satisfy all the distance crtierias 
                para=par;
                 %store s
                rho0=[crw_E trp_E];
                crew_paths=daily_cases(:,1); troop_paths=daily_cases(:,2);
                %store the weight w
                %update a=a+1
                aa=aa+1;
                ag0=ag;
            end  
       
    end
end
end

