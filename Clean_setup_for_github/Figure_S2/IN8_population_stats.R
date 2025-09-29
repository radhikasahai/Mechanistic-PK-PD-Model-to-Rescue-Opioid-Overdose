rm(list = ls()) #removes all objects from the current workspace
library(dplyr)

# read in the population results
inputFolder <- "output/population_raw_data"
functions <- list.files(path=inputFolder, pattern = "\\.RDS$", ignore.case = TRUE) 
files_to_read <- c(paste0(inputFolder,"/", functions))
population_results <- bind_rows(lapply(files_to_read, readRDS))

# print subjects that don't have an RDS file saved
# only works if population_raw_data was empty before running the population. Otherwise, even if a subject has an error, the old RDS file will still be there
all_subjects <- unique(population_results$subject)

if (any(!(1:2001 %in% all_subjects))){
	print("the following subjects did not run:")
	print(which(!(1:2001 %in% all_subjects)))
} else {
	print("all subjects ran")
}
rm(all_subjects)

# use log transform for plotting
population_results[,"plasma concentration (ng/ml)"] <- log10(population_results[,"plasma concentration (ng/ml)"])

# calculate the quantiles, mean, and sd
population_quantiles <- aggregate(population_results[,"plasma concentration (ng/ml)"], list(population_results$time), quantile, c(0, 0.025, 0.05, 0.25, 0.5, 0.75, 0.95, 0.975, 1),na.rm=TRUE)
population_means <- aggregate(population_results[,"plasma concentration (ng/ml)"], list(population_results$time), mean)
population_sds <- aggregate(population_results[,"plasma concentration (ng/ml)"], list(population_results$time), sd)

# save the results
population_stats <- cbind(population_quantiles$Group.1, population_results[population_results$subject==2001, "plasma concentration (ng/ml)"], population_means$x, population_sds$x, population_quantiles$x)
colnames(population_stats)[1:4] <- c("time", "typical", "mean", "sd")

saveRDS(population_stats, paste0("output/population_stats.RDS"))

# set delete_raw_data to TRUE to delete the raw population results now that the population statistics are saved
delete_raw_data <- TRUE
if(delete_raw_data){
    # double check only directories you intend to delete appear in files_to_read before running the line below
	print("deleting the following directories:")
	print(files_to_read)
	unlink(files_to_read, recursive=TRUE)
}