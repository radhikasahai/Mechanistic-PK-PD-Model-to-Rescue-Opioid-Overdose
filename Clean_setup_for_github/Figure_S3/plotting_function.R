# outputs a 1 panel plot 
# called by main.R
# data is a dataframe with columns time, plasma concentration (ng/ml), group, and drug
# drug is the drug to plot
# title is the ggtitle to be used
plotting_function <- function(data, drug, colorPalette){

    if(drug=="Fentanyl"){
        group_name <- "Dosing Route"
    } else if (drug=="Naloxone"){
        group_name <- "Formulation"
    }

    plot <- ggplot()
    var <- "plasma concentration (ng/ml)"
    plot <- plot + geom_line(data=data[which(data[, "drug"] == drug),], aes(x=time/60, y=!!sym(var), color=group),linewidth=1)
    plot <- plot+ scale_color_manual(name=group_name, values=colorPalette, labels=str_wrap(unique(data[which(data[, "drug"] == drug),"group"]), width = 18), drop=TRUE)

    # plot <- plot+ xlim(0,20)
    # plot <- plot+ ylim(-1.5,NA)
    plot <- plot+ ylab(paste0(drug, " ", var))
    plot <- plot+ xlab("Time (min)")
    plot <- plot+ ggtitle(paste0("(",letters[name_idx],")"))


    plot <- plot + theme_bw() + theme(legend.direction = "vertical",
            legend.position = "inside",    		
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

    name_idx <<- name_idx + 1

    return(plot)


}