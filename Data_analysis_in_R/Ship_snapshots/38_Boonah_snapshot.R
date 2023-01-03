library(R.matlab)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(ggthemes)
library(wesanderson)
library(RColorBrewer)
library(lubridate)

library(readr)
library(grid)
library(gridExtra)

x <- read_csv("38_Boonah.csv")
x<-as.data.frame(x)
x$Date<-as.Date(dmy(x$Date))

dt<-data.frame("Date"=1:length(x$Date),"Daily_caes"=x$Daily_new_case_count)
#dt2<-data.frame("Date"=1:length(x$Date),"Cases_on_shore"=c(rep(NA,55),7,NA,2,NA,NA,2,NA,1,1,rep(NA,4),2,1,1,
                                                        #   2,1,rep(NA,3),3,1,rep(NA,8)))

p1<-ggplot(dt)+
  geom_point(aes(x=Date, y=Daily_caes),shape=19,color="#999999")+
 #geom_point(data = dt2,aes(x=Date, y=Cases_on_shore),shape=19,color="#FC8D62")+
  #ylim(0,60)+
  xlab("Day")+
  ylab("Number of new infections")+
  geom_rect(mapping=aes(xmin=0, xmax=80, ymin=-4,ymax=-25),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=51, ymin=-5,ymax=-15), fill= "#66C2A5" , alpha=0.01)+
  geom_rect(mapping=aes(xmin=51, xmax=80, ymin=-5,ymax=-10), fill="#FC8D62", alpha=0.01)+
  geom_rect(mapping=aes(xmin=51, xmax=60, ymin=-11,ymax=-16), fill="#FC8D62", alpha=0.01)+
  #geom_rect(mapping=aes(xmin=56, xmax=64, ymin=-17.5,ymax=-25), fill="#FC8D62", alpha=0.01)+
  geom_rect(mapping=aes(xmin=62, xmax=65, ymin=-11,ymax=-18), fill="#FC8D62", alpha=0.01)+
  geom_rect(mapping=aes(xmin=68, xmax=80, ymin=-11,ymax=-16), fill="#FC8D62", alpha=0.01)+
  geom_rect(mapping=aes(xmin=69, xmax=80, ymin=-17.5,ymax=-25), fill="#FC8D62", alpha=0.01)+
  
  annotate(geom= "text",x=10,y=-8.5,label="Voyage",size=4)+
  annotate(geom= "text",x=65,y=-6.5,label=" Quarantine",size=4)+
  annotate(geom= "text",x=55,y=-13,label=" Fremantle",size=3)+
  #annotate(geom= "text",x=60,y=-20,label=" Isolating \n on shore ",size=2.5)+
  annotate(geom= "text",x=63,y=-14,label=" Alb- \n -any",size=3)+
  annotate(geom= "text",x=72,y=-13,label=" Adelaide",size=3)+
  annotate(geom= "text",x=72,y=-20.5,label=" Isolating \n on shore ",size=2.5)+
  
  geom_vline(aes(xintercept = 26,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=26,y=32,label="Arrival at Durban \n (Source of infection)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 34,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=34,y=32,label="Departure from Durban",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 51,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=51,y=52,label="Cumulative count = 298",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 60,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=60,y=52,label="Cumulative count  = 397",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 65,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=65,y=52,label="Cumulative count  = 410",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 78,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=78,y=52,label="Cumulative count  = 433",size=3.5,fontface="italic",angle=90)+
  ylim(-25, 80)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  ggtitle("Daily new infections on board Boonah (troops only)")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p1




Day<-1:50
Day<-c(51,52,53,54,55,56,57,58,62,68,69)
#total_pop<-c(rep(0,19),82,57,34,151,38,0,108,rep(0,8))
total_pop<-c(150,86,67,9,8,7,4,2,4,14,427)
#type<-c(rep("No removals",14),"Infectious","Infectious","Healthy","Healthy","Infectious",
#  "No removals","Infectious",rep("No removals",8) )
type<-c("Infectious/infected","Infectious/infected","Infectious/infected",
        "Infectious/infected","Infectious/infected",
        "Infectious/infected","Infectious/infected","Infectious/infected",
        "Infectious/infected","Infectious/infected","Healthy")
removals<-data.frame("Day"=Day,"Removals"= total_pop,"Type"=type)



p3<-ggplot(removals, aes(x=Day, y=Removals)) +
  geom_point(shape=19,size=6.5,aes(color=factor(type))) + 
  scale_colour_manual(values=c("Healthy"="#56B4E9","Infectious/infected"="#E69F00"))+
  geom_segment( aes(x=Day, xend=Day, y=0, yend=Removals-3.5),color = "gray", lwd = 1.2)+
  geom_text(aes(label = Removals), color = "black", size = 3) +
  geom_rect(mapping=aes(xmin=0, xmax=80, ymin=-4,ymax=-55),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=51, ymin=-5,ymax=-45), fill= "#66C2A5" , alpha=0.1)+
  geom_rect(mapping=aes(xmin=51, xmax=80, ymin=-5,ymax=-45), fill="#FC8D62", alpha=0.1)+
  annotate(geom= "text",x=10,y=-15,label="Voyage",size=4)+
  annotate(geom= "text",x=65,y=-15,label=" Quarantine",size=4)+
  xlim(0,80)+
  ylim(-55, 500)+
  xlab("Day")+
  ylab("Number of people removed from the ship")+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  
  ggtitle("Removal of infectious/infected and healthy people on board Boonah \n (from the record)")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())

p3



plot_grid(p1,p3,cols = 1)

ship_pop<-data.frame("Group"=c("Crew","Troops"),"Number"=c(164, 916))
total_inf<-data.frame("Group"=c("Crew","Troops","Crew","Troops","Group unknown")
                      ,"Type"=c( "Initial population size","Initial population size",
                                 "Total infections","Total infections",
                                 "Deaths"),
                      "Number"=c(164,916,37,433,16))

#at_sydney<-data.frame("Group"=c("Troops","Others"), "Number"=c(50,32))



le=c("Initial population size","Total infections","Deaths")

p4<-ggplot(total_inf,aes(x=Group,y=Number,fill=factor(Type,levels=le)))+
  geom_bar(stat="identity", position=position_dodge())+
  geom_text(aes(y=Number, label=Number), vjust=0.0001, 
            color="black",position = position_dodge(0.9), size=4)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  scale_fill_manual(values=c("Initial population size"="grey","Total infections"="#E69F00","Deaths"="#A6761D"))+
  #scale_fill_brewer(palette="Pastel1")+
  ggtitle("Initial population sizes, total infections \n and deaths (from the record)")+
  theme(legend.position="bottom") +
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p4



case_count<-c(433,470)
type_c<-c("From time-series data", "From the record")
cases<-data.frame("Total new case numbers"=case_count,"Type"=type_c)


p5<-ggplot(cases,aes(x=Type,y=case_count))+
  geom_bar(stat="identity", position=position_dodge(),fill="#999999")+
  geom_text(aes(y=case_count, label=case_count), vjust=0.0001, 
            color="black",position = position_dodge(0.9), size=4)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  #scale_fill_brewer(palette="Pastel1")+
  ggtitle("Total number of cases at the \n end of the epidemic")+
  theme(legend.position="bottom") +
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p5




p6<-plot_grid(p4,p5,cols=2)
p6

plot_grid(p1,p3,p6,cols = 1)


ggsave(filename = "Boonah_snapshot.png", last_plot(),
       width =8, height = 12, dpi = 1000, units = "in", device='png')


