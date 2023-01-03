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



x <- readMat("Devon_data.mat")
x<-as.data.frame(x)
colnames(x)<-c("Crew_cases","Troops_cases")

z<-as.data.frame(matrix(rep(0,6),nrow=3)) #add more days to specify the day the arrived at suez
colnames(z)<-c("Crew_cases","Troops_cases")


y<-as.data.frame(matrix(rep(0,16),nrow=8)) #add more days to specify the day the arrived at Fremantle 
colnames(y)<-c("Crew_cases","Troops_cases")

x<-rbind(z,x,y)


Day=rep(1:nrow(x),2)

m=melt(x)
cases=data.frame("Day"=Day,m)

p1<-ggplot(cases)+
  geom_point(data=subset(cases,variable=='Crew_cases'),aes(x=Day,y=value),color="#999999")+
 # scale_color_manual(values = c("Crew_cases"="#56B4E9","Troops_cases"="#E69F00"))+
  ylim(-5,20)+
  xlab("Day")+
  ylab("Number of new infections")+
  geom_rect(mapping=aes(xmin=0, xmax=38, ymin=-1,ymax=-3.5),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=37, ymin=-1.5,ymax=-3), fill= "#66C2A5" , alpha=0.01)+
  annotate(geom= "text",x=10,y=-2,label="Voyage",size=4)+
  geom_vline(aes(xintercept = 1,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=1,y=10,label="Arrival at Suez \n (Source of infection)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 4,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=4,y=10,label="Departure from Suez",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =17,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=17,y=10,label="Arrival at Colombo \n (Cumulative count = 12)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =20,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=20,y=10,label="Departure from Colombo",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =37,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=37,y=10,label="Arrival at Fremantle (Quarantine)  \n (Cumulative count = 14)",size=3.5,fontface="italic",angle=90)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  ggtitle("Daily new infections on board Devon \n among crew")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())

p1


p2<-ggplot(cases)+
  geom_point(data=subset(cases,variable=='Troops_cases'),aes(x=Day,y=value),color="#999999")+
  # scale_color_manual(values = c("Crew_cases"="#56B4E9","Troops_cases"="#E69F00"))+
  ylim(-5,20)+
  xlab("Day")+
  ylab("Number of new infections")+
  geom_rect(mapping=aes(xmin=0, xmax=38, ymin=-1,ymax=-3.5),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=37, ymin=-1.5,ymax=-3), fill= "#66C2A5" , alpha=0.01)+
  annotate(geom= "text",x=10,y=-2,label="Voyage",size=4)+
  geom_vline(aes(xintercept = 1,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=1,y=10,label="Arrival at Suez \n (Source of infection)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept = 4,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=4,y=10,label="Departure from Suez",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =17,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=17,y=10,label="Arrival at Colombo  \n (Cumulative count = 76)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =20,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=20,y=10,label="Departure from Colombo",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =37,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=37,y=10,label="Arrival at Fremantle (Quarantine)  \n (Cumulative count = 81)",size=3.5,fontface="italic",angle=90)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  ggtitle("Daily new infections on board Devon \n among troops")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())

p2


#ship_pop<-data.frame("Group"=c("Crew","Troops","Civilians"),"Number"=c(110, 920,66))
total_inf<-data.frame("Group"=c("Crew","Troops","Civilians","Crew","Troops","Civilians")
                      ,"Type"=c( "Initial population size","Initial population size","Initial population size",
                                 "Total infections","Total infections","Total infections"),
                      "Number"=c(110,920,66,14,81,0))

#at_sydney<-data.frame("Group"=c("Troops","Others"), "Number"=c(50,32))



le=c("Initial population size","Total infections")


p3<-ggplot(total_inf,aes(x=Group,y=Number,fill=factor(Type,levels=le)))+
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
  scale_fill_manual(values=c("Initial population size"="grey","Total infections"="#E69F00"))+
  #scale_fill_brewer(palette="Pastel1")+
  ggtitle("Initial population sizes and total infections \n (from the record)")+
  theme(legend.position="bottom") +
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p3


case_count<-c(95,95)
type_c<-c("From time-series data", "From the record")
cases<-data.frame("Total new case numbers"=case_count,"Type"=type_c)


p4<-ggplot(cases,aes(x=Type,y=case_count))+
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
p4



p5<-plot_grid(p3,p4,cols=2)
p5

plot_grid(p1,p2,p5,cols = 1)


ggsave(filename = "Devon_snapshot.png", last_plot(),
       width =8, height = 12, dpi = 1000, units = "in", device='png')

