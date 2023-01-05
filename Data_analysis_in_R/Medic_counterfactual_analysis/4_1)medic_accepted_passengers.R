#load meeic data:

#hierarchical model:


hie_paths=readMat('medic_INT_paths_T.mat')
hie_paths=hie_paths$INT.paths.T
hie_paths2=hie_paths
hie_paths2[1:7,]=NA
#hie_paths=hie_paths[8:22,]

hie_paths_m=data.frame(melt(hie_paths2),rep("Interventions",22000))
#no interventions 

sc_paths=readMat('medic_NO_paths_T.mat')
sc_paths=sc_paths$NO.paths.T
sc_paths[1:7,]=NA

sc_m=melt(sc_paths)
sc_paths_m=data.frame(sc_m,rep("No interventions",22000))


colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value","Method")
#all_paths=rbind(hie_paths_m,sc_paths_m)

early_path=hie_paths[1:8,]
early_path_m=melt(early_path)
colnames(early_path_m)=c("Day","variable","value")


#medic data:
path=c(	0,2,	0	,	17,36,	41,	50,	52,
        35	,36,	8,	11,	0,	0,	5,	1,	0,	1,	2,	0,	1,	0) #untial Sydeny Qurantine 

path=data.frame("Day"=1:length(path),"value"=path)


medic_pred_sp=ggplot()+
  geom_line(data=early_path_m,aes(Day,value,group=variable),color= "#666666",alpha=0.1,size=.15)+
  geom_line(data=sc_paths_m,aes(Day,value,group=variable),color= "#E6AB02",alpha=0.2,size=.15)+
  geom_line(data=hie_paths_m,aes(Day,value,group=variable),color="#0B775E",alpha=0.1,size=0.2)+
  geom_vline(data=NULL,aes(xintercept=8), linetype="dotted", color="black", size=0.5)+
  scale_color_manual(values=c("#35274A","#E6AB02"),breaks =c("Interventions","No interventions"))+
  annotate("text", x = 13.8, y = 90, label = "Arrival at Sydney Qurantine Station")+
 # geom_line(data=path,aes(x=Day,y=value),size=0.5)+
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections within passengers")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 14))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

#geom_vline(data=NULL,aes(xintercept=8), linetype="dotted", color="black", size=0.5)+
#annotate("text", x = 13.8, y = 90, label = "Arrival at Sydney Qurantine Station")+
# geom_line(data=path,aes(x=Day,y=value),size=0.5)+
#  scale_color_manual(values=c("#E6AB02","#7570B3"),labels=c("Interventions","No interventions"))+

medic_pred_sp

hie_paths=readMat('medic_INT_paths_T.mat')
hie_paths=hie_paths$INT.paths.T
hie_paths=hie_paths[8:22,]



sc_paths=readMat('medic_NO_paths_T.mat')
sc_paths=sc_paths$NO.paths.T
sc_paths=sc_paths[8:22,]




path_diff=sc_paths-hie_paths
path_diff_m=melt(path_diff)
path_diff_m$Var1=rep(8:22,1000)



colnames(path_diff_m)=c("Day","variable","value")

path_diff_plot=ggplot()+
  geom_line(data=path_diff_m,aes(Day,value,group=variable),color= "#046C9A",alpha=0.2,size=0.1)+
  geom_vline(data=NULL,aes(xintercept=8), linetype="dotted", color="black", size=0.5)+
  annotate("text", x = 15, y = -50, label = "Arrival at Sydney Qurantine Station")+
  theme_minimal() +
  xlim(7,22)+
  ylab("Difference between no interventions and interventions \n (New infections)")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 14))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

path_diff_plot





path_diff_sum=as.data.frame(colSums(sc_paths)-colSums(hie_paths))
p_sum=melt(path_diff_sum)

quantile(p_sum[,2],probs=c(0.025, 0.975))
quantile(p_sum[,2])

path_diff_perc=(path_diff_sum/colSums(hie_paths))*100

proprtion_positives=sum((p_sum[,2]>0))/1000
proprtion_positives

quantile(path_diff_perc,na.rm = T)

path_diff_his=ggplot(p_sum,aes(x=value))+
  geom_histogram(binwidth=7,fill="#4E2A1E",alpha=0.8)+
  geom_vline(data=NULL,aes(xintercept=0), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  xlab("Difference between no interventions and interventions \n (Total New infections throughout the epidemic)")+
  ylab("")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 14))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))
path_diff_his


library(ggpubr)


All_acc_pas<-ggarrange(medic_pred_sp,path_diff_plot,path_diff_his,ncol = 3)

All_acc_pas<-annotate_figure(All_acc_pas, top = text_grob("Conditional re-sampled paths", 
                                                            color = "black", face = "bold", size = 14))+
  theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

#ggsave("medic_inter_first_1000.png",last_plot(),height = 10,width = 12)

#ggsave("medic_inter_set_seed_all.png",last_plot(),height = 8,width = 10)

ggarrange(All_acc_pas, All_pred_pas,ncol=1)

ggsave('medic_acc_pred_passengers.png',last_plot(),height = 10,width = 12)
