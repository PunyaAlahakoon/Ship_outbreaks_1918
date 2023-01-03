
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

function [para,w0,rho0,ag0,case_paths]= abc_manuka(gen,B,pars,ini_states,groups,w,ny,ee)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;w0=0;
rho0=0;

count=[6 19 12 13 25 26]; %6, 19 new cases. 12,13  25 26--- deaths 

%get the parameters that only needs perturbations: pars 7 is zero, 8, 10
%are death rates. 8 and 10 are the same. so only perturbating 10
parss=pars(:,[1:6 9:12]); 


while(aa<2)
    ag=ag+1;
 if gen==1 
            
           par=Manuka_priors(groups);
           par1=par([1:6 9:12]);
 else    
        
       
        %find the index to the parameter set to use 
        ind=randsample(1:B,1,true,w);
        
        par0=parss(ind,:);

         % perturbations:
       
          ss=std(parss);
     
        par1=abs(normrnd(par0,ss));%compoenetwise purturbation 
        %add zeros for the 
        par=[par1(1:6) 0 par1(8) par1(7:10)];
      
           
 end  

             
    
                
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
                %store the weight w
                if gen==1
                    w0=1;
                else
                %denominator: considering non-zero parameters only 
                     pd1=normpdf(par1,parss,ss); pd=prod(pd1,2);
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

