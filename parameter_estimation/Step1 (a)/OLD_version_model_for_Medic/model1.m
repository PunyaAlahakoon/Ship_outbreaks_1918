


function [stoi,N, rates, stop1]=model1(g,par)
%st_n=sprintf('STOIQ_%d.mat',mod_s); % added quarantine states 
%st=load(st_n);
st=load('STOIQ_1.mat');
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
    
      N1={@(n) n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)};
       N2={@(n) n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)};
       N3={@(n) n(17)+n(18)+n(19)+n(20)+n(21)+n(22)+n(23)+n(24)};
    if g==1
      N(1)=N1;  
      
       rates={@(n) par(1)*n(1)*(n(3)+n(4)+n(5))/((n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8))-1);
           @(n) par(2)*n(2); @(n) par(3)*n(3); @(n) par(4)*n(2);...
            @(n) par(5)*n(4); @(n) par(6)*n(5); @(n) par(7)*n(6);...
            @(n) par(8)*n(5);  @(n) par(9)*n(1); @(n) par(9)*n(2); @(n) par(9)*n(3);...
            @(n) par(9)*n(4); @(n) par(9)*n(7); @(n) par(9)*n(8);...
            @(n) par(10)*n(5); @(n) par(10)*n(6); @(n) par(10)*n(3)};
        
        stop1=@(n) n(2)==0 && n(3)==0 && n(4)==0 && n(5)==0; 
      
    elseif g==2 
        N(2)=N2;
        
       rates={@(n) n(1)*((par(1)*(n(3)+n(4)+n(5))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)-1))+...
                         (par(21)*(n(11)+n(12)+n(13))/(n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)-1)));      
            @(n) par(2)*n(2); @(n) par(3)*n(3); @(n) par(4)*n(2);...
            @(n) par(5)*n(4); @(n) par(6)*n(5); @(n) par(7)*n(6);...
            @(n) par(8)*n(5);  @(n) par(9)*n(1); @(n) par(9)*n(2); @(n) par(9)*n(3);...
            @(n) par(9)*n(4); @(n) par(9)*n(7); @(n) par(9)*n(8);...
            @(n) par(10)*n(5); @(n) par(10)*n(6); @(n) par(10)*n(3);...
            @(n) n(9)*((par(22)*(n(3)+n(4)+n(5))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)-1))+...
                         (par(11)*(n(11)+n(12)+n(13))/(n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)-1)));  
            @(n) par(12)*n(10); @(n) par(13)*n(11); @(n) par(14)*n(10);...
            @(n) par(15)*n(12); @(n) par(16)*n(13); @(n) par(17)*n(14);...
            @(n) par(18)*n(13);  @(n) par(19)*n(9); @(n) par(19)*n(10); @(n) par(19)*n(11);...
            @(n) par(19)*n(12); @(n) par(19)*n(15); @(n) par(19)*n(16);...
            @(n) par(20)*n(13); @(n) par(20)*n(14); @(n) par(20)*n(11)};
        
           stop1=@(n) n(2)==0 && n(3)==0 && n(4)==0 && n(5)==0 && n(10)==0 && n(11)==0 && n(12)==0 && n(13)==0; 
            
    else %if g==3
             N(3)=N3;
             
            rates={@(n) n(1)*((par(1)*(n(3)+n(4)+n(5))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)-1))+...
                         (par(31)*(n(11)+n(12)+n(13))/(n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)-1))+...
                         (par(32)*(n(19)+n(20)+n(21))/(n(17)+n(18)+n(19)+n(20)+n(21)+n(22)+n(23)+n(24)-1)));...                                                                              );      
            @(n) par(2)*n(2); @(n) par(3)*n(3); @(n) par(4)*n(2);...
            @(n) par(5)*n(4); @(n) par(6)*n(5); @(n) par(7)*n(6);...
            @(n) par(8)*n(5);  @(n) par(9)*n(1); @(n) par(9)*n(2); @(n) par(9)*n(3);...
            @(n) par(9)*n(4); @(n) par(9)*n(7); @(n) par(9)*n(8);...
            @(n) par(10)*n(5); @(n) par(10)*n(6); @(n) par(10)*n(3);...
            @(n) n(9)*((par(33)*(n(3)+n(4)+n(5))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)-1))+...
                        (par(11)*(n(11)+n(12)+n(13))/(n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)-1))+...
                        (par(34)*(n(19)+n(20)+n(21))/(n(17)+n(18)+n(19)+n(20)+n(21)+n(22)+n(23)+n(24)-1)));...                                                                                   );  
            @(n) par(12)*n(10); @(n) par(13)*n(11); @(n) par(14)*n(10);...
            @(n) par(15)*n(12); @(n) par(16)*n(13); @(n) par(17)*n(14);...
            @(n) par(18)*n(13);  @(n) par(19)*n(9); @(n) par(19)*n(10); @(n) par(19)*n(11);...
            @(n) par(19)*n(12); @(n) par(19)*n(15); @(n) par(19)*n(16);...
            @(n) par(20)*n(13); @(n) par(20)*n(14); @(n) par(20)*n(11);...   
            @(n) n(17)*((par(35)*(n(3)+n(4)+n(5))/(n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)-1))+...
                        (par(36)*(n(11)+n(12)+n(13))/(n(9)+n(10)+n(11)+n(12)+n(13)+n(14)+n(15)+n(16)-1))+...
                        (par(21)*(n(19)+n(20)+n(21))/(n(17)+n(18)+n(19)+n(20)+n(21)+n(22)+n(23)+n(24)-1)));...                     
            @(n) par(22)*n(18); @(n) par(23)*n(19); @(n) par(24)*n(18);...
            @(n) par(25)*n(20); @(n) par(26)*n(21); @(n) par(27)*n(22);...
            @(n) par(28)*n(21);  @(n) par(29)*n(17); @(n) par(29)*n(18); @(n) par(29)*n(19);...
            @(n) par(29)*n(20); @(n) par(29)*n(23); @(n) par(29)*n(24);...
            @(n) par(30)*n(21); @(n) par(30)*n(22); @(n) par(30)*n(19)};...   
            
        
           stop1=@(n) n(2)==0 && n(3)==0 && n(4)==0 && n(5)==0 && n(10)==0 && n(11)==0 && n(12)==0 && n(13)==0 && ...
                             n(18)==0 && n(19)==0 && n(20)==0 && n(21)==0; 
    
    end
    

end