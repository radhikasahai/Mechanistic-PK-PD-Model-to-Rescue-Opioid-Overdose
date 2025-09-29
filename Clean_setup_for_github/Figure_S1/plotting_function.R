# outputs a 1 panel plot 
# called by main.R
# results is a dataframe with columns time, plasma concentration (ng/ml)
# data is the clincal data with time in hours and concentration in ng/mL
plotting_function <- function(results, data){

    plot <- ggplot()
    var <- "plasma concentration (ng/ml)"
    plot <- plot + geom_line(data=results, aes(x=time/60/60, y=!!sym(var)),color="dark green", linewidth=1)
    plot <- plot + geom_point(data=data, aes(x=time, y=concentration, color=group), color="blue", size=1)

    # plot <- plot+ xlim(0,20)
    # plot <- plot+ ylim(-1.5,NA)
    plot <- plot+ ylab(paste0("Fentanyl ", var))
    plot <- plot+ xlab("Time (hours)")


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

    return(plot)


}