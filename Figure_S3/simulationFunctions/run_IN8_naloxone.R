# runs the typical 8mg IN naloxone PK simulation
# called by main.R
# inputs:
#   -fulltimes => times to output in seconds
#   -pk_parameters => scenario specific PK parameters. Must be compatible (i.e. same parameter names and units) with model selected via modelFolder
#   -modelFolder => location of the model selected
# outputs: dataframe with model output and a "group" column labeling the simulation scenario

run_IN8_naloxone <- function(fulltimes, pk_parameters, modelFolder){
    # fixed dose of 8 mg
    dose <- 8

    dyn.load(paste0(modelFolder,"delaymymod.so"))
    source(paste0(modelFolder,"delaypars.R"))
    source(paste0(modelFolder,"delaystates.R"))
    source(paste0(modelFolder,"setModelOutputVariables.R"))

    # update the model parameters with the 8 mg IN naloxone parameters
    truepar <- pars

    paridx<-match(names(truepar), names(pk_parameters), nomatch=0)
	truepar[paridx!=0] <- pk_parameters[paridx]
    
    # add the dose to the initial state
    states["D"] <- dose
    # change the bioavailablility
    states["F"] <- pk_parameters[["F"]]


    # set the starttime to the current time
    truepar["starttime"]<-unclass(as.POSIXct(strptime(date(),"%c")))[1]
    # run the model
    out <- ode(states, fulltimes, "derivs", truepar, dllname="delaymymod", initfunc="initmod", nout=length(namesyout), rtol=1e-14, atol=1e-14, method="adams")
    colnames(out)[(length(states)+2):(length(states)+length(namesyout)+1)]=namesyout
    out <- as.data.frame(out)
    out <- cbind(out, data.frame(group=paste0(dose, "mg IN naloxone")))

    return(out[,c("time", "plasma concentration (ng/ml)", "group")])
}