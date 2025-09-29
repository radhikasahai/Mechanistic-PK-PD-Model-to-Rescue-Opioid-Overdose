rm(list = ls()) #removes all objects from the current workspace

#load required package(s)
library(deSolve)
library(ggplot2)
library(grid)
library(gridExtra)
library(stringr)


# source all simulation functions
functions <- list.files(path="simulationFunctions", pattern = "\\.R$", ignore.case = TRUE) 
files_to_source <- c(paste0("simulationFunctions/", functions))
lapply(files_to_source, source)

# load oral parameters
source("../parameters/optimalParameters/opioid/fentanylOralPK.R")
# store IV parameters to be consitent with the expected model parameter names/units (volumes in mL, etc.)
oral_fent_parameters<-c()
oral_fent_parameters["V1"] <- opioidPKParameters[["VP"]]*1000 #convert to mL
oral_fent_parameters["kin"] <- opioidPKParameters[["kinC"]]
oral_fent_parameters["kout"] <- opioidPKParameters[["kout"]]
oral_fent_parameters["k12"] <- opioidPKParameters[["k12"]]
oral_fent_parameters["k21"] <- opioidPKParameters[["k21"]]

rm(opioidPKParameters)
# set the model folder to be used
oral_fent_modelFolder <- "models/twoCompartmentPK/"

# set time to simulate for all cases (in seconds)
fulltimes <- seq(0, 24*60*60, by=0.1) # 3 hour simulation with 0.1s time-step

# run each case by calling the corresponding simulation function (scripts in simulationFunctions/)
# 15*70/1000 = 1.05 mg transmucosal fentanyl
plot_data <- run_oral_fent(dose=15*70/1000, fulltimes=fulltimes, pk_parameters=oral_fent_parameters, modelFolder=oral_fent_modelFolder) 

# plotting
source("plotting_function.R")
data <- read.csv("../data/oral_fentanyl_pk.csv")

plot <- plotting_function(plot_data,data)


ggsave("Figure_S1.png", plot, width=5, height=5)
