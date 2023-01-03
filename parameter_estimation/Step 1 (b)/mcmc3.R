library(foreach)
library(doParallel)
library(tmvtnorm)
library(R.matlab)
library(trialr)
library(HDInterval)



#spcify starting values for beta gamma mu:
N=50000# %number of MCMC iterations

boonah=readMat('Boonah_para.mat')
boonah=boonah$para.smc

devon=readMat('Devon_para.mat')
devon=devon$para.smc

manuka=readMat('Manuka_para.mat')
manuka=manuka$para.smc

medic=readMat('Medic_para.mat')
medic=medic$para.smc

b11=data.frame(boonah[,1],devon[,1],manuka[,1],medic[,1])
b12=data.frame(boonah[,11],devon[,11],manuka[,11],medic[,11])
b22=data.frame(boonah[,9],devon[,9],manuka[,9],medic[,9])
b21=data.frame(boonah[,12],devon[,12],manuka[,12],medic[,12])

#lower and upper levels for hyper-means
lh=rep(0.001,4)
uh=c(10,10,6,5) #b11, b12,b22, b21

#for sub-pops means 
la=rep(0.001,4)
u_b11=c(10,5,6,10)
u_b12=c(10,3,6,10)
u_b22=c(3.5,6,1.5,5)
u_b21=c(3.5,3,1.5,5)

u_lvs=t(matrix(c(u_b11,u_b12,u_b22,u_b21),nrow=4))

#sigmas=
ls=rep(0,4)
us=c(3.5,3.5, 3.5, 2.5)



weit<-function(lh,uh,la,u_lvs,b11,b12,b22,b21,hs,sig){
  # weights=c()
  output<- foreach (j=1:4,.packages="tmvtnorm",.combine=c) %dopar%  {
    hd_b11=hdi(b11[,j])
    #tb11=b11 %>% filter(between(b11[,j],hd_b11[1],hd_b11[2]))
    #tb11=tb11[,j]
    tb11=subset(b11[,j],b11[,j]>hd_b11[1] & b11[,j]<hd_b11[2])
    
    hd_b12=hdi(b12[,j])
    #tb12=b12 %>% filter(between(b12[,j],hd_b12[1],hd_b12[2]))
    # tb12=tb12[,j]
    tb12=subset(b12[,j],b12[,j]>hd_b12[1] & b12[,j]<hd_b12[2])
    
    
    hd_b22=hdi(b22[,j])
    # tb22=b22 %>% filter(between(b22[,j],hd_b22[1],hd_b22[2]))
    #tb22=tb22[,j]
    tb22=subset(b22[,j],b22[,j]>hd_b22[1] & b22[,j]<hd_b22[2])
    
    hd_b21=hdi(b21[,j])
    # tb21=b21 %>% filter(between(b21[,j],hd_b21[1],hd_b21[2]))
    # tb21=tb21[,j]
    tb21=subset(b21[,j],b21[,j]>hd_b21[1] & b21[,j]<hd_b21[2])
    
    
    ind=min(length(tb11),length(tb12),length(tb22),length(tb21))
    
    x=matrix(c(tb11[1:ind],tb12[1:ind],tb22[1:ind],tb21[1:ind]),ncol=4)
    up=u_lvs[,j]
    pdp=dtmvnorm(x,hs,sig,lower=lh,upper=uh)
    b_11=dunif(tb11[1:ind],la[1],up[1])
    b_12=dunif(tb12[1:ind],la[2],up[2])
    b_22=dunif(tb22[1:ind],la[3],up[3])
    b_21=dunif(tb22[1:ind],la[3],up[3])
    wki=pdp/(b_11*b_12*b_22*b_21)
    #wki=pdp
    #weights[j]=sum(wki)
    sum(wki[wki>0])
  }
  weit=prod(output)
  
  
}


hb=matrix(ncol=4,nrow=N)

hb_sig=matrix(ncol=4,nrow=N)
#ros=vector(mode = "list", length = N)
ros=matrix(ncol=16,nrow=N)
poste=c()

hb[1,1]=1.5
hb[1,2]=1.5
hb[1,3]=1.5
hb[1,4]=1.5

hb_sig[1,1]=0.5
hb_sig[1,2]=0.5
hb_sig[1,3]=0.5
hb_sig[1,4]=0.5

#A=ros[1,1]*hb_sig[1,2]*hb_sig[1,1]
#H=ros[1,2]*hb_sig[1,3]*hb_sig[1,1]
#G=ros[1,3]*hb_sig[1,3]*hb_sig[1,3]

#sigmat=matrix(c(hb_sig[1,1]^2,A,H,A,hb_sig[1,2]^2,G,H,G,hb_sig[1,3]^2),ncol=3)

