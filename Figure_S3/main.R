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

# setup fentanyl typical PK parameters for each dosing route
# load IV parameters
source("../parameters/optimalParameters/opioid/fentanylPK.R")
# store IV parameters to be consitent with the expected model parameter names/units (volumes in mL, etc.)
IV_fent_parameters<-c()
IV_fent_parameters["V1"] <- opioidPKParameters[["VP"]]*1000 #convert to mL
IV_fent_parameters["kout"] <- opioidPKParameters[["kout"]]
IV_fent_parameters["k12"] <- opioidPKParameters[["k12"]]
IV_fent_parameters["k13"] <- opioidPKParameters[["k13"]]
IV_fent_parameters["k21"] <- opioidPKParameters[["k21"]]
IV_fent_parameters["k31"] <- opioidPKParameters[["k31"]]

# load transmucosal parameters
source("../parameters/optimalParameters/opioid/fentanylTransmucosalPK.R")
# store transmucosal parameters to be consitent with the expected model parameter names/units
TM_fent_parameters<-c()
TM_fent_parameters["V1"] <- opioidPKParameters[["opioidCentralVolume"]]
TM_fent_parameters["kin"] <- opioidPKParameters[["opioidAbsorptionRate"]]
TM_fent_parameters["ktr"] <- opioidPKParameters[["opioidTransferRate"]]
TM_fent_parameters["kout"] <- opioidPKParameters[["opioidClearanceRate"]]/opioidPKParameters[["opioidCentralVolume"]] # change from clearance to rate constant
TM_fent_parameters["k12"] <- opioidPKParameters[["opioidInterCompartmentalClearanceRate"]]/opioidPKParameters[["opioidCentralVolume"]] # change from clearance to rate constant
TM_fent_parameters["k21"] <- opioidPKParameters[["opioidInterCompartmentalClearanceRate"]]/opioidPKParameters[["opioidPeripheralVolume"]] # change from clearance to rate constant

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

