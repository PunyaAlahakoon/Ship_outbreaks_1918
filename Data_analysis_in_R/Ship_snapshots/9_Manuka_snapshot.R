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



x <- readMat("manuka_data.mat")
x<-as.data.frame(x)
x[1:7,]<-NA

Day=rep(1:nrow(x),2)

m=melt(x)
cases=data.frame("Day"=Day,m)

prevlance=data.frame("Day"=7,"value"=23)

p1<-ggplot(cases)+
  geom_point(aes(x=Day,y=value),color="#999999")+
 # geom_point(data=prevlance,aes(x=Day,y=value),color="#E7298A")+
  # scale_color_manual(values = c("Crew_cases"="#56B4E9","Troops_cases"="#E69F00"))+
  ylim(-5,25)+
  xlab("Day")+
  ylab("Number of new infections")+
  geom_rect(mapping=aes(xmin=0, xmax=14, ymin=-1,ymax=-3.5),fill="grey", alpha=0.01)+
  geom_rect(mapping=aes(xmin=0, xmax=7, ymin=-1.5,ymax=-3), fill= "#66C2A5" , alpha=0.01)+
  geom_rect(mapping=aes(xmin=7, xmax=13, ymin=-1.5,ymax=-3), fill="#FC8D62", alpha=0.01)+
  annotate(geom= "text",x=2,y=-2,label="Voyage",size=4)+
  annotate(geom= "text",x=10,y=-2,label=" Quarantine at Sydney",size=4)+
  geom_vline(aes(xintercept =1,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=1,y=10,label="Departure from Wellington \n (source of infection)",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =7,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=7,y=10,label="Cumulative count = 29",size=3.5,fontface="italic",angle=90)+
  geom_vline(aes(xintercept =13,colour = "#D95F02"), linetype = "twodash")+
  annotate(geom= "text",x=13,y=10,label="Cumulative count = 42",size=3.5,fontface="italic",angle=90)+
  theme_clean() +
  theme(plot.background=element_blank(),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank())+ 
  ggtitle("Daily new infections on board Manuka")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="none") +
  theme(legend.title = element_blank(),
        legend.background = element_blank())

p1



#ship_pop<-data.frame("Group"=c("Crew","Troops","Civilians"),"Number"=c(110, 920,66))
total_inf<-data.frame("Group"=c("Crew","Passengers","Crew","Passengers","Group unknown")
                      ,"Type"=c( "Initial population size","Initial population size",
                                 "Total infections","Total infections","Deaths"),
                      "Number"=c(95,108,32,9,1))

#at_sydney<-data.frame("Group"=c("Troops","Others"), "Number"=c(50,32))



le=c("Initial population size","Total infections","Deaths")


p2<-ggplot(total_inf,aes(x=Group,y=Number,fill=factor(Type,levels=le)))+
  geom_bar(stat="identity", position=position_dodge())+
  geom_text(aes(y=Number, label=Number), vjust=0.0001, 
            color="black",position = position_dodge(0.9), size=4)+
  theme_clean(10) +
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
  ggtitle("Initial population sizes, total infections and deaths \n (from the record)")+
  theme(legend.position="bottom") +
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.title = element_blank(),
        legend.background = element_blank())
p2


case_count<-c(41,41)
type_c<-c("From time-series data", "From the record")
cases<-data.frame("Total new case numbers"=case_count,"Type"=type_c)


p3<-ggplot(cases,aes(x=Type,y=case_count))+
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
p3



p4<-plot_grid(p2,p3,cols=2)
p4

plot_grid(p1,p4,cols = 1)


ggsave(filename = "Manuka_snapshot.png", last_plot(),
       width =8, height = 12, dpi = 1000, units = "in", device='png')

