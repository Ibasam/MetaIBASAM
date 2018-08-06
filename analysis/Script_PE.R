## remove (almost) everything in the working environment.
rm(list = ls())

#_________________ DIRECTORY_________________#
# if (Sys.getenv("USERNAME")=="basp-meco88") {
#   path <- "~/Documents/RESEARCH/PROJECTS/IBASAM/CCvsFisheries/"
#   setwd(paste(path,"results/withTO/",sep=""))
# } else {
#   path <- "/raid/mathieu/IBASAM/"
#   setwd(paste(path,"withTO/",sep=""))
# }

setwd("/media/hdd/mbuoro/MetaIBASAM/analysis/30Simul")


#_________________ FUNCTIONS_________________#
proportions.population <- function (population, window = TRUE, plotting = TRUE, titles = "") {
  
  parr0 <- (population$Parr==1 & population$AgeRiver<1)
  parr1 <- (population$Parr==1 & population$AgeRiver>1)
  parr0.mature <- (population$Parr==1 & population$AgeRiver<1 & population$Mature==1)
  parr1.mature <- (population$Parr==1 & population$AgeRiver>1 & population$Mature==1)
  grilses <- (population$Returns > 0 & population$AgeSea < 2)
  MSW <- (population$Returns > 0 & population$AgeSea >= 2)
  
  parr1ratio <- sum(parr0)/sum(parr1)
  OnevsMSWratio <- sum(grilses)/sum(MSW)
  
  sexratioParr <- sum(parr1 & population$Female == 0)/sum(parr1 & population$Female == 1)
  sexratioGrilses <- sum(grilses & population$Female == 0)/sum(grilses & population$Female == 1)
  sexratioMSW <- sum(MSW & population$Female == 0)/sum(MSW &  population$Female == 1)
  
  Nmale.mature <- sum(parr0.mature & population$Female == 0) + sum(parr1.mature & population$Female == 0) +  sum(grilses & population$Female == 0) + sum(MSW & population$Female == 0)
  NFemale.mature <- sum(parr0.mature & population$Female == 1) + sum(parr1.mature & population$Female == 1) +  sum(grilses & population$Female == 1) + sum(MSW & population$Female == 1)
  
  return(list(
    Ovs1parrratio = parr1ratio
    , sexratioParr = sexratioParr
    , OnevsMSWratio = OnevsMSWratio
    , sexratioGrilses = sexratioGrilses
    , sexratioMSW = sexratioMSW
    , nReturns = sum(grilses) +  sum(MSW)
    , OSR=Nmale.mature / NFemale.mature))
}

# Load functions for plotting results
#source(paste(path,"code/Myplots.R",sep=""))
library(ecofolio)
source("/media/hdd/mbuoro/MetaIBASAM/analysis/pe_mv.R")

#_________________ PARAMETERS_________________#
#REPSIMUL <- getwd() #"~/Documents/RESEARCH/PROJECT/IBASAM/EXEMPLE"
EXPE <- c(11,12,21,22,31,32)

# 3 scenarios for STAT:
#grilse: 0.15 / MSW: 0.15 => "Control"
#grilse: 0.3 / MSW: 0 => "1SW"
#grilse: 0. / MSW: 0.3 => "MSW"

# 5 scenarios for TAILLE:
# small: 0.15 / med: 0.15 / big: 0.15 => "Control"
# small: 0.6 / med: 0 / big: 0 => "Small"
# small: 0 / med: 0.3 / big: 0 = "Med"
# small: 0 / med: 0 / big: 0.6 => "Big"
# small: 0.3 / med: 0 / big: 0.3 => "Big small"


nSIMUL <- 30
nYear <- 50
nInit <- 15 # Nb years at initialization



#-------------------------------#
#  Composition des populations  #
#-------------------------------#
tmp1 <- tmp3 <- tmp4 <- list()
nReturns <- list() # Nb returns
NRet.res <- list() # Nb returns
PE <- list()


