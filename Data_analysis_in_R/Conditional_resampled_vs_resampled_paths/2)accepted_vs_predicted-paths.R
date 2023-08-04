#load meeic data:

#hierarchical model:


hie_paths=readMat('medic_hie_predicted_paths.mat')
hie_paths=hie_paths$predicted.paths
#hie_paths=hie_paths[8:22,]

hie_paths_m=melt(hie_paths)
hie_paths_m=data.frame(hie_paths_m,rep("Resampled paths",22000))
#no interventions 

hi_c=readMat("medic_INT_paths_C.mat")
hi_c=hi_c$INT.paths.C

hi_t=readMat("medic_INT_paths_T.mat")
hi_t=hi_t$INT.paths.T

sc_paths=hi_c+hi_t

#sc_paths[1:7,]=NA

sc_paths_m=melt(sc_paths)
sc_paths_m=data.frame(sc_paths_m,rep("Conditional resampled paths",22000))

colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value","Method")
paths=rbind(hie_paths_m,sc_paths_m)




#medic data:
path=c(	0,2,	0	,	17,36,	41,	50,	52,
        35	,36,	8,	11,	0,	0,	5,	1,	0,	1,	2,	0,	1,	0) #untial Sydeny Qurantine 

path=data.frame("Day"=1:length(path),"value"=path)


medic_pred_sp1=subset(paths,Method=="Conditional resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Greens") +
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
medic_pred_sp1


  medic_pred_sp2=subset(paths,Method=="Resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
    geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Purples")+
    theme_minimal() +
    ylim(0,100)+
    ylab("New infections")+
    theme(strip.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          axis.line = element_line(colour = "black"), 
          # axis.title.y=element_blank(),
          strip.text.x = element_blank(),
          strip.text.y = element_text(size = 12))+
    theme(plot.title = element_text(hjust = 0.5))+
    theme(legend.position="none")  +
    theme(legend.title=element_blank())
  medic_pred_sp2
  
  
  
  medic=ggarrange(medic_pred_sp1+rremove("ylab"),medic_pred_sp2+rremove("ylab"), common.legend = T,legend = "none")+ 
    theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))
 
  medic
  medic<- annotate_figure(medic, top = text_grob("Medic", 
                                        color = "Black", face = "bold", size = 14))
  medic
  
  
 



#Boonah

hie_paths=readMat('Boonah_predicted_hie_passengers.mat')
hie_paths=hie_paths$total.passengers.cases
#hie_paths=hie_paths[8:22,]

hie_paths_m=melt(hie_paths)
hie_paths_m=data.frame(hie_paths_m,rep("Resampled paths",35000))
#no interventions 

sc_paths=readMat('INT_paths_T.mat')
sc_paths=sc_paths$INT.paths.T
#sc_paths[1:7,]=NA

sc_paths_m=melt(sc_paths)
sc_paths_m=data.frame(sc_paths_m,rep("Conditional resampled paths",35000))

colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value","Method")
paths=rbind(hie_paths_m,sc_paths_m)

path=readMat("boonah_data.mat")
path=path$data
path=data.frame("Day"=1:nrow(path),"value"=path)



boonah_1=subset(paths,Method=="Conditional resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Greens") +
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
boonah_1


boonah_2=subset(paths,Method=="Resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Purples")+
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
boonah_2



boonah=ggarrange(boonah_1+rremove("ylab"),boonah_2+rremove("ylab"), common.legend = T,legend = "none")+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

boonah
boonah<- annotate_figure(boonah, top = text_grob("Boonah (troops)", 
                                               color = "Black", face = "bold", size = 14))
boonah








hie_crew=readMat("devon_hie_predicted_crew_paths.mat")
hie_crew=hie_crew$predicted.crew.paths


hie_troop=readMat("devon_hie_predicted_troop_paths.mat")
hie_troop=hie_troop$predicted.troop.paths

pred_paths=hie_crew+hie_troop
  
hie_paths_m=melt(pred_paths)
hie_paths_m=data.frame(hie_paths_m,rep("Resampled paths",14000))


sc_crew=readMat("Devon_accepted_crew_paths_hie.mat")
sc_crew=sc_crew$accepted.crew.paths

