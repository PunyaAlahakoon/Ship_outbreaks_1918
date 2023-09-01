
plot(1:22,inf_rem,'--','LineWidth',2)

for i=1:5000
    
    %plot(sus(:,i),inf(:,i))
    plot(1:22,inf_removals(:,i))
    hold on
end

he_rem=[zeros(1,10) 34 151 zeros(1,10)];%healthy removals

inf_rem=[zeros(1,8) 82 57 zeros(1,2) 38 0 108 zeros(1,7)];

aly=[0	2	0	17	36	41	50	52	35	36	8	11	0	0	5	1	0	1	2	0	1	0];