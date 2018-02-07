## Loading libraries, functions,...
#setwd(paste("REPbase","Ibasam","vIBASAM","/",sep=""))

library(Ibasam)

## Loading Ibasam R script 
#setwd(paste("REPbase","vIBASAM","/",sep=""))
#Sys.setlocale('LC_ALL','C') 
#source(paste("scriptIBASAM","vIBASAM","iSIMUL","_TMP.R",sep=""))
#source(paste("demoIbasam","iSIMUL","_TMP.R",sep=""))
source("demoIbasam.R")

## Run simualtions
#RES <- list()
#for (i in 1:nSIMUL){
  RES <- demoIbasam(nInit=init,nYears=years # Nb years simulated
                    , npop = Npop # Number of popualtions
                    , Pop.o = popo # Popualtion of origin
                    , rPROP = .1 # Popualtion size (1/10 of production area)
                    , pstray = 0.5
                    , CC.Temp=tempCC # Water Temperature increase (keep constant if 0)
                    , CC.Amp=ampCC # Flow amplitude increase (keep constant if 1)
                    , CC.Sea=seaCC #.75 # decresaing growth condition at sea (seqeunce from 1 to .75; keep constant if 1)
                    , fisheries=fish.state, stage = fish.stage, fishing_rate=c(.15,.15,.15)
                    , returning=TRUE # if TRUE, return R object contaning all data (very long)
                    , plotting=TRUE,window=FALSE,success=FALSE,empty=TRUE
  )
  #RES <- RES[RES$year>init,]
  save(RES,file=paste0("tmp/RESsimul_",popo,".RData"))
  #save(RES,file=paste0("RESsimul_",popo,"_iSIMUL","-",i,".RData"))
#}
#save(RES,file=paste("RESsimul",iSIMUL,".RData",sep=""))






