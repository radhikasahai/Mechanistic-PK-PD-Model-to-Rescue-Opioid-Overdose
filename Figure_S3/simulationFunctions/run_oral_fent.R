# runs the typical oral PK simulation
# called by main.R
# inputs:
#   -dose => dose in mg to simulation. Default is 68.4 mg
#   -fulltimes => times to output in seconds
#   -pk_parameters => scenario specific PK parameters. Must be compatible (i.e. same parameter names and units) with model selected via modelFolder
#   -modelFolder => location of the model selected
# outputs: dataframe with model output and a "group" column labeling the simulation scenario

run_oral_fent <- function(dose=68.4, fulltimes, pk_parameters, modelFolder){

    dyn.load(paste0(modelFolder,"delaymymod.so"))
    source(paste0(modelFolder,"delaypars.R"))
    source(paste0(modelFolder,"delaystates.R"))
    source(paste0(modelFolder,"setModelOutputVariables.R"))

    # update the model parameters with the oral fentanyl parameters
    truepar <- pars

    paridx<-match(names(truepar), names(pk_parameters), nomatch=0)
	truepar[paridx!=0] <- pk_parameters[paridx]

    # add the dose to the initial state
    states["D"] <- dose


    # set the starttime to the current time
    truepar["starttime"]<-unclass(as.POSIXct(strptime(date(),"%c")))[1]
    # run the model
    out <- ode(states, fulltimes, "derivs", truepar, dllname="delaymymod", initfunc="initmod", nout=length(namesyout), rtol=1e-14, atol=1e-14, method="adams")
    colnames(out)[(length(states)+2):(length(states)+length(namesyout)+1)]=namesyout
    out <- as.data.frame(out)
    out <- cbind(out, data.frame(group=paste0(dose, "mg Oral Fentanyl")))

    return(out[,c("time", "plasma concentration (ng/ml)", "group")])
}