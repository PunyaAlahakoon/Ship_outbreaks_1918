library(R.matlab)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(ggthemes)
library(wesanderson)
library(RColorBrewer)
library(colorspace)
library(lubridate)

library(readr)
library(grid)
library(gridExtra)
library(GGally)


#read hirarchical paras:
hie_Medic=readMat('Medic_para_hie.mat')
hie_Medic=hie_Medic$para.hie

hie_Boonah=readMat('Boonah_para_hie.mat')
hie_Boonah=hie_Boonah$para.hie


hie_Devon=readMat("Devon_para_hie.mat")
hie_Devon=hie_Devon$para.hie

hie_Manuka=readMat("Manuka_para_hie.mat")
hie_Manuka=hie_Manuka$para.hie

betas<-c("C     C","P     C","C     P","P     P","Ship")

medic_hie_b=data.frame(hie_Medic[,c(1,11,12,9)],as.factor(rep("Medic",1000)))
boonah_hie_b=data.frame(hie_Boonah[,c(1,11,12,9)],as.factor(rep("Boonah",1000)))
devon_hie_b=data.frame(hie_Devon[,c(1,11,12,9)],as.factor(rep("Devon",1000)))
manuka_hie_b=data.frame(hie_Manuka[,c(1,11,12,9)],as.factor(rep("Manuka",1000)))

colnames(medic_hie_b)=colnames(boonah_hie_b)=colnames(devon_hie_b)=colnames(manuka_hie_b)=betas

all_hies=rbind(medic_hie_b,boonah_hie_b,devon_hie_b,manuka_hie_b)


hie_paras<-ggpairs(all_hies, columns = 1:5,
                   aes(color=Ship),
                   diag = list(continuous = wrap("densityDiag", alpha=0.8)),
                   upper = list(continuous =wrap( "density", alpha = 0.8)),
                   lower = list(combo = wrap("facethist", bins = 100, alpha = 0.8)))+
theme_minimal(20) +
  scale_fill_manual(values= c("#1B9E77","#7570B3","#046C9A", "#D69C4E" ))+
  scale_color_manual(values= c("#1B9E77","#7570B3","#046C9A", "#D69C4E"))+
  #  ylim(0,1.25)+
  theme(axis.text=element_text(size=20),
    strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 20),
        strip.text.y = element_text(size = 20))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())

hie_paras

ggsave("transmissions_hie_all.png",last_plot(),height = 23,width = 21)



##calculate HPD intervals:
library(HDInterval)



x=hdi(medic_hie_b)
x

y=apply(medic_hie_b[,1:4],2,median)
y

hbb=hb_sigs[10001:n,]
hb2=hbb[seq(1,nrow(hbb),40),]
x=hdi(hb2)
x

y=apply(hb2,2,median)
y

