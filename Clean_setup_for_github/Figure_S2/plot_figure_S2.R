library(ggplot2)

# read clinical data
data <- read.csv("../data/Clinical_data_IN_KLOXXADO_8mg.csv")
# read population stats
results <- readRDS("output/population_stats.RDS")
# only plot times after 31.8 seconds to avoid inf in log scale
results <- results[results[,"time"] > 31.8,]

plot <- ggplot()

plot <- plot + geom_point(data=data, aes(x=Time_Min, y=log10(Naloxone_IV)),size=1, color="blue")
plot <- plot + geom_line(data=results, aes(x=time/60, y=mean),linewidth=1, color="dark green")

# plot <- plot + geom_ribbon(aes(x=results[,"time"]/60, ymin=pmax(0,results[,"mean"]-results[,"sd"]), ymax=results[,"mean"]+results[,"sd"]), fill="black", alpha=0.6)
plot <- plot + geom_ribbon(aes(x=results[,"time"]/60, ymin=results[,"2.5%"], ymax=results[,"97.5%"]), fill="green", alpha=0.3)

plot <- plot+ xlim(0,16)
# plot <- plot+ ylim(-1.5,NA)
plot <- plot+ ylab(expression(log["10"]*"(Naloxone plasma concentration (ng/mL))"))
plot <- plot+ xlab("Time (min)")


plot <- plot + theme_bw() + theme(legend.direction = "vertical",
        legend.position = "none",    		
        legend.position.inside = c(0.8, 0.75),    		
        legend.title=element_blank(),
        legend.text=element_text(hjust = 0.5),
        legend.key=element_rect(fill = alpha("white", 1)),
        legend.background=element_rect(fill = alpha("white", 1)),  
        legend.box.background = element_rect(colour = "black"),
        legend.key.spacing.y = unit(0.3, 'cm'),
        plot.title = element_text(face = "bold"),
        # Hide panel borders and remove grid lines
        panel.border = element_blank(),
        panel.grid.major = element_line(colour = "grey",linewidth=0.25),
        panel.grid.minor = element_line(colour = "grey",linewidth=0.25),
#			panel.grid.major = element_blank(),
#			panel.grid.minor = element_blank(),
        # Change axis line
        axis.line = element_line(colour = "black")
#				axis.text.y = element_blank(),
#				axis.title.y = element_blank()
)

ggsave("Figure_S2.png", plot, width=5, height=5)