sc_troops=readMat("Devon_accepted_troop_paths_hie.mat")
sc_troops=sc_troops$accepted.troop.paths

acc_paths=sc_crew+sc_troops
sc_paths_m=melt(acc_paths)
sc_paths_m=data.frame(sc_paths_m,rep("Conditional resampled paths",14000))

colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value","Method")
paths=rbind(hie_paths_m,sc_paths_m)


path=readMat("devon_data.mat")
path=path$data

path=data.frame("Day"=1:nrow(path),rowSums(path))
colnames(path)<-c("Day","value")

devon_1=subset(paths,Method=="Conditional resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Greens") +
  theme_minimal() +
  ylim(0,50)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
devon_1


devon_2=subset(paths,Method=="Resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Purples")+
  theme_minimal() +
  ylim(0,50)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
devon_2



devon=ggarrange(devon_1+rremove("ylab"),devon_2+rremove("ylab"), common.legend = T,legend = "none")+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))


devon<- annotate_figure(devon, top = text_grob("Devon", 
                                                 color = "Black", face = "bold", size = 14))
devon




#Manuka

hie_paths=readMat('manuka_predicted_paths_hie.mat')
hie_paths=hie_paths$predicted.paths
#hie_paths=hie_paths[8:22,]

hie_paths_m=melt(hie_paths)
hie_paths_m=data.frame(hie_paths_m,rep("Resampled paths",13000))
#no interventions 

sc_paths=readMat('Manuka_accepted_case_paths_hie.mat')
sc_paths=sc_paths$accepted.case.paths
#sc_paths[1:7,]=NA

sc_paths_m=melt(sc_paths)
sc_paths_m=data.frame(sc_paths_m,rep("Conditional resampled paths",13000))

colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value","Method")
paths=rbind(hie_paths_m,sc_paths_m)

path=readMat("manuka_data.mat")
path=path$data
path[0:7]<-NA
path=data.frame("Day"=1:nrow(path),"value"=path)


manuka_1=subset(paths,Method=="Conditional resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Greens") +
  theme_minimal() +
  ylim(0,20)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
manuka_1


manuka_2=subset(paths,Method=="Resampled paths") %>%
  group_by(Day) %>%
  curve_interval(value, .width = c(.5, .75, .95)) %>%
  ggplot(aes(x = Day, y = value)) +
  geom_lineribbon(aes(ymin = .lower, ymax = .upper)) +
  geom_line(data=path,aes(x=Day,y=value),size=1,color="#084594",linetype="dotdash")+
  scale_fill_brewer(palette = "Purples")+
  theme_minimal() +
  ylim(0,20)+
  ylab("New infections")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none")  +
  theme(legend.title=element_blank())
manuka_2



manuka=ggarrange(manuka_1+rremove("ylab"),manuka_2+rremove("ylab"), common.legend = T,legend = "none")+
  theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

manuka
manuka<- annotate_figure(manuka, top = text_grob("Manuka", 
                                               color = "Black", face = "bold", size = 14))
manuka







library(ggpubr)



X<-ggarrange(medic_pred_sp1+rremove("ylab"),
               medic_pred_sp2+rremove("ylab"),
               boonah_1+rremove("ylab"),
               boonah_2+rremove("ylab"),
               devon_1+rremove("ylab"),
               devon_2+rremove("ylab"),
               manuka_1+rremove("ylab"),
               manuka_2+rremove("ylab"), ncol = 4,nrow = 2,
               common.legend = T,legend = "none")


All<-ggarrange(medic+ rremove("ylab"),
              boonah+ rremove("ylab") ,
              devon+ rremove("ylab") ,
             manuka+ rremove("ylab"),
              common.legend = T,legend = "none")

All



annotate_figure(All, left = textGrob("New infections", rot = 90, vjust = 1, gp = gpar(cex = 1)))

#annotate_figure(All, top = text_grob("Medic", 
                                     #color = "black", face = "bold", size = 14))

#ggsave("medic_inter_first_1000.png",last_plot(),height = 10,width = 12)

#ggsave("medic_inter_set_seed_all.png",last_plot(),height = 8,width = 10)

ggsave("compare_pred_acc.png",last_plot(),height = 8,width = 10)
