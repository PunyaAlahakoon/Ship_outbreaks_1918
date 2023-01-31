%ny=daily influenza,uy-daily non-influenza ,dy-influenza
%deaths,udy-non influenza deaths
%boonah considers troops cases only 

function[euDaily]=dailyE_Boonah(model, groups,daily_cases, ny)
    %models 1-4 do not have non-influenza cases 
    %nned to add initial infectious people as well 
    if model ==1  
        if groups==1
            %7 is deaths
        ox=daily_cases(:,3);%influenza cases for troops
        elseif groups==2
        ox=daily_cases(:,3);
        elseif groups==3
        ox=daily_cases(:,3);
        end
            
    elseif model==2 || model==3 
        if groups==1
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2);
        elseif groups==2
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,5)+daily_cases(:,6);
        elseif groups==3
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,5)+daily_cases(:,6)+...
                daily_cases(:,9)+daily_cases(:,10);
        end

        
    elseif model==4
        if groups==1
            %6 columns. last 3 deaths
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3);
        elseif groups==2
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)+...
                daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9);
        else% groups==3
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)+...
                daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9)+...
                daily_cases(:,13)+daily_cases(:,14)+daily_cases(:,15);
                  
        end
                               
   
        
    end
    
    %calculate distance mesasures 
                %influenza:
                ll=[ox ny]; lm=rmmissing(ll);
                l=abs(lm(:,1)-lm(:,2));
                e_in=sqrt(sum((l.^2)));


                euDaily=e_in;
                
end 