%this generates a sample path for troops only 

function[prev,daily_c,inci]=devon_sample_gen(groups,params,ini_states,count)
rt=0;
tq=14-rt; 



Es=[];
TT=[];
CC=[];

t0=0;%first start time 
t2=tq; %end time

    [stoi,~,Ra,stop1]=model0(groups,params); 
    [times1,paths1,counters1]=Gillespe7(ini_states,t0,stoi,Ra,stop1,t2+2,1,count);
    e1=paths1{1,1};
    cous=counters1{1,1};
    tt=times1{1,1};
    ind=find(tt<=(t2), 1, 'last' ); %start day 8
     Es=[Es; e1(1:ind,:)];
     TT=[TT tt(1:ind)];
     CC=[CC; cous(1:ind,:)];
     q=round(tt(ind));
 
      

    m=tq;
    cls=length(ini_states);
    prev=zeros(m,cls);
    daily_c=zeros(m,length(count));
    %daily_c(1,:)=[ini_states(5) 0 ini_states(11) 0 ini_states(17) 0]; %number of infectious people originally
    inci=zeros(m,length(count));
    
                        els=ones(1,q);
                        for j=1:q
                        m=find(TT>=j, 1, 'first' ); 
                        l=find(TT<j+1, 1, 'last' ); %index of T that is closest to tj
                        els(j)=l;
                        prev(j,:)=Es(l,:);
                        nc=CC(m:l,:);
                        daily_c(j,:)=sum(nc,1);
                        cc=CC(1:l,:);
                        inci(j,:)=sum(cc,1);%INCIDENCE FROM T=0 TO T=END
                        end

end
