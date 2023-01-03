library(R.matlab)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(ggthemes)
library(wesanderson)
library(RColorBrewer)
library(colorspace)
library(lubridate)

library(readr)
library(grid)
library(gridExtra)
library(GGally)

library(viridis)


hbs=read.csv('hb8.csv')

hb_sigs=read.csv('hb_sig8.csv')

ros=read.csv('ros8.csv')

names<-c("X","Crew   Crew","Passenger   Crew","Crew   Passenger","Passenger   Passenger")

colnames(hbs)=colnames(hb_sigs)=names

n=nrow(hbs)
m=ncol(hbs)

hbm=melt(hbs,id="X")


my_fn <- function(data, mapping, ...){
  pal <- wes_palette("Darjeeling2", 200, type = "continuous")
  p <- ggplot(data = data, mapping = mapping) + 
    stat_density2d(aes(fill=..density..), geom="tile", contour = FALSE) +
    scale_fill_gradientn(colours=pal)
  #scale_fill_gradientn(colours=rainbow(100))
  #scale_fill_viridis()
  p
}

#lower and upper levels for hyper-means
lh=rep(0.001,4)
uh=c(10,10,6,5) #b11, b12,b22, b21

hbb=hbs[10001:n,]
hb2=hbb[seq(1,nrow(hbb),40),]

#hbm=melt(hbs[10001:n,],id="X")
hbm=melt(hb2,id="X")

p44=ggpairs(hb2, columns = 2:5,
            diag = list(continuous = wrap("densityDiag", fill="#046C9A")),
            lower=list(continuous=my_fn),
          upper = "blank")+
  theme_minimal()+
  xlab("")+
  ylab("")+
  ggtitle(expression(Psi[.]))+
  theme(legend.position="none")  +
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))

p44

#ggsave("posteriors_hyper_means_all.png",last_plot(),height = 10,width = 8)






####*****


hbb=hb_sigs[10001:n,]
hb2=hbb[seq(1,nrow(hbb),40),]


hbm=melt(hb2,id="X")



p55=ggpairs(hb2, columns = 2:5,
          diag = list(continuous = wrap("densityDiag", fill="#046C9A")),
          lower=list(continuous=my_fn),
          upper = "blank")+
  theme_minimal()+
  xlab("")+
  ylab("")+
  ggtitle(expression(sigma[.]))+
  theme(legend.position="none")  +
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))

p55

#ggsave("posteriors_hyper_sigmas_all.png",last_plot(),height = 10,width = 8)

p1<-plot_grid( ggmatrix_gtable(p44+theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))),
               ggmatrix_gtable(p55+theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))),ncol = 2)
p1

library(ggpubr)
annotate_figure(p1, left = textGrob("Density", rot = 90, vjust = 1, gp = gpar(cex = 1)),
                bottom = textGrob("Hyper parameter space", gp = gpar(cex = 1)))

ggsave("posteriors_hypers.png",last_plot(),height = 10,width = 17)


##calculate HPD intervals:
library(HDInterval)

hbb=hbs[10001:n,]
hb2=hbb[seq(1,nrow(hbb),40),]

x=hdi(hb2)
x

y=apply(hb2,2,median)
y

hbb=hb_sigs[10001:n,]
hb2=hbb[seq(1,nrow(hbb),40),]
x=hdi(hb2)
x

y=apply(hb2,2,median)
y


ros=ros[,-c(2,7,12,17)]
hbm=melt(ros,id="X")


p6=ggplot(hbm)+
  geom_line(aes(x=X,y=value,group=as.factor(variable)),colour="#737373",size=0.3)+
  facet_wrap(~(variable))+
  theme_minimal()

p6


hbm=melt(ros[2001:n,],id="X")


p66=ggplot(hbm)+
  geom_histogram(aes(x=value,y=..density..),fill= "#737373",binwidth = 0.05)+
  facet_wrap(~(variable))+
  theme_minimal()

p66
