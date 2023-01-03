#load Boonah data:

#hierarchical model:


hie_paths=readMat('boonah_predicted_hie_passengers.mat')
hie_paths=hie_paths$total.passengers.cases
hie_paths2=hie_paths
hie_paths2[1:17,]=NA

hie_paths_m=melt(hie_paths2)
#no interventions 

sc_paths=readMat('boonah_sc_predicted_paths_T.mat')
sc_paths=sc_paths$sc.paths.T
sc_paths[1:17,]=NA

sc_paths_m=melt(sc_paths)


colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value")




early_path=hie_paths[1:18,]
early_path_m=melt(early_path)
colnames(early_path_m)=c("Day","variable","value")


path=readMat("boonah_data.mat")
path=path$data
path=data.frame("Day"=1:length(path),"value"=path)





medic_pred_sp=ggplot()+
  geom_line(data=early_path_m,aes(Day,value,group=variable),color= "#666666",alpha=0.1,size=.15)+
  geom_line(data=sc_paths_m,aes(Day,value,group=variable),color= "#E6AB02",alpha=0.2,size=.15)+
  geom_line(data=hie_paths_m,aes(Day,value,group=variable),color="#35274A",alpha=0.1,size=0.2)+
  geom_vline(data=NULL,aes(xintercept=18), linetype="dotted", color="black", size=0.5)+
  annotate("text", x = 20, y = 90, label = "Arrival at Fremantle Qurantine Station",size=5)+
  geom_line(data=path,aes(x=Day,y=value),size=0.8)+
  # scale_color_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  theme_minimal(14) +
  ylim(0,100)+
  ylab("New infections among passengers")+
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


medic_pred_sp


hie_paths=readMat('boonah_predicted_hie_passengers.mat')
hie_paths=hie_paths$total.passengers.cases



#no interventions 


sc_paths=readMat('boonah_sc_predicted_paths_T.mat')
sc_paths=sc_paths$sc.paths.T



hie_paths=hie_paths[18:35,]
sc_paths=sc_paths[18:35,]

path_diff=sc_paths-hie_paths
path_diff_m=melt(path_diff)
colnames(path_diff_m)=c("Day","variable","value")

path_diff_plot=ggplot()+
  geom_line(data=path_diff_m,aes(Day,value,group=variable),color= "#046C9A",alpha=0.2,size=0.1)+
  geom_vline(data=NULL,aes(xintercept=1), linetype="dotted", color="black", size=0.5)+
  annotate("text", x = 9, y = -50, label = "Arrival at Fremantle Qurantine Station",size=5)+
  theme_minimal(14) +
  ylab("Difference between no interventions \n and interventions \n (New infections)")+
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


quantile(p_sum[,2])

path_diff_perc=(path_diff_sum/colSums(hie_paths))*100


quantile(path_diff_perc,na.rm = T)

proprtion_positives=sum((path_diff_sum>0))/1000
proprtion_positives

path_diff_his=ggplot(p_sum,aes(x=value))+
  geom_histogram(binwidth=2,fill="#4E2A1E",alpha=0.8)+
  geom_vline(data=NULL,aes(xintercept=0), linetype="dotted", color="black", size=0.5)+
  theme_minimal(14) +
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


All_pred<-ggarrange(medic_pred_sp,path_diff_plot,path_diff_his,ncol = 3,labels=c("(D)","(E)","(F)"))

All_pred<-annotate_figure(All_pred, top = text_grob("Resampled paths (passengers)", 
                                        color = "black", face = "bold", size = 16))



#ggsave("medic_inter_first_1000.png",last_plot(),height = 10,width = 12)

#ggsave("Boonah_inter_all.png",last_plot(),height = 10,width = 12)