ss= diag(c(hb_sig[1,1],hb_sig[1,2],hb_sig[1,3],hb_sig[1,4]),nrow = 4)
R=rlkjcorr(1, 4, eta =2) #correlation matrix 
#R=diag(3)
ros[1,]<-as.vector(R)
sigmat=ss*R*ss
sigmai=sigmat
Ri=R
#sigmat=ss*ss

w=weit(lh,uh,la,u_lvs,b11,b12,b22,b21,hb[1,],sigmat)

prior=dunif(hb[1,1],lh[1],uh[1])*dunif(hb[1,2],lh[2],uh[2])*dunif(hb[1,3],lh[3],uh[3])*dunif(hb[1,4],lh[4],uh[4])*dunif(hb_sig[1,1],ls[1],us[1])*dunif(hb_sig[1,2],ls[2],us[2])*dunif(hb_sig[1,3],ls[3],us[3])*dunif(hb_sig[1,4],ls[4],us[4])
poste[1]=w*prior


#MCMC 
for(i in 2:N){
  #sample means=
  #r_b=abs(rmvnorm(1,c(hb[i-1,1],hb_sig[i-1,1]),diag(2)*0.015))
  r_hb=abs(rnorm(1,hb[i-1,1],0.65))
  r_sb=abs(rnorm(1,hb_sig[i-1,1],0.65))
  
  #r_g=abs(rmvnorm(1,c(hb[i-1,2],hb_sig[i-1,2]),diag(2)*0.015))
  r_hg=abs(rnorm(1,hb[i-1,2],0.65))
  r_sg=abs(rnorm(1,hb_sig[i-1,2],0.65))
  
  #r_e=abs(rmvnorm(1,c(hb[i-1,3],hb_sig[i-1,3]),diag(2)*0.015))
  r_he=abs(rnorm(1,hb[i-1,3],0.65))
  r_se=abs(rnorm(1,hb_sig[i-1,3],0.65))
  
  #r_m=abs(rmvnorm(1,c(hb[i-1,4],hb_sig[i-1,4]),diag(2)*0.015))
  r_hm=abs(rnorm(1,hb[i-1,4],0.65))
  r_sm=abs(rnorm(1,hb_sig[i-1,4],0.65))
  
  #r_hb=abs(rnorm(1,hb[i-1,1],0.1))
  #r_hg=abs(rnorm(1,hb[i-1,2],0.1))
  #r_he=abs(rnorm(1,hb[i-1,3],0.1))
  
  # r_sb=abs(rnorm(1,hb_sig[i-1,1],0.1))
  # r_sg=abs(rnorm(1,hb_sig[i-1,2],0.1))
  #r_se=abs(rnorm(1,hb_sig[i-1,3],0.01))
  
  rh=c(r_hb,r_hg,r_he,r_hm)
  ss=diag(c(r_sb,r_sg,r_se,r_sm))
  R=rlkjcorr(1, 4, eta = 2) #correlation matric 
  
  sigmat=ss*R*ss
  #sigmat=ss*ss
  
  
  w=weit(lh,uh,la,u_lvs,b11,b12,b22,b21,rh,sigmat)
  prior=dunif(r_hb,lh[1],uh[1])*dunif(r_hg,lh[2],uh[2])*dunif(r_he,lh[3],uh[3])*dunif(r_hm,lh[4],uh[4])*dunif(r_sb,ls[1],us[1])*dunif(r_sg,ls[2],us[2])*dunif(r_se,ls[3],us[3])*dunif(r_sm,ls[4],us[4])
  
  ps=w*prior
  
  prop=ps/poste[i-1]
  
  alpha=min(1,prop)
  uu=runif(1)
  
  if (uu<alpha) {
    hb[i,]=rh
    hb_sig[i,1]=r_sb
    hb_sig[i,2]=r_sg
    hb_sig[i,3]=r_se
    hb_sig[i,4]=r_sm
    poste[i]=ps
    ros[i,]<-as.vector(R)
  } else{
    
    hb[i,]= hb[i-1,]
    hb_sig[i,1]=hb_sig[i-1,1]
    hb_sig[i,2]=hb_sig[i-1,2]
    hb_sig[i,3]=hb_sig[i-1,3]
    hb_sig[i,4]=hb_sig[i-1,4]
    poste[i]=poste[i-1] 
    ros[i,]<-ros[i-1,]
  }
}

plot(hb[,1],type="l")
plot(hb_sig[,1],type="l")
plot(hb[,2],type="l")
plot(hb_sig[,2],type="l")
plot(hb[,3],type="l")
plot(hb_sig[,3],type="l")
plot(hb[,4],type="l")
plot(hb_sig[,4],type="l")

write.csv(hb,'hb8.csv')
write.csv(hb_sig,'hb_sig8.csv')
write.csv(ros,'ros8.csv')