# setup naloxone typical PK parameters for each formulation
# load 2 mg IM naloxone parameters
source("../parameters/optimalParameters/antagonist/naloxoneIM2mgGenericPKBLQ.R") 
# store 2 mg IM naloxone parameters to be consitent with the expected model parameter names/units
IM2_naloxone_parameters<-c()
IM2_naloxone_parameters["V1"] <- antagonistPKParameters[["V1"]]
IM2_naloxone_parameters["kin"] <- antagonistPKParameters[["kin"]]
IM2_naloxone_parameters["ktr"] <- antagonistPKParameters[["ktr"]]
IM2_naloxone_parameters["kout"] <- antagonistPKParameters[["kout2"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IM2_naloxone_parameters["k12"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IM2_naloxone_parameters["k21"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V2"]] # change from clearance to rate constant
IM2_naloxone_parameters["F"] <- antagonistPKParameters[["F"]]

# load 4 mg IN naloxone parameters
source("../parameters/optimalParameters/antagonist/naloxoneIN4mgLabelPK.R") 
# store 4 mg IN naloxone parameters to be consitent with the expected model parameter names/units
IN4_naloxone_parameters<-c()
IN4_naloxone_parameters["V1"] <- antagonistPKParameters[["V1"]]
IN4_naloxone_parameters["kin"] <- antagonistPKParameters[["kin"]]
IN4_naloxone_parameters["ktr"] <- antagonistPKParameters[["ktr"]]
IN4_naloxone_parameters["kout"] <- antagonistPKParameters[["kout2"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IN4_naloxone_parameters["F"] <- antagonistPKParameters[["F"]]

# load 8 mg IN naloxone parameters
source("../parameters/optimalParameters/antagonist/naloxoneIN8mgPK.R") 
# store 8 mg IN naloxone parameters to be consitent with the expected model parameter names/units
IN8_naloxone_parameters<-c()
IN8_naloxone_parameters["V1"] <- antagonistPKParameters[["V1"]]
IN8_naloxone_parameters["kin"] <- antagonistPKParameters[["kin"]]
IN8_naloxone_parameters["ktr"] <- antagonistPKParameters[["ktr"]]
IN8_naloxone_parameters["kout"] <- antagonistPKParameters[["kout2"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IN8_naloxone_parameters["k12"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IN8_naloxone_parameters["k21"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V2"]] # change from clearance to rate constant
IN8_naloxone_parameters["F"] <- antagonistPKParameters[["F"]]

rm(antagonistPKParameters)

# set the model folder to be used for each case
IV_fent_modelFolder <- "models/threeCompartmentPK/"
TM_fent_modelFolder <- "models/twoCompartmentPK_twoTransit/"
oral_fent_modelFolder <- "models/twoCompartmentPK/"
IM2_naloxone_modelFolder <- "models/twoCompartmentPK_twoTransit/"
IN4_naloxone_modelFolder <- "models/oneCompartmentPK_twoTransit/"
IN8_naloxone_modelFolder <- "models/twoCompartmentPK_twoTransit/"

# set time to simulate for all cases (in seconds)
fulltimes <- seq(0, 3*60*60, by=0.1) # 3 hour simulation with 0.1s time-step

# run each case by calling the corresponding simulation function (scripts in simulationFunctions/)

# 1.625 mg IV bolus fentanyl
IV_fent_out <- run_IV_fent(dose=1.625, fulltimes=fulltimes, pk_parameters=IV_fent_parameters, modelFolder=IV_fent_modelFolder) 
# 40.7 mg transmucosal fentanyl
TM_fent_out <- run_TM_fent(dose=40.7, fulltimes=fulltimes, pk_parameters=TM_fent_parameters, modelFolder=TM_fent_modelFolder)  
# 60.4 mg transmucosal fentanyl
oral_fent_out <- run_oral_fent(dose=68.4, fulltimes=fulltimes, pk_parameters=oral_fent_parameters, modelFolder=oral_fent_modelFolder) 

plot_data <- cbind(rbind(IV_fent_out, TM_fent_out, oral_fent_out), data.frame(drug="Fentanyl"))
rm(IV_fent_out, TM_fent_out, oral_fent_out) # release memory

# 2 mg IM naloxone
IM2_naloxone_out <- run_IM2_naloxone(fulltimes=fulltimes, pk_parameters=IM2_naloxone_parameters, modelFolder=IM2_naloxone_modelFolder) 
# 4 mg IN naloxone
IN4_naloxone_out <- run_IN4_naloxone(fulltimes=fulltimes, pk_parameters=IN4_naloxone_parameters, modelFolder=IN4_naloxone_modelFolder) 
# 8 mg IN naloxone
IN8_naloxone_out <- run_IN8_naloxone(fulltimes=fulltimes, pk_parameters=IN8_naloxone_parameters, modelFolder=IN8_naloxone_modelFolder) 

plot_data <- rbind(plot_data, cbind(rbind(IM2_naloxone_out, IN4_naloxone_out, IN8_naloxone_out), data.frame(drug="Naloxone")))
rm(IM2_naloxone_out, IN4_naloxone_out, IN8_naloxone_out) # release memory

plot_data$group <- factor(plot_data$group, unique(plot_data$group))

# plotting
source("plotting_function.R")

gg_color_hue <- function(n) {
	hues = seq(15, 375, length = n + 1)
	hcl(h = hues, l = 65, c = 100)[1:n]
}
colorPalette = gg_color_hue(length(unique(plot_data$group)))

name_idx <- 1

fent_plot <- plotting_function(plot_data, "Fentanyl", colorPalette[unique(plot_data$group) %in% unique(plot_data[plot_data$drug == "Fentanyl","group"])])
naloxone_plot <- plotting_function(plot_data, "Naloxone", colorPalette[unique(plot_data$group) %in% unique(plot_data[plot_data$drug == "Naloxone","group"])])

plot <- arrangeGrob(fent_plot, naloxone_plot, ncol=2)

ggsave("Figure_S3.png", plot, width=10, height=5)
