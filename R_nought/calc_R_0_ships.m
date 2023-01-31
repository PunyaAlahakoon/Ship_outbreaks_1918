boonah=load("Boonah_para_hie.mat");
boonah=boonah.para_hie;

devon=load("devon_para_hie.mat");
devon=devon.para_hie;

manuka=load("Manuka_para_hie.mat");
manuka=manuka.para_hie;

medic=load("Medic_para_hie.mat");
medic=medic.para_hie;

para=manuka;

%(b11, b12, b22,b21,delta,omega,ep1, ep2,alpha,tau,d1,gama,d2)

b11=para(:,1); b12=para(:,11); b22=para(:,9); b21=para(:,12);

delta_1_omega=para(:,2);
delta_omega=para(:,4);

delta=delta_1_omega+delta_omega;

omega=delta_omega./delta;

tau=para(:,7);
gama=para(:,3);
alpha=para(:,5);
ep1=alpha;
ep2=gama;
d1=para(:,8);
d2=para(:,10);


r_pa=[b11 b12 b22 b21 delta omega ep1 ep2 alpha tau d1 gama d2];

r_nought=zeros(1,1000);

for i=1:1000
    pa=r_pa(i,:);
    r_nought(i)=R0_calc_ships(pa);
end

histogram(r_nought)
median(r_nought)

save("manuka_r.mat","r_nought")



