library(R.matlab)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(ggthemes)
#library(wesanderson)
#library(RColorBrewer)
library(colorspace)
library(lubridate)

library(readr)
library(grid)
library(gridExtra)
library(GGally)


medic<-readMat('Boonah_hie_para.mat')
medic<-medic$para.hie
medic=medic[,c(1:6,8:24)]

params=c("beta[11]","delta(1-omega)","gamma","delta*omega","alpha","nu","d[crew]","beta[22]","d[passengers]","beta[12]","beta[21]",
         "zeta[18]","zeta[19]","zeta[20]","zeta[21]","zeta[22]","zeta[23]","zeta[24]","zeta[25]",
         "epsilon[crew[18-26]]","epsilon[passengers[18-26]]","epsilon[passengers[28-29]]","zeta[28]")

colnames(medic)<-params

paras=melt(medic)

medic_plot=ggplot(data = paras,aes(x=value))+
  geom_density(fill="#046C9A")+
  facet_wrap(~(Var2),ncol=3,labeller =label_parsed,scales = "free")+
  theme_minimal() +
  ggtitle("Boonah")+
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
  theme(legend.title=element_blank())+
  ylab("Density")+
  xlab("Parameter space")

medic_plot

ggsave('boonah_all_posteriors.png',height = 12,width=8)

