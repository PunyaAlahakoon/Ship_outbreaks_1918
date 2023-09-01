%#########NIAGARA###########################################
%use this to calculate the pop_chages when generating a sample path 


function[prev,daily_c,inci]=Medic_sample_gen_qurantine(groups,params,ini_states,count)
rt=5;%number of days to remove, this code is already t0=2, t0= source of infection 
tq=27-rt; 
%count=[5 7 14 16 23 25]; %
N=[156 833]; %initial pop size crew, passengers and troops
         %t_seq=1:stp2(3);
         m=tq;
         cls=length(ini_states);
         prev=zeros(m,cls);
         daily_c=zeros(m,length(count));
         %daily_c(1,:)=[ini_states(5) 0 ini_states(11) 0 ini_states(17) 0]; %number of infectious people originally
         inci=zeros(m,length(count));

          
props=[zeros(1,4);0 0 0 82/N(2);...
       0 57/(sum(N))  0 57/sum(N);...
       (3/N(1)) 0 (31/N(2)) 0;...
        0 0 (151/N(2)) 0;...
        0 38/sum(N) 0 38/sum(N);...
        zeros(1,4);...
         0 108/sum(N) 0 108/sum(N);...
         zeros(1,4)];
    nr=size(props,1);
    pp=repmat(params,nr,1);    
    
    %recreate the order as should be included in mode1 function
    par=[pp(:,1:8) props(:,1) props(:,2) ...  %group1 
         pp(:,9:16) props(:,3) props(:,4) ... %group 2
          pp(:,17:18)]; %between transmisions 
      
   %Voyage:          
    [stoi,~,Ra,stop1]=model1(groups,par(1,:));   
    [times1,paths1,counters1]=Gillespe7(ini_states,0,stoi,Ra,stop1,20,1,count);
    e1=paths1{1,1};
    cous=counters1{1,1};
    tt=times1{1,1};
    ind=find(tt<=(13-rt), 1, 'last' );
     Es=e1(1:ind,:);
     TT=tt(1:ind);
     CC=cous(1:ind,:);
     q=round(tt(ind));
