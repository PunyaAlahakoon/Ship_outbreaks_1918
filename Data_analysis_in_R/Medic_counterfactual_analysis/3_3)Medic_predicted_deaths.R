#load meeic data:

#hierarchical model:


hie_paths=readMat('medic_predicted_hie_deaths.mat')
hie_paths=hie_paths$predicted.deaths
hie_paths2=(colSums(hie_paths))



#hie_paths=hie_paths[8:22,]

#hie_paths_m=data.frame(melt(hie_paths2),rep("Interventions",1000))
#no interventions 

sc_paths=readMat('medic_scenario_predicted_deaths.mat')
sc_paths=sc_paths$scenario.predicted.deaths

sc_m=(colSums(sc_paths))
#sc_paths_m=data.frame(sc_m,rep("No interventions",1000))



path_diff=sc_m-hie_paths2
path_diff_m=melt(path_diff)




quantile(path_diff)

path_diff_perc=(path_diff/hie_paths)*100


quantile(path_diff_perc,na.rm = T)

proprtion_positives=sum((path_diff>0))/1000
proprtion_positives


path_diff_his_pred=ggplot(path_diff_m,aes(x=value))+
  geom_histogram(binwidth=2,fill="#4E2A1E",alpha=0.8)+
  geom_vline(data=NULL,aes(xintercept=0), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  xlab("Difference between no interventions and interventions \n (Total deaths throughout the epidemic)")+
  ylab("")+
  #ylim(0,330)+
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
path_diff_his_pred


library(ggpubr)



