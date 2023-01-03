%this generates a sample path for troops only 

function[prev,daily_c,inci]=sample_gen_Boonah(groups,params,ini_states,count)
rt=0;
tq=35-rt; 


props=zeros(14,3*groups);
props(2:9,5)=params(13:20);
props(2:10,1:2)=params(21);
props(2:10,4)=params(22);
props(12:13,4)=params(23);
props(12,5)=params(24);

nr=size(props,1);
pp=repmat(params(1:12),nr,1); 

%recreate the order as should be included in mode1 function
par=[pp props];

Es=[];
TT=[];
CC=[];

t0=[0 18:25 26 27 29 30 31]-rt; %first start time 
t0(1)=0; %start the epidemic time 
t2=[18 19:26 27 29 30 31 35]-rt; %end time 

i=1;
ini_statei=ini_states;
while i<nr+1
     [stoi,~,Ra,stop1]=model1(groups,par(i,:));   
    [times1,paths1,counters1]=Gillespe7(ini_statei,t0(i),stoi,Ra,stop1,t2(i)+5,1,count);
    e1=paths1{1,1};
    cous=counters1{1,1};
    tt=times1{1,1};
    ind=find(tt<=(t2(i)), 1, 'last' ); %start day 8
     Es=[Es; e1(1:ind,:)];
     TT=[TT tt(1:ind)];
     CC=[CC; cous(1:ind,:)];
     q=round(tt(ind));
    if (stop1(e1(ind,:))==0) %
        i=i+1;
        ini_statei=e1(ind,:);
    else 
        i=nr+1;
    end
      
end

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
