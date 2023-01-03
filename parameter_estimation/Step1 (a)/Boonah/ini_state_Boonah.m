%use this function to figure out whothe initial condition such that the sum
%is equal to the group size 
%inputs: n=number of states per group, Ni=pop size 
%s=total to remove 
%wh= the states as a vector who who needs to be specifically done ___>
%max_s_wh=maximum of the sum of the wh states  
%ind=who started the infection  

function[inii,ei]=ini_state_Boonah(model)
N=[164 916]; %initial pop size crew,  troops
g=2;
if model==1 
   % n=7; %number of parameters per group
    n=14; %numbre of states in the first groups
   % is=2:5;%number of states that need estimation in teh first group 
    
elseif model==2 || model==3 || model==5
    %np=9;    
    n=7;     %is=2:6;`
elseif model==4
    %np=11;    
    n=8;    %is=2:7;
elseif model==6 || model==7 
    %np=14;    
    n=9;    %is=2:8;
elseif model==8
    %np=18;    
    n=11;    %is=2:10;
end  

 

ini=zeros(g,n);
ini(:,1)=N';
%ini(:,2)=ones(3,1); %all the groups start with one exposed person 
%ind=randsample(2,1); %which griup starts the infection
%ini(3,5)=1; %infectious people
%ei=randsample(5,1); %random number of exposed people
ei=1;
ini(2,2)=ei; %trrops start the epidemic
ini(2,1)=N(2)-ei;
inii=reshape(ini.',1,[]);


end

