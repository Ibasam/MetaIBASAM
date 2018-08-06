#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)
if (length(args)==0){
  args <- 1
}
# These lines have to be on top!

#_________________ PACKAGES _________________#
library(metaIbasam)
library(doParallel)

#_________________ PARAMETERS _________________#
source("parIbasam.R")

#_________________ FUNCTIONS _________________#
source("Ibasam.R")

#_________________ DATA _________________#
source("dataIbasam.R")

# Create temporary folder
system('mkdir tmp')

#_________________ SIMULATIONS _________________#
cl <- makeCluster(npop)
registerDoParallel(cl)

results <- foreach(i=1:npop, .packages='metaIbasam') %dopar% {
#results <- foreach(i=1:npop, .export=c('Ibasam'), .packages='metaIbasam') %dopar% {
  Ibasam(nInit=10,nYears=nYears # Nb years simulated
                       , npop = npop # Number of popualtions
                       , Pop.o = i # Population of origin
                       , rPROP = rPROP # Proportion de la taille de pop
                       , CC.Temp=tempCC # Water Temperature increase (keep constant if 0)
                       , CC.Amp=ampCC # Flow amplitude increase (keep constant if 1)
                       , CC.Sea=seaCC #.75 # decreasing growth condition at sea (seqeunce from 1 to .75; keep constant if 1)
                       , fisheries=fish.state, stage = fish.stage, fishing_rate=frates
                       , returning=TRUE # if TRUE, return R object contaning all data (very long)
                       , plotting=FALSE,window=FALSE,success=FALSE,empty=TRUE
                       , aire=aireScript[i]
                       , Rmax=RmaxScript[i]*M[i]#10*M[i]     #Rmax reference Scorff * coeff multiplicateur
                       , alpha=alphaScript[i]*M[i] #0.1*M[i]   #alpha reference Scorff * coeff multiplicateur
                       , pstray=pstrayScript[i,]  # Dispersal probability #ligne popo
  )
}
save(results,file=paste0("results/Metapop_Sc",scenarioConnect,scenarioEnvi,"_Sim",args,".RData"))

# Cleaning
stopCluster(cl)
rm(cl)
gc() # clean memory
system('rm -R tmp')

if (args > 1) { q('no') # close R session }
