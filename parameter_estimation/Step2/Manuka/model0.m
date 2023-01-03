


function [stoi,N, rates, stop1]=model0(g,par)
%st_n=sprintf('STOIQ_%d.mat',mod_s); % added quarantine states 
%st=load(st_n);
st=load('STOI_0.mat');
st=st.S;
[rw, cw]=size(st); %r= number of reactions, c=number of states 

    if g==2%g=2
        stoi=zeros(rw*g,cw*g);
        stoi(1:rw,1:cw)=st;
        stoi(rw+1:rw*2,1+cw:cw*2)=st;
        elseif g==3 %when g=3
        stoi(1:rw,1:cw)=st;
        stoi(rw+1:rw*2,1+cw:cw*2)=st;
        stoi(2*rw+1:rw*g,1+2*cw:cw*g)=st;
        else
        stoi=st; %when g=1
    end
    
      N1={@(n) n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)};
       N2={@(n) n(12)+n(13)+n(14)+n(15)+n(16)+n(17)+n(18)+n(19)+n(20)+n(21)+n(22)};

    if g==1
      N(1)=N1;  
      
       rates={@(n) par(1)*n(1)*(n(3)+n(4)+n(5)+n(6)+n(7))/((n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11))-1);...
           @(n) par(2)*n(2); @(n) par(5)*n(3);@(n) par(3)*n(4); @(n) par(4)*n(2);...
            @(n) (par(5)*(1-par(7)))*n(5); @(n) par(3)*n(6); @(n) par(6)*n(8);...
            @(n) par(5)*par(7)*n(5);  @(n) par(3)*n(7); @(n) par(6)*n(9); @(n) par(8)*n(6); @(n) par(8)*n(8)};
        
        stop1=@(n) n(2)==0 && n(3)==0 && n(4)==0 && n(5)==0 && n(6)==0 && n(7)==0; 
      
    elseif g==2 
        N(2)=N2;
        
       rates={@(n) n(1)*((par(1)*(n(3)+n(4)+n(5)+n(6)+n(7))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)-1))+...
                         (par(11)*(n(14)+n(15)+n(16)+n(17)+n(18))/(n(12)+n(13)+n(14)+n(15)+n(16)+n(17)+n(18)+n(19)+n(20)+n(21)+n(22)-1)));...
            @(n) par(2)*n(2); @(n) par(5)*n(3);@(n) par(3)*n(4); @(n) par(4)*n(2);...
            @(n) (par(5)*(1-par(7)))*n(5); @(n) par(3)*n(6); @(n) par(6)*n(8);...
            @(n) par(5)*par(7)*n(5);  @(n) par(3)*n(7); @(n) par(6)*n(9); @(n) par(8)*n(6); @(n) par(8)*n(8);...
            @(n) n(12)*((par(12)*(n(3)+n(4)+n(5)+n(6)+n(7))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)-1))+...
                         (par(9)*(n(14)+n(15)+n(16)+n(17)+n(18))/(n(12)+n(13)+n(14)+n(15)+n(16)+n(17)+n(18)+n(19)+n(20)+n(21)+n(22)-1)));...                
            @(n) par(2)*n(13); @(n) par(5)*n(14); @(n) par(3)*n(15); @(n) par(4)*n(13);...
            @(n) (par(5)*(1-par(7)))*n(16); @(n) par(3)*n(17); @(n) par(6)*n(19);...
            @(n) par(5)*par(7)*n(16); @(n) par(3)*n(18); @(n) par(6)*n(20); @(n) par(10)*n(17); @(n) par(10)*n(19)};
        
          stop1=@(n) n(2)==0&&n(3)==0&&n(4)==0&&n(5)==0&&n(6)==0&&n(7)==0&&n(13)==0&&n(14)==0&&n(15)==0&&n(16)==0&&n(17)==0&&n(18)==0; 
        %  stop1=@(n) n(2)==0||n(3)==0||n(4)==0||n(5)==0||n(6)==0||n(12)==0||n(13)==0||n(14)==0||n(15)==0||n(16)==0;   
   
    end
    

end