#########boonah
path=readMat("boonah_data.mat")
path=path$data
path=data.frame("Day"=1:nrow(path),"value"=path)


obs_peak=max(path$value)
obs_peak_d=which.max(path$value)
obs_pek=data.frame("peak_times"=obs_peak_d,"peaks"=obs_peak)

#independent paths 


#hierarchical paths:
hies=readMat('boonah_predicted_hie_passengers.mat')
hies=hies$total.passengers.cases

#remove paths that did not take off:
hies= hies[, colSums(hies != 0) > 0]

hie_paths=data.frame("Day"=1:35,hies)
hie_paths_m=melt(hie_paths,id="Day")


#Calculate the quantiles:


rq_hie=data.frame(t(apply(hie_paths, 1, quantile,probs=c(0.125, 0.875))),"Day"=1:nrow(path))

colnames(rq_hie)=c("lower","upper","Day")

rqs=rq_hie

medic_pred=ggplot()+
 # geom_ribbon(data=rqs,aes(x=Day,ymin=lower,ymax=upper,fill=factor(Estimation)),alpha=0.8)+
  geom_errorbar(data=rqs,aes(x=Day,ymin=lower,ymax=upper),color="#969696", alpha=0.8, width=.5,size=0.8)+
  geom_line(data=path,aes(x=Day,y=value),size=0.8)+
  scale_color_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections")+
  ggtitle("75% quantile error bars \n Predicted paths")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())


medic_pred


medic_pred_sp=ggplot()+
  geom_line(data=hie_paths_m,aes(Day,value,group=variable),color="#969696",alpha=0.8)+
  geom_line(data=path,aes(x=Day,y=value),size=0.8)+
  # scale_color_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  theme_minimal() +
  ylim(0,100)+
  ylab("New infections")+
  ggtitle("Predicted paths")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())


medic_pred_sp


#find the peaks:

hie_peaks=apply(hies, 2, max)
hie_peak_times=apply(hies, 2,which.max)
hie_pek=data.frame(factor(hie_peak_times),hie_peaks)

colnames(hie_pek)=c("Day","Peak")


all_peaks=hie_pek


#all_peaks_m=melt(all_peaks)

peak_p=ggplot()+
  geom_histogram(data=all_peaks,aes(x=Peak,y = ..density..),fill="#969696",binwidth = 2,alpha=0.8,position="identity")+
  scale_fill_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  geom_vline(data=NULL,aes(xintercept=obs_peak), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  ylab("")+
  ggtitle("Peaks sizes")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())
peak_p

peak_time_p=ggplot()+
  geom_bar(data=all_peaks,aes(x=Day),fill="#969696",alpha=0.8,position="identity")+
  scale_fill_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  geom_vline(data=NULL,aes(xintercept=obs_peak_d), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  ggtitle("Peak times")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())
peak_time_p


peak_all_p=ggplot()+
  geom_point(data=all_peaks,aes(x=Day,y =Peak),alpha=0.8,position="identity")+
  scale_color_manual(values=c("#D69C4E","#046C9A", "#00A08A","#9986A5"))+
  geom_vline(data=NULL,aes(xintercept=obs_peak_d), linetype="dotted", color="black", size=0.5)+
  geom_hline(data=NULL,aes(yintercept=obs_peak), linetype="dotted", color="black", size=0.5)+
  theme_minimal() +
  ggtitle("Peaks")+
  ylab("Peak size")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())
peak_all_p

p11=ggarrange(medic_pred,medic_pred_sp,nrow = 1,common.legend=T,legend="none",labels = c("(a)","(b)"))+
  theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))

#p12=ggarrange(medic_pred,peak_time_p,nrow = 1,common.legend=T,legend="none")
p11

#p22=ggarrange(peak_p,peak_all_p,nrow = 1)
#p22

All<-ggarrange(p11,peak_time_p+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm")),
               peak_p+theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm")),
               peak_all_p+theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm")),
               common.legend=T,legend="bottom",labels = c("(A)","(B)","(C)","(D)"))

#All<-ggarrange(p11,p22,nrow=2,common.legend=T,legend="bottom")
All

annotate_figure(All, top = text_grob("Boonah", 
                                     color = "black", face = "bold", size = 14))


ggsave('boonah_predictions.png',last_plot(),height = 10.5,width = 12)
