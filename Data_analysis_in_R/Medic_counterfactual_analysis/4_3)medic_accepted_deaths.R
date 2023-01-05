#load meeic data:

#hierarchical model:



hi1=readMat("medic_INT_d_Q.mat")
hi1=hi1$INT.d.Q

hi2=readMat("medic_INT_d_B.mat")
hi2=hi2$INT.d.B

hie_paths=colSums(hi1+hi2)

hie_paths2=hie_paths



#hie_paths=hie_paths[8:22,]

hie_paths_m=data.frame(melt(hie_paths2),rep("Interventions",1000))
#no interventions 

sc_paths=readMat('medic_NO_d_B.mat')
sc_paths=sc_paths$NO.d.B
sc_paths=colSums(sc_paths)

#sc_m=melt(sc_paths)
#sc_paths_m=data.frame(sc_m,rep("No interventions",1000))



path_diff=sc_paths-hie_paths
path_diff_m=melt(path_diff)




quantile(path_diff)

path_diff_perc=(path_diff/hie_paths)*100


quantile(path_diff_perc,na.rm = T)

proprtion_positives=sum((path_diff>0))/1000
proprtion_positives


path_diff_his_acc=ggplot(path_diff_m,aes(x=value))+
  geom_histogram(binwidth=2,fill="#4E2A1E",alpha=0.8)+
  geom_vline(data=NULL,aes(xintercept=0), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  xlab("Difference between no interventions and interventions \n (Total deaths throughout the epidemic)")+
  ylab("")+
 # ylim(0,330)+
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
path_diff_his_acc


library(ggpubr)


All_pred<-ggarrange(path_diff_his_acc,path_diff_his_pred,ncol = 2,labels = c("Condional re-sampled","Re-sampled"),common.legend = T)

All_pred<-annotate_figure(All_pred, top = text_grob("Deaths", 
                                                    color = "black", face = "bold", size = 14))

#ggsave("medic_inter_first_1000.png",last_plot(),height = 10,width = 12)

#ggsave("medic_inter_set_seed_all.png",last_plot(),height = 8,width = 10)
All_pred

ggsave('medic_acc_pred_deaths.png',last_plot(),height = 6,width = 8)
