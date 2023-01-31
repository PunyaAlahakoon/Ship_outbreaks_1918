%which parameter combinations gives smaller euclidian distance

    eu=gx(:,23);
    %eu less than 100;
    eu_les=find(eu<=100);
    %get the rest:
    gx2=gx(eu_les,:);
     histogram(x(eu_les,1))
     
     %total infections:
     tot_cr=gx(:,26);
     ci=find(tot_cr>=45 & tot_cr<=55);
     histogram(x(ci,1));
     
     tot_tr=gx(:,27);
     ci=find(tot_tr>=200 & tot_tr<=300);
     histogram(x(ci,1));
    %healthy removals:
    he_rem=gx(:,[28 29]);
    h_d10=find(he_rem(:,1)<=10);
     histogram(x(h_d10,15))
    h_d11=find(he_rem(:,2)<=20);
     histogram(x(h_d11,16))
    %infectious removals:
    i_d8=gx(:,30);
    d8=find( i_d8<=20);
    histogram(x(d8,13))
    i_d9=gx(:,31);
    d9=find( i_d9<=20);
    histogram(x(d9,14))
       
    i_d12=gx(:,32);
    d12=find( i_d12<=20);
     histogram(x(d12,17))
     
    i_d14=gx(:,33);
    d14=find( i_d14<=50);
     histogram(x(d14,18))
     
    d10=gx(:,34);
    h10=find(d10<=40);
    histogram(x(h10,15))
    histogram(x(h10,16))
    
    is=gx(:,35);
    i8=find(is<=100);
    histogram(x(i8,13))
    histogram(x(i8,14))
    histogram(x(i8,17))
    histogram(x(i8,18))
    %deaths:
    deaths=gx2(:,[24 25]);
    d_ind=find(deaths<=[3 10]);
    %total proprtions:
    gx3=gx2(d_ind,:);
    prs=gx3(:,[26 27]);
  