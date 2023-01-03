
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

function [para,w0,rho0,ag0,inf_start,predicted_paths,death_on_B,deaths_at_Q]= abc_ship_Medic6(Ty,gen,B,pars,model,groups,w,ny,ee,pr_c,inf_who,rem)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;w0=0;
rho0=0;

count=[6 12 34 40 9 37 13:19 41:47 20:23 48:51 26 27 28 54 55 56]; 

parss=pars; 


while(aa<2)
    ag=ag+1;
 if gen==1 
            
            par=model1_priors(groups);
           [ini_states,inf_start]=ini_state_calc(model);
            % nn=find(in_st~=0);%states that needs estimations ;
        %nn=length(ini_states)/groups;
 else    
        
       
        %find the index to the parameter set to use 
        ind=randsample(1:B,1,true,w);
        inf_start=inf_who(ind);
        ini_states=ini_state_perturb(model,inf_start);
        par0=pars(ind,:);

         % perturbations:
       
    
        ss=std(parss);
        par=abs(normrnd(par0,ss));%compoenetwise purturbation 
           
 end  
         
      p00=prod(unifpdf([par(1) par(11)],0.001,10))*... %transmission within
             prod(unifpdf([par(9) par(12)],0.001,5))*...  %transmission between
             prod(lognpdf(1/par(2), 0.4039,0.6))*... %asymptomatic recovery 
             prod(lognpdf(1/par(4), 0.4039,0.25))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1/(par(5)*(1-par(7))),-0.2342,0.35))*...%presymtomatic: up-to one day I_p -> I_s
             prod(lognpdf(1/par(3),0.4,0.7))*... %I_s->C
             unifpdf(par(7),0.0001,1)*... %tau
             prod(lognpdf(1/par(6),1.8318,0.6))*...%recovering period:C -> R
             prod(betapdf(par(8),1.5,30))*... %deaths for crew and passengers  only 
             prod(betapdf(par(10),1.5,30))*... %deaths for  troops only 
             unifpdf(par(13),0.1,2)*...
             unifpdf(par(14),0.01,2.5)*...
             unifpdf(par(15),0.001,0.15)*...
             unifpdf(par(16),0.15,0.7)*...
             unifpdf(par(17),0.001,10)*...
             unifpdf(par(18),1.5,15); % 6 time dependent paramters 
    
           
         p1=p00;
        %  p1=p00;
         
    if p1>0
                
             
                 [~,daily_cases,~]=Medic_sample_gen_qurantine(groups,par,ini_states,count);
                %#############################
                %overall infections till the epidemic is over, qurantine included:
                inf_g=[52 251];  %remove 10 troops who become infected after isolating 
                %proportions of the infections: 
                deaths=[sum(daily_cases(:,2))+sum(daily_cases(:,29:31),'all') sum(daily_cases(:,4))+sum(daily_cases(:,32:34),'all')];
                ddiff=abs(deaths- [1 21]);
                %medic has 22 deaths, 1 crew, 21 troops, 0 passengers 
                        
                    props=abs([sum(daily_cases(:,1)) sum(daily_cases(:,3))]-inf_g); %total severe case sizes 
                    props3=abs((daily_cases(1:3,1)+ daily_cases(1:3,3))'-ny(1:3)); %initial grumbling 
                    d_prop3=repmat(ee(4),1,3);
                   %count healthy removals: days 10, 11
                    h_d10=abs(sum(daily_cases(10,7:20))-34);%day 10
                    h_d11=abs(sum(daily_cases(11,13:20))-151);%day 11 only troops
                    he=[h_d10 h_d11];
                    %count infectious/ infected removals: days 8,9, 12, 14
                    i_d8=abs(sum(daily_cases(8,21:28))- 82); %crew and troops: severe 32, troops:mild 50
                    i_d9=abs(sum(daily_cases(9,21:28)) - 57); %crew and troops: severe 14, mild 43
                    i_d12=abs(sum(daily_cases(12,[23:24 27:28]))-38); %38 cot cases: troops or crew
                    i_d14=abs(sum(daily_cases(14,21:28))- 108); %crew and troops: 108, include all mild, severe together 
                   in=[i_d8 i_d9 i_d12 i_d14];
                    %all removals
                   
                    removals=[sqrt(sum((he.^2))) sqrt(sum((in.^2)))];
                  
                %########################################
              
                uy=zeros(1,Ty); dy=zeros(1,Ty); udy=zeros(1,Ty);  
                %1) prepare enerated path:
                [euDaily,~,~,~]=dailyE(model, groups,daily_cases, ny',uy',dy',udy'); %u_group_count is not needed

                s1=euDaily(1) ; 
                cond2=((all(props<=pr_c)) && (s1<=ee(1)) && (all(ddiff<=ee(2:3))) && (all(props3<=d_prop3)) &&  (all(removals<=rem)) );                 %if gen==G

            if  cond2 %must satisfy all the distance crtierias 
                 para=par;
                 %store s
                rho0=[s1 ddiff props removals];
                predicted_paths=(daily_cases(:,1))+ (daily_cases(:,3));
                death_on_B=(daily_cases(:,2))+ (daily_cases(:,4))+ (daily_cases(:,31))+ (daily_cases(:,34));
                deaths_at_Q=(daily_cases(:,29))+ (daily_cases(:,30))+ (daily_cases(:,32))+ (daily_cases(:,33));
                %store the weight w
                if gen==1
                    w0=1;
                else
                %denominator:
                     pd1=normpdf(par,parss,ss); pd2=prod(pd1,2);
                        
                       
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

