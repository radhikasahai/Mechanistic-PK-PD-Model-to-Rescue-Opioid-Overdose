rm(list = ls()) #removes all objects from the current workspace

library(deSolve)
library(optparse)

parser<-OptionParser()
parser<-add_option(parser, c("-a", "--subjectIndex"), default ="2001",type="numeric",help="subject index [decides what parameter set to use among population parameter sets](options: 1-2001, 2001 is the 'average' patient)")
inputs<-parse_args(parser)

#source the simulation function
source("simulationFunctions/run_IN8_naloxone.R")

# load 8 mg IN naloxone population parameters
antagonistPKParameters <- read.csv("../parameters/populationParameters/antagonist/naloxoneIN8mgPKPopulation.csv") 
# store 8 mg IN naloxone population parameters to be consitent with the expected model parameter names/units
IN8_naloxone_parameters<-c()
IN8_naloxone_parameters["V1"] <- antagonistPKParameters["V1"]
IN8_naloxone_parameters["kin"] <- antagonistPKParameters["Kin"]
IN8_naloxone_parameters["ktr"] <- antagonistPKParameters["Ktr"]
IN8_naloxone_parameters["kout"] <- antagonistPKParameters["Kout"]/antagonistPKParameters["V1"] # change from clearance to rate constant
IN8_naloxone_parameters["k12"] <- antagonistPKParameters["k12N"]/antagonistPKParameters["V1"] # change from clearance to rate constant
IN8_naloxone_parameters["k21"] <- antagonistPKParameters["k12N"]/antagonistPKParameters["V2"] # change from clearance to rate constant
IN8_naloxone_parameters["F"] <- antagonistPKParameters["F"]

IN8_naloxone_parameters <- as.data.frame(IN8_naloxone_parameters)

# load 8 mg IN naloxone typical parameters
source("../parameters/optimalParameters/antagonist/naloxoneIN8mgPK.R") 
# store 8 mg IN naloxone typical parameters to be consitent with the expected model parameter names/units
IN8_naloxone_typical_parameters<-c()
IN8_naloxone_typical_parameters["V1"] <- antagonistPKParameters[["V1"]]
IN8_naloxone_typical_parameters["kin"] <- antagonistPKParameters[["kin"]]
IN8_naloxone_typical_parameters["ktr"] <- antagonistPKParameters[["ktr"]]
IN8_naloxone_typical_parameters["kout"] <- antagonistPKParameters[["kout2"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IN8_naloxone_typical_parameters["k12"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V1"]] # change from clearance to rate constant
IN8_naloxone_typical_parameters["k21"] <- antagonistPKParameters[["k12N"]]/antagonistPKParameters[["V2"]] # change from clearance to rate constant
IN8_naloxone_typical_parameters["F"] <- antagonistPKParameters[["F"]]

# have idx 2001 as typical subject
IN8_naloxone_parameters <- rbind(IN8_naloxone_parameters, IN8_naloxone_typical_parameters)

# set model folder
IN8_naloxone_modelFolder <- "models/twoCompartmentPK_twoTransit/"

# set time to simulate
fulltimes <- seq(0, 30*60, by=.1) # 30 min simulation with .1s time-step
# Run this subject
IN8_naloxone_out <- run_IN8_naloxone(fulltimes=fulltimes, pk_parameters=unlist(IN8_naloxone_parameters[inputs$subjectIndex,]), modelFolder=IN8_naloxone_modelFolder) 
IN8_naloxone_out <- cbind(data.frame(subject=inputs$subjectIndex), IN8_naloxone_out)

# set folder to store subject results
outputFolder <- "output/population_raw_data/"
system(paste0("mkdir -p ",outputFolder))

saveRDS(IN8_naloxone_out, paste0(outputFolder,"subject_", inputs$subjectIndex, ".RDS"))