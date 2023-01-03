%ny=daily influenza,uy-daily non-influenza ,dy-influenza
%deaths,udy-non influenza deaths

function[euDaily,eudeaths,infgroup_count,u_group_count]=dailyE(model, groups,daily_cases, ny,uy,dy,udy)
    %models 1-4 do not have non-influenza cases 
    %nned to add initial infectious people as well 
    if model ==1  
        if groups==1
            %7 is deaths
        ox=daily_cases(:,1);%influenza cases 
        dx=sum(daily_cases(:,2));
        infgroup_count=sum(daily_cases(:,1));
        elseif groups==2
        ox=daily_cases(:,1)+daily_cases(:,3);
        dx=sum(daily_cases(:,2)+daily_cases(:,4)); 
        infgroup_count=[sum(daily_cases(:,1)) sum(daily_cases(:,3))];
        elseif groups==3
        ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5);
        dx=sum(daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,6));
        infgroup_count=[sum(daily_cases(:,1)) sum(daily_cases(:,3)) sum(daily_cases(:,5))];
        end
        ux=zeros(length(ox),1); %non-influenza cases
        udx=0;
        u_group_count=0;
        
   
    end
    
    %calculate distance mesasures 
                %influenza:
                ll=[ox ny]; lm=rmmissing(ll);
                l=abs(lm(:,1)-lm(:,2));
                e_in=sqrt(sum((l.^2)));
                %non-influenza:
                mm=[ux uy]; mn=rmmissing(mm);
                l2=abs(mn(:,1)-mn(:,2));
                e_u=sqrt(sum((l2.^2)));

                euDaily=[e_in e_u];
                
                %deaths
                ddy=sum(~isnan(dy)); uudy=sum(~isnan(udy));
                eudeaths=[abs(dx-ddy) abs(udx-uudy)];
end 