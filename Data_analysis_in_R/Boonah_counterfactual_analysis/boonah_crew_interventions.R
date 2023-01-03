#load Boonah data:

#hierarchical model:


hie_paths=readMat('Boonah_predicted_crew_paths.mat')
hie_paths=hie_paths$crew.cases


hie_paths_m=melt(hie_paths)
#no interventions 

sc_paths=readMat('scenario_Boonah_predicted_crew.mat')
sc_paths=sc_paths$no.predicted.crew
sc_paths[1:17,]=NA

sc_paths_m=melt(sc_paths)


colnames(hie_paths_m)=colnames(sc_paths_m)=c("Day","variable","value")





path=readMat("boonah_data.mat")
path=path$data
path=data.frame("Day"=1:length(path),"value"=path)





medic_pred_sp=ggplot()+
  geom_line(data=sc_paths_m,aes(Day,value,group=variable),color= "#1B9E77",alpha=0.8,size=1)+
  geom_line(data=hie_paths_m,aes(Day,value,group=variable),color="#969696",alpha=0.4,size=1)+
  geom_vline(data=NULL,aes(xintercept=18), linetype="dotted", color="black", size=0.5)+
  annotate("text", x = 25, y = 90, label = "Arrival at Fremantle Qurantine Station")+
  # geom_line(data=path,aes(x=Day,y=value),size=0.8)+
  # scale_color_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections among crew")+
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

hie_paths=readMat('Boonah_predicted_crew_paths.mat')
hie_paths=hie_paths$crew.cases


hie_paths_m=melt(hie_paths)
#no interventions 

sc_paths=readMat('scenario_Boonah_predicted_crew.mat')
sc_paths=sc_paths$no.predicted.crew


hie_paths=hie_paths[18:35,]
sc_paths=sc_paths[18:35,]

path_diff=sc_paths-hie_paths
path_diff_m=melt(path_diff)
colnames(path_diff_m)=c("Day","variable","value")

path_diff_plot=ggplot()+
  geom_line(data=path_diff_m,aes(Day,value,group=variable),color= "#969696",alpha=0.5)+
  geom_vline(data=NULL,aes(xintercept=1), linetype="dotted", color="black", size=0.5)+
  annotate("text", x = 6.5, y = -90, label = "Arrival at Fremantle Qurantine Station")+
  theme_minimal() +
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

path_diff_his=ggplot(p_sum,aes(x=value))+
  geom_histogram(binwidth=1)+
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


All<-ggarrange(medic_pred_sp,NULL,path_diff_plot,path_diff_his)+ggtitle("Crew")


annotate_figure(All, top = text_grob("Boonah (crew)", 
                                     color = "black", face = "bold", size = 14))


#ggsave("medic_inter_first_1000.png",last_plot(),height = 10,width = 12)

ggsave("Boonah_crew_inter_all.png",last_plot(),height = 10,width = 12)