if (stop1(e1(ind,:))==0) %if there are infectious cases, run another day
    ini_state2=e1(ind,:);%new initial state
     [stoi,~,Ra,stop1]=model1(groups,par(2,:));%new parameters 
    
     [times2,paths2,counters2]=Gillespe7(ini_state2,(13-rt),stoi,Ra,stop1,25,1,count);
       e2=paths2{1,1};
       cous2=counters2{1,1};
       tt2=times2{1,1};
       ind2=find(tt2<(14-rt), 1, 'last' );
            Es=[Es; e2(1:ind2,:)];
            TT=[TT tt2(1:ind2)];
            CC=[CC; cous2(1:ind2,:)];
            q=round(tt2(ind2));
       if (stop1(e2(ind2,:))==0)
           ini_state3=e2(ind2,:);
           [stoi,~,Ra,stop1]=model1(groups,par(3,:));%new parameters 
           [Times3,paths3,counters3]=Gillespe7(ini_state3,(14-rt),stoi,Ra,stop1,26,1,count);
            e3=paths3{1,1};
            cous3=counters3{1,1};
            tt3=Times3{1,1};
            ind3=find(tt3<(15-rt), 1, 'last' );
               Es=[Es; e3(1:ind3,:)];
               TT=[TT tt3(1:ind3)];
               CC=[CC; cous3(1:ind3,:)];
               q=round(tt3(ind3));
            if (stop1(e3(ind3,:))==0)
                ini_state4=e3(ind3,:);
                [stoi,~,Ra,stop1]=model1(groups,par(4,:));%new parameters 
                [Times4,paths4,counters4]=Gillespe7(ini_state4,(15-rt),stoi,Ra,stop1,28,1,count); 
                 e4=paths4{1,1};
                 cous4=counters4{1,1};
                 tt4=Times4{1,1};
                 ind4=find(tt4<(16-rt), 1, 'last' );
                     Es=[Es; e4(1:ind4,:)];
                     TT=[TT tt4(1:ind4)];
                     CC=[CC; cous4(1:ind4,:)];
                     q=round(tt4(ind4));
                 if (stop1(e4(ind4,:))==0)
                     ini_state4=e4(ind4,:);
                     [stoi,~,Ra,stop1]=model1(groups,par(5,:));%new parameters 
                     [Times5,paths5,counters5]=Gillespe7(ini_state4,(16-rt),stoi,Ra,stop1,32,1,count);
                     e5=paths5{1,1};
                     cous5=counters5{1,1};
                     tt5=Times5{1,1}; 
                     ind5=find(tt5<(17-rt), 1, 'last' ); 
                         Es=[Es; e5(1:ind5,:)];
                         TT=[TT tt5(1:ind5)];
                         CC=[CC; cous5(1:ind5,:)];
                         q=round(tt5(ind5));
                      if (stop1(e5(ind5,:))==0)
                          ini_state5=e5(ind5,:);
                          [stoi,~,Ra,stop1]=model1(groups,par(6,:));%new parameters
                          [Times6,paths6,counters6]=Gillespe7(ini_state5,(17-rt),stoi,Ra,stop1,35,1,count);
                           e6=paths6{1,1};
                           cous6=counters6{1,1};
                           tt6=Times6{1,1};
                           ind6=find(tt6<(18-rt), 1, 'last' ); 
                              Es=[Es; e6(1:ind6,:)];
                              TT=[TT tt6(1:ind6)];
                              CC=[CC; cous6(1:ind6,:)];
                              q=round(tt6(ind6));
                            if  (stop1(e6(ind6,:))==0)
                               ini_state6=e6(ind6,:);
                               [stoi,~,Ra,stop1]=model1(groups,par(7,:));%new parameters
                               [Times7,paths7,counters7]=Gillespe7(ini_state6,(18-rt),stoi,Ra,stop1,36,1,count);
                                e7=paths7{1,1};
                                cous7=counters7{1,1};
                                tt7=Times7{1,1};
                                ind7=find(tt7<(19-rt), 1, 'last' ); 
                                Es=[Es; e7(1:ind7,:)];
                                TT=[TT tt7(1:ind7)];
                                CC=[CC; cous7(1:ind7,:)];
                                q=round(tt7(ind7));
                                  
                           if  (stop1(e7(ind7,:))==0)
                               ini_state7=e7(ind7,:);
                               [stoi,~,Ra,stop1]=model1(groups,par(8,:));%new parameters
                               [Times8,paths8,counters8]=Gillespe7(ini_state7,(19-rt),stoi,Ra,stop1,38,1,count);
                                e8=paths8{1,1};
                                cous8=counters8{1,1};
                                tt8=Times8{1,1};
                                ind8=find(tt8<(20-rt), 1, 'last' ); 
                                Es=[Es; e8(1:ind8,:)];
                                TT=[TT tt8(1:ind8)];
                                CC=[CC; cous8(1:ind8,:)];
                                q=round(tt8(ind8));
                                
                                if  (stop1(e8(ind8,:))==0)
                                     ini_state8=e8(ind8,:);
                                    [stoi,~,Ra,stop1]=model1(groups,par(9,:));%new parameters
                                    [Times9,paths9,counters9]=Gillespe7(ini_state8,(20-rt),stoi,Ra,stop1,27,1,count);
                                    e9=paths9{1,1};
                                    cous9=counters9{1,1};
                                    tt9=Times9{1,1};
                                    ind9=find(tt9<=(27-rt), 1, 'last' ); 
                                    Es=[Es; e9(1:ind9,:)];
                                    TT=[TT tt9(1:ind9)];
                                    CC=[CC; cous9(1:ind9,:)];
                                    q=round(tt9(ind9));
                                end
                                    
                                
                           end
                                                        
                           end
   
                      end

                 end    
     
            end
  
       end
end

                        els=ones(1,q+1);
                        for j=1:q
                        l=find(TT<=j, 1, 'last' ); %index of T that is closest to tj
                        els(j+1)=l;
                        prev(j,:)=Es(l,:);
                        nc=CC(els(j):l,:);
                        daily_c(j,:)=sum(nc,1);
                        cc=CC(1:l,:);
                        inci(j,:)=sum(cc,1);%INCIDENCE FROM T=0 TO T=END
                        end 
                          %daily_c(1,:)=[ini_states(5) 0 ini_states(11) 0 ini_states(17) 0]; %number of infectious people originally
end