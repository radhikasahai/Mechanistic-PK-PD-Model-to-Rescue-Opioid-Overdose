# Extract nadir from existing simulation outputs
library(ggplot2)

# Define doses
doses <- c(0, 0.2, 0.4, 0.8, 1.6, 3.2)
formulation <- "Generic"
opioid <- "fentanyl"

# Initialize results (will only store valid results)
nadir_results <- c()
dose_results <- c()

# Read each CSV file and find nadir
for(i in 1:length(doses)){
  dose <- doses[i]
  concstr <- as.character(dose)
  
  # Path to CSV file (matches simulateToGetOD_IM.R line 320)
  csv_file <- sprintf("outputs/results/Im_plot_%s/%s_%s_ypred1.csv", 
                      formulation, opioid, concstr)
  
  if(file.exists(csv_file)){
    # Read the CSV
    data <- read.csv(csv_file)
    
    # Extract minute ventilation (R converts column names: spaces/parens -> dots)
    # Column name in CSV: "Minute ventilation (l/min)"
    # R reads it as: "Minute.ventilation..l.min."
    ventilation <- data[,"Minute.ventilation..l.min."]
    ventilation[ventilation < 0] <- 0  # Ensure non-negative
    
    # Find nadir
    nadir <- min(ventilation, na.rm=TRUE)
    nadir_results <- c(nadir_results, nadir)
    dose_results <- c(dose_results, dose)
    
    cat("Dose:", dose, "mg | Nadir:", nadir, "L/min | File:", csv_file, "\n")
  } else {
    cat("Warning: File not found:", csv_file, "- Skipping dose", dose, "mg\n")
  }
}

# Create results dataframe (only for doses that were found)
if(length(dose_results) > 0){
  results_df <- data.frame(
    dose_mg = dose_results,
    nadir_L_per_min = nadir_results
  )
  
  # Print results
  cat("\n========================================\n")
  cat("NADIR ANALYSIS RESULTS\n")
  cat("========================================\n")
  print(results_df)
  
  # Save results
  write.csv(results_df, "outputs/nadir_results.csv", row.names=FALSE)
  
#   # Create plot 2.1
#   nadir_plot <- ggplot(results_df, aes(x=dose_mg, y=nadir_L_per_min)) +
#     geom_point(size=3, color="steelblue") +
#     geom_line(color="steelblue", linewidth=1) +
#     labs(
#       x = "Fentanyl Dose (mg)",
#       y = "Nadir Minute Ventilation (L/min)",
#       title = "Nadir Minute Ventilation vs Fentanyl Dose\n(No Naloxone Administration)"
#     ) +
#     theme_bw() +
#     theme(plot.title = element_text(hjust=0.5, size=14, face="bold")) +
#     scale_x_continuous(breaks=doses)
  
#   ggsave("outputs/nadir_plot.pdf", plot=nadir_plot, width=8, height=6)
#   ggsave("outputs/nadir_plot.png", plot=nadir_plot, width=8, height=6, dpi=300)
  
#   cat("\nPlot saved to: outputs/nadir_plot.pdf\n")
# } else {
#   cat("\nERROR: No simulation files found!\n")
#   cat("Please run simulations first.\n")
# }

  # Create plot 2.2 (with ceiling effect)
  nadir_plot <- ggplot(results_df, aes(x=dose_mg, y=nadir_L_per_min)) +
    geom_point(size=3, color="steelblue") +
    geom_line(color="steelblue", linewidth=1) +
    labs(
      x = "Fentanyl Dose (mg)",
      y = "Nadir Minute Ventilation (L/min)",
      title = "Nadir Minute Ventilation vs Fentanyl Dose\n(No Naloxone Administration) with Ceiling Effect"
    ) +
    theme_bw() +
    theme(plot.title = element_text(hjust=0.5, size=14, face="bold")) +
    scale_x_continuous(breaks=doses)
  
  ggsave("outputs/nadir_plot.pdf", plot=nadir_plot, width=8, height=6)
  ggsave("outputs/nadir_plot.png", plot=nadir_plot, width=8, height=6, dpi=300)
  
  cat("\nPlot saved to: outputs/nadir_plot.pdf\n")
} else {
  cat("\nERROR: No simulation files found!\n")
  cat("Please run simulations first.\n")
}