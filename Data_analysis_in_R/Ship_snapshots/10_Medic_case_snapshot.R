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

x <- read_csv("10_Medic.csv")
x<-as.data.frame(x)
x$Date<-as.Date(dmy(x$Date))

dt<-data.frame("Date"=1:length(x$Date),"Daily_caes"=x$Daily_new_case_count)


p1<-ggplot(dt)+
  geom_point(aes(x=Date, y=Daily_caes),shape=19,color="#999999")+
  #ylim(0,60)+
  xlab("Day")+
  ylab("Number of new infections")+
  geom_rect(mapping=aes(xmin=0, xmax=50, ymin=-4,ymax=-25),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=20, ymin=-5,ymax=-15), fill= "#66C2A5" , alpha=0.01)+
  geom_rect(mapping=aes(xmin=20, xmax=50, ymin=-5,ymax=-15), fill="#FC8D62", alpha=0.01)+
  geom_rect(mapping=aes(xmin=40, xmax=50, ymin=-15,ymax=-23), fill="#FC8D62", alpha=0.01)+
  annotate(geom= "text",x=9,y=-8.5,label="Voyage",size=4)+
  annotate(geom= "text",x=30,y=-8.5,label="Quarantine at Sydney",size=4)+
  annotate(geom= "text",x=45,y=-12.5,label="New cases from Medic \n who were isolating \n on shore ",size=3)+
  geom_vline(aes(xintercept = 6,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=6,y=32,label="Arrival at Wellington \n (Source of infection)",size=3.5,fontface="italic",angle=90)+
  
  geom_vline(aes(xintercept = 10,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=10,y=32,label="Departure from Wellington",size=3.5,fontface="italic",angle=90)+
  
  geom_vline(aes(xintercept = 20,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=20,y=25,label="Cumulative count = 203",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 40,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=40,y=25,label="Cumulative count = 303",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 49,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=49,y=25,label="Cumulative count = 313",size=3.5,fontface="italic",angle=90)+
  ylim(-25, 70)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  ggtitle("Daily new infections on board Medic")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p1




Day<-1:50
Day<-c(20,21,22,23,24,25)
#total_pop<-c(rep(0,19),82,57,34,151,38,0,108,rep(0,8))
total_pop<-c(82,57,34,151,38,108)
#type<-c(rep("No removals",14),"Infectious","Infectious","Healthy","Healthy","Infectious",
      #  "No removals","Infectious",rep("No removals",8) )
type<-c("Infectious/infected","Infectious/infected","Healthy","Healthy","Infectious/infected",
        "Infectious/infected")
removals<-data.frame("Day"=Day,"Removals"= total_pop,"Type"=type)



p3<-ggplot(removals, aes(x=Day, y=Removals)) +
  geom_point(shape=19,size=6.5,aes(color=factor(type))) + 
  scale_colour_manual(values=c("Healthy"="#56B4E9","Infectious/infected"="#E69F00"))+
  geom_segment( aes(x=Day, xend=Day, y=0, yend=Removals-3.5),color = "gray", lwd = 1.2)+
  geom_text(aes(label = Removals), color = "black", size = 3) +
  geom_rect(mapping=aes(xmin=0, xmax=50, ymin=-4,ymax=-25),fill="grey", alpha=0.12)+
  geom_rect(mapping=aes(xmin=0, xmax=20, ymin=-10,ymax=-20), fill= "#66C2A5" , alpha=0.1)+
  geom_rect(mapping=aes(xmin=20, xmax=50, ymin=-10,ymax=-20), fill="#FC8D62", alpha=0.1)+
  annotate(geom= "text",x=8,y=-15,label="Voyage",size=4)+
  annotate(geom= "text",x=30,y=-15,label="Quarantine at Sydney",size=4)+
  xlim(0,50)+
  ylim(-25, 160)+
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
  
  ggtitle("Removal of infectious/infected and healthy people on board Medic")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())

p3



plot_grid(p1,p3,cols = 1)

ship_pop<-data.frame("Group"=c("Crew","Civillians","Troops"),"Number"=c(156,4, 829))
total_inf<-data.frame("Group"=c("Crew","Civillians","Troops","Crew","Civillians","Troops","Crew","Civillians","Troops")
                      ,"Type"=c( "Initial population size","Initial population size","Initial population size",
                                 "Total infections","Total infections","Total infections",
                                 "Deaths","Deaths","Deaths"),
                      "Number"=c(156,4, 829,52,4,257,1,0,21))
at_sydney<-data.frame("Group"=c("Troops","Others"), "Number"=c(50,32))



le=c("Initial population size","Total infections","Deaths");

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



case_count<-c(313,313)
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




p6<-plot_grid(p4,NULL,cols=2)+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm"))
p6

plot_grid(p1+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm")),
          p3+ theme(plot.margin = margin(0.5,0.5, 0.5, 0.5, "cm")),
          p6,cols = 1,labels = c("(A)","(B)","(C)"))


ggsave(filename = "medic_snapshot.png", last_plot(),
     width =8, height = 12, units = "in", device='png')

