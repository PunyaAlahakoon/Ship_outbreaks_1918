
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

function [para,w0,rho0,ag0,inf_start,predicted_paths]= abc_ship_Medic3(Ty,gen,B,pars,model,groups,w,ny,ee,pr_c,inf_who)
%model definition 
aa=1; %to make sure that you get an accepted particle from the output 
ag=0; %set the counter
%initilise
para=0;w0=0;
rho0=0;

count=[5 8 22 25]; %get the classes that are observed 
np=size(pars,2);
%parss=[pars(:,1:15) pars(:,17:np)]; 
parss=[pars(:,1:2) pars(:,4:9) pars(:,16:18)]; % remove asymptomatics as well as they are 
%not really purturbated

%ss0=cov(parss); %all the stds  
%ss=nearestSPD(ss0); %estimate

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
       
        %ss=0.1; %take ss=0.1
        %ss=0.01;
        ss=repmat(0.1,1,np);
        %ss(1)=std(parss(:,1)); ss(9)=std(parss(:,9)); 
        ss(1)=0.25; ss(9)=0.25; ss(17)=0.25; ss(18)=0.25;
        par=abs(normrnd(par0,ss));%compoenetwise purturbation 
        %aymptomatic infections:
        par(3)=par(6)/2; 
        par(11)=par(3);
        %par(11)=par(14)/2; %E -> A::: assume half of omega 
          par(10)=par(2) ;   par(12)=par(4);  par(13)=par(5); 
          par(14)=par(6); par(15)=par(7);
          %par(18)=par(17);
        %parr=abs(mvnrnd(par0,ss));%compoenetwise purturbation 
       % par=[parr(1:13) 0 parr(14:length(parr))]; %death rate of passegers is zero 

        
 end  
         %calculate ini states pdf 
         %n=length(nn)/groups; %each group has n initial states that needs estimation
         %ins=reshape(ini_states,groups,n);%convert to a matrix\
        symT=[(1/par(4))+(1/par(5))+(1/par(6)) (1/par(12))+(1/par(13))+(1/par(14))];%seriel interval
        
         p00=prod(unifpdf([par(1) par(9)],0.1,10))*... %transmission within
             prod(unifpdf( par(17:18),0.001,5))*...  %transmission between
             prod(lognpdf(1./[par(2) par(10)], 0.4039,0.04))*... %asymptomatic recovery 
             prod(lognpdf(1./[par(4) par(12)], 0.4039,0.04))*... % symptomatic exposure: E -> I_p
             prod(lognpdf(1./[par(5) par(13)],-0.3667,0.1))*...%presymtomatic: up-to one day I_p -> I_s
             prod(lognpdf(symT,1.6058,0.06))*... %seriel interval, T
             prod(lognpdf(1./[par(7) par(15)],1.3864,0.01))*...%recovering period:C -> R
             prod(betapdf(par(8),1.5,30))*... %deaths for crew and passengers  only 
              prod(betapdf(par(16),1.5,30)); %deaths for  troops only 
    
             
         p1=p00;
        %  p1=p00;
         
    if p1>0
                
                %t_seq=1:stp2;
                %[stoi,~,rates,stp1]=model_medic(model,groups,par);
                %create eta sample sets using Rj:
               % t_seq=1:T; stp2=T;
                %t0=0;
                 [~,daily_cases,~]=Medic_sample_gen_qurantine(groups,par,ini_states,count);
                %#############################
                %overall infections till the epidemic is over, qurantine included:
                inf_g=[52 261]; 
                %proportions of the infections: 
                deaths=[sum(daily_cases(:,2)) sum(daily_cases(:,4))];
                ddiff=abs(deaths- [1 21]);
                %medic has 22 deaths, 1 crew, 21 troops, 0 passengers 
               % ddd=[4 2 25];
                
                    props=abs([sum(daily_cases(:,1)) sum(daily_cases(:,3))]-inf_g);
                    
                      props3=abs((daily_cases(1:3,1)+ daily_cases(1:3,3))'-ny(1:3));
                   % props3=abs((daily_cases(1:8,1)+ daily_cases(1:8,3) +daily_cases(1:8,5))'-ny(1:8));

                    %d_prop3=[repmat(ee(4),1,3) repmat(10,1,5)];
                     d_prop3=repmat(ee(4),1,3);
                  %  d_prop2=[1 2 4 6 8 8 10 15];
                  %  dis_d=abs((daily_cases(8,1)+ daily_cases(8,3) +daily_cases(8,5))-ny(8)); %peak is 52
                    
             
                %########################################
                %calculate euclidian distanes:Y=[ny py iy uy dy udy];
                uy=zeros(1,Ty); dy=zeros(1,Ty); udy=zeros(1,Ty);  
                %1) prepare enerated path:
                [euDaily,~,~,~]=dailyE(model, groups,daily_cases, ny',uy',dy',udy'); %u_group_count is not needed

                s1=euDaily(1) ; 
                %##################END OF MODEL 1 GROUPS=2 DETAILS SPECIFIC
                %INFO######################################################
               % condG=((all(props>=pr_c)) && (s1<=ee(1)) && (all(deaths<=ee(2:3)))&& (all(props3<=d_prop3)) ); %for last gen
               % cond1=((all(props>=pr_c)) && (s1<=ee(1)) && ((props3<=d_prop3))); %for first gen 
              %  cond2=((all(props<=pr_c)) && (s1<=ee(1)) && (all(deaths<=ee(2:3))) && (all(props3<=d_prop3))); %for other gens
                cond2=((all(props<=pr_c)) && (s1<=ee(1)) && (all(ddiff<=ee(2:3))) && (all(props3<=d_prop3)));                 %if gen==G
                
            if  cond2 %must satisfy all the distance crtierias 
                     para=par;
                 %store s
                rho0=[s1 ddiff props];
                predicted_paths=(daily_cases(:,1))+ (daily_cases(:,3));
                %store the weight w
                if gen==1
                    w0=1;
                else
                %denominator:
                      
                        %ssp=[ss(1:13) ss(15:21)];
                       % pd2=mvnpdf(parr,parss,ss); 
                      % parr=[par(:,1:15) par(:,17:np)]; 
                       parr=[par(1:2) par(4:9) par(16:18)];
                       ssp=[ss(1:2) ss(4:9) ss(16:18)];
                          pd1=normpdf(parr,parss,ssp); pd2=prod(pd1,2);
                        %pd2=prod(pd1,2);
                       
                    %pd4=prod(pd3,2);
                    % pd3=repmat(1/5,B,1); %1/5 is the discrete uniform pmf uniform(-2+pars, pars+2) Have B values. change this depending on your unifrom distribution 
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

