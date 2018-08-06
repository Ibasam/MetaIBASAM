## remove (almost) everything in the working environment.
rm(list = ls())

#_________________ DIRECTORY_________________#
setwd("/media/hdd/mbuoro/MetaIBASAM/Subpops")


#_________________ FUNCTIONS_________________#
# Load functions for plotting results
#source(paste(path,"code/Myplots.R",sep=""))


#_________________ PARAMETERS_________________#
source("parIbasam.R")
nSIMUL <- 1
# nYear <- 50
nInit <- 10 # Nb years at initialization
# npop <- 3 # Nb of populations

# Scenarios
EXPE <- c(21)#,12,21,22,31,32)

res=list()
for (iEXPE in EXPE){ # Loop over scenario
    cat("Scenario :",iEXPE,"\n")
    
    SIM=list()
    for (repmod in 1:nSIMUL){ # loop over simulations
      #cat(indice,"/",repmod,"- ")
      perc <- (repmod/nSIMUL)*100
      if(perc %in% (seq(0,90,10))) cat(perc,"% ~ ")
      if(perc == 100) cat(perc,"%","\n")
      
      # Load data
      load(paste0("results/Metapop_Sc",EXPE,"_Sim",repmod,".RData"))  
      
      POP=list()
      for (pop in 1:npop){
        
      # Load data
      #load(paste0("Scenario",iEXPE,"/RES_Pop-",pop,"_Simu-",repmod,".RData"))
      
      # Remove initial values
      demo <- NULL
      demo <- results[[pop]]
      demo <- demo[demo$year>nInit,]
      demo$year	<- demo$year - nInit
      
      #-------------------------------#
      #  Composition des populations  #
      #-------------------------------#  
      id <- which((demo$Parr==1) & (demo$AgeRiver<1))
      PARR <- data.frame(ID = demo$ID[id]
                        , years = demo$year[id]
                        , Lf = demo$Lf[id]
                        #, pG = demo$pG[id]
                        #, pG_sea = demo$pG_sea[id]
                        , CollecID = demo$CollecID[id]
                        #, AgeSea = demo$AgeSea[id]
      )
      
      id <- which((demo$Atsea==0)&(demo$AgeSea>0)&(demo$date==273))
      ADU <- data.frame(ID = demo$ID[id]
                          , years = demo$year[id]
                          , Lf = demo$Lf[id]
                          , pG = demo$pG[id]
                          , pG_sea = demo$pG_sea[id]
                          , CollecID = demo$CollecID[id]
                          , AgeSea = demo$AgeSea[id]
                          )

    POP[[pop]] <- list(ADU=ADU, PARR=PARR)
      
    } # end loop pop
      
  SIM[[repmod]] <- POP

  } # end loop SIMUL
    
res[[paste0(iEXPE)]] <- SIM
      
} # end loop EXPE

### Save results
save(res, file="results/PHENOTYPE.Rdata")