indice <- 0
for (iEXPE in EXPE){ # Loop over scenario (CC0_pecheSTAT, ...)
  cat("Composition for ", iEXPE, "\n")
    
  pe=petr=sync=CV_est=CV_obs=CV_esttr=CV_obstr=NULL
    
    for (repmod in 1:nSIMUL){ # loop over simulations
      #cat(indice,"/",repmod,"- ")
      cat("Simulation :",repmod,"\n")
      perc <- (repmod/nSIMUL)*100
      if(perc %in% (seq(0,90,10))) cat(perc,"% ~ ")
      if(perc == 100) cat(perc,"%","\n")
      
      # Loading data files
      tmp2 <- NULL
      NRet.table = NULL
      for (pop in 1:16){
        
      load(paste0("Scenario",iEXPE,"/RES_Pop-",pop,"_Simu-",repmod,".RData"))
      demo <- NULL
      demo <- RES
      demo <- demo[demo$year>nInit,]
      demo$year	<- demo$year - nInit
      
      
      #-------------------------------#
      #  Composition des populations  #
      #-------------------------------#  
      
      # toto1 <- demo$year # years (from 1 to (max(demo$year)-1))
      # if(sum(is.na(toto1)==0)!=0){
      #   nReturns.tmp = NULL
      #   for (i in 1:(max(demo$year)-1)){
      #     res <- proportions.population(demo[demo$year==i,])
      #     
      #     nReturns.tmp <- c(nReturns.tmp,res$nReturns)
      # 
      #   }} else{res <- NA}
      # 
      # nReturns.table <- rbind(nReturns.table, nReturns.tmp)
      # 
      
      # Number of returns
      toto1 <- demo$year # years (from 1 to (max(demo$year)-1))
      toto2 <- demo$Returns # individual indicator of return ( 1, 0 otherwise)
      if(sum(is.na(toto1)==0)!=0){
        NRet <- NULL
        for (i in 1:(max(demo$year)-1)){
          NRet <- c(NRet,sum(toto2[toto1==i],na.rm=T))
        }}
      else{NRet <- NA}
      #NRet.res[[indice]][[repmod]] <- NRet    
      NRet.table <- cbind(NRet.table, NRet)
      
    #tmp1[[pop]] <- nReturns.table
    #tmp2 <- cbind(tmp2,NRet.table)


  } # end loop population
      
      #tmp3[[repmod]] <- tmp1
      tmp4[[repmod]] <- NRet.table
      
     # tmp<- pe_avg_cv(NRet.table, detrending=c("linear_detrended"))
      tmp <- pe_mv(NRet.table, type="linear", ci = TRUE)
      pe[repmod] <- tmp$pe
      CV_est[repmod] <- tmp$cv_single_asset
      CV_obs[repmod] <- tmp$cv_portfolio
      
      tmp <- pe_mv(NRet.table, type = "loess_detrended", ci = TRUE)
      petr[repmod] <- tmp$pe
      CV_esttr[repmod] <- tmp$cv_single_asset
      CV_obstr[repmod] <- tmp$cv_portfolio
      # m?tapop 1.3 fois plus stable que si c'?tait une pop isol?e mais ici PAS DE CONNECTIVITE
      # effet portfolio d? ? autre chose ici? 
      sync[repmod] <- synchrony(NRet.table) #0.2635 ?a c'est bien :) car 1 synchrone, 0 asynchrone
      
    } # end loop simul

  tmp5 <- cbind(pe,CV_est,CV_obs,petr,CV_esttr,CV_obstr,sync)
  
    #nReturns[[paste0(iEXPE)]] <- tmp3
    nReturns[[paste0(iEXPE)]] <- tmp4
    PE[[paste0(iEXPE)]] <- tmp5

} # end scenario

### Save results
save(nReturns, PE, file="PE.Rdata")

