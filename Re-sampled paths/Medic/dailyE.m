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
        
    elseif model==2 || model==3 
        if groups==1
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2);
            dx=sum(daily_cases(:,3)+daily_cases(:,4));
            infgroup_count=sum(ox);
        elseif groups==2
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,5)+daily_cases(:,6);
            dx=sum(daily_cases(:,3)+daily_cases(:,4)+daily_cases(:,7)+daily_cases(:,8));
            infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,2)) daily_cases(:,5)+daily_cases(:,6)];
       elseif groups==3
            %4coumns. last 2 columns are deaths 
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,5)+daily_cases(:,6)+...
                daily_cases(:,9)+daily_cases(:,10);
            dx=sum(daily_cases(:,3)+daily_cases(:,4)+daily_cases(:,7)+daily_cases(:,8)+...
               daily_cases(:,11)+daily_cases(:,12));
           infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,2)) daily_cases(:,5)+daily_cases(:,6)...
               sum(daily_cases(:,9)+daily_cases(:,10))];
        end
                ux=zeros(length(ox),1); %non-influenza cases
                udx=0;
                u_group_count=0;
        
    elseif model==4
        if groups==1
            %6 columns. last 3 deaths
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3);
            dx=sum(daily_cases(:,4)+daily_cases(:,5)+daily_cases(:,6));
            infgroup_count=sum(ox);
        elseif groups==2
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)+...
                daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9);
            dx=sum(daily_cases(:,4)+daily_cases(:,5)+daily_cases(:,6)+...
                daily_cases(:,10)+daily_cases(:,11)+daily_cases(:,12));
            infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)) ...
                        sum(daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9))];
        else% groups==3
            ox= daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)+...
                daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9)+...
                daily_cases(:,13)+daily_cases(:,14)+daily_cases(:,15);
            dx=sum(daily_cases(:,4)+daily_cases(:,5)+daily_cases(:,6)+...
                daily_cases(:,10)+daily_cases(:,11)+daily_cases(:,12)+...
              daily_cases(:,16)+daily_cases(:,17)+daily_cases(:,18));
          infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,2)+daily_cases(:,3)) ...
                        sum(daily_cases(:,7)+daily_cases(:,8)+daily_cases(:,9)) ...
                        sum(daily_cases(:,13)+daily_cases(:,14)+daily_cases(:,15))];
            
        end
                ux=zeros(length(ox),1); %non-influenza cases
                udx=0;
                u_group_count=0;
                
    elseif model==5
        if groups==1
            %4 columns 
            ox=daily_cases(:,1);
            ux=daily_cases(:,2);
            dx=sum(daily_cases(:,3));
            udx=sum(daily_cases(:,4));
            infgroup_count=sum(ox);
            u_group_count=sum(ux);
        elseif groups==2
            ox=daily_cases(:,1)+daily_cases(:,5);
            ux=daily_cases(:,2)+daily_cases(:,6);
            dx=sum(daily_cases(:,3)+daily_cases(:,7));
            udx=sum(daily_cases(:,4)+daily_cases(:,8));
            
            infgroup_count=[sum(daily_cases(:,1)) sum(daily_cases(:,5))];
            u_group_count=[sum(daily_cases(:,2)) sum(daily_cases(:,6))];
                
        else% groups==3
            ox=daily_cases(:,1)+daily_cases(:,5)+daily_cases(:,9);
            ux=daily_cases(:,2)+daily_cases(:,6)+daily_cases(:,10);
            dx=sum(daily_cases(:,3)+daily_cases(:,7)+daily_cases(:,11));
            udx=sum(daily_cases(:,4)+daily_cases(:,8)+daily_cases(:,12));
            
            infgroup_count=[sum(daily_cases(:,1)) sum(daily_cases(:,5)) sum(daily_cases(:,9))];
            u_group_count=[sum(daily_cases(:,2)) sum(daily_cases(:,6)) sum(daily_cases(:,10))];
        end
        
    elseif model==6 || model==7
        if groups==1
            %8 columns 
            ox=daily_cases(:,1)+daily_cases(:,3);
            ux=daily_cases(:,2)+daily_cases(:,4);
            dx=sum(daily_cases(:,5)+daily_cases(:,7));
            udx=sum(daily_cases(:,6)+daily_cases(:,8));
            infgroup_count=sum(ox);
            u_group_count=sum(ux);
        elseif groups==2
            ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,9)+daily_cases(:,11);
            ux=daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,10)+daily_cases(:,12);
            dx=sum(daily_cases(:,5)+daily_cases(:,7)+daily_cases(:,13)+daily_cases(:,15));
            udx=sum(daily_cases(:,6)+daily_cases(:,8)+daily_cases(:,14)+daily_cases(:,16));
            infgroup_count=[sum(daily_cases(:,1)+ daily_cases(:,3)) sum(daily_cases(:,9)+daily_cases(:,11))];
            u_group_count=[sum(daily_cases(:,2)+daily_cases(:,4)) sum(daily_cases(:,10)+daily_cases(:,12))];
            
        else%groups==3
            ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,9)+daily_cases(:,11)+...
               daily_cases(:,17)+daily_cases(:,19) ;
            ux=daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,10)+daily_cases(:,12)+...
                daily_cases(:,18)+daily_cases(:,20);
            dx=sum(daily_cases(:,5)+daily_cases(:,7)+daily_cases(:,13)+daily_cases(:,15)+...
                daily_cases(:,21)+daily_cases(:,23));
            udx=sum(daily_cases(:,6)+daily_cases(:,8)+daily_cases(:,14)+daily_cases(:,16)+...
                daily_cases(:,22)+daily_cases(:,24));
            
           infgroup_count=[sum(daily_cases(:,1)+ daily_cases(:,3)) sum(daily_cases(:,9)+daily_cases(:,11)) ...
               sum(daily_cases(:,17)+daily_cases(:,19))];
           
            u_group_count=[sum(daily_cases(:,2)+daily_cases(:,4)) sum(daily_cases(:,10)+daily_cases(:,12)) ...
                sum( daily_cases(:,18)+daily_cases(:,20))];

        end
        
    elseif model==8
         if groups==1
            %12 columns
            ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5);
            ux=daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,6);
            dx=sum(daily_cases(:,7)+daily_cases(:,9)+daily_cases(:,11));
            udx=sum(daily_cases(:,8)+daily_cases(:,10)+daily_cases(:,12));
            infgroup_count=sum(ox);
            u_group_count=sum(ux);
         elseif groups==2
            %12 columns
            ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)+...
                daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17);
            ux=daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,6)+...
                daily_cases(:,14)+daily_cases(:,16)+daily_cases(:,18);
            dx=sum(daily_cases(:,7)+daily_cases(:,9)+daily_cases(:,11)+...
                daily_cases(:,19)+daily_cases(:,21)+daily_cases(:,23));
            udx=sum(daily_cases(:,8)+daily_cases(:,10)+daily_cases(:,12)+...
                    daily_cases(:,20)+daily_cases(:,22)+daily_cases(:,24));
                
            infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)) ...
                        sum(daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17))];
                    
             u_group_count=[sum(daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)) ...
                 sum(daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17))]; 
                
         else %groups==3
            %12 columns
            ox=daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)+...
                daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17)+...
                daily_cases(:,25)+daily_cases(:,27)+daily_cases(:,29);
            ux=daily_cases(:,2)+daily_cases(:,4)+daily_cases(:,6)+...
                daily_cases(:,14)+daily_cases(:,16)+daily_cases(:,18)+...
                daily_cases(:,26)+daily_cases(:,28)+daily_cases(:,30);
            dx=sum(daily_cases(:,7)+daily_cases(:,9)+daily_cases(:,11)+...
                daily_cases(:,19)+daily_cases(:,21)+daily_cases(:,23)+...
                daily_cases(:,31)+daily_cases(:,33)+daily_cases(:,35));
            udx=sum(daily_cases(:,8)+daily_cases(:,10)+daily_cases(:,12)+...
                    daily_cases(:,20)+daily_cases(:,22)+daily_cases(:,24)+...
                    daily_cases(:,32)+daily_cases(:,34)+daily_cases(:,36));
                
            infgroup_count=[sum(daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)) ...
                        sum(daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17)) ...
                        sum(daily_cases(:,25)+daily_cases(:,27)+daily_cases(:,29))];
                    
              u_group_count=[sum(daily_cases(:,1)+daily_cases(:,3)+daily_cases(:,5)) ...
                 sum(daily_cases(:,13)+daily_cases(:,15)+daily_cases(:,17))...
                 sum(daily_cases(:,25)+daily_cases(:,27)+daily_cases(:,29))]; 
         end
        
        
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