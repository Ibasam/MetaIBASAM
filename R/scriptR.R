## Loading libraries, functions,...
setwd(paste("REPbase","Ibasam","vIBASAM","/",sep=""))

dyn.load("libs/libIbasam.so")
source("R/WrappingDLL.r")
source("R/metaFunctions.r")
source("R/print.table.r")
source("R/summarize.evolution.r")
source("R/strategy.analyse.r")
source("R/river_climate_model.r")
#source("R/look_environment_data.r")
# file.sources = list.files("R/",pattern="*.R", recursive=TRUE,full.names=TRUE)
# sapply(file.sources,source,.GlobalEnv)
#for (f in list.files(pattern="*.R")) {
#    source(f)
#}

## Loading Ibasam R script 
setwd(paste("REPbase","vIBASAM","/",sep=""))
Sys.setlocale('LC_ALL','C') 
#source(paste("scriptIBASAM","vIBASAM","iSIMUL","_TMP.R",sep=""))
#source(paste("demoIbasam","iSIMUL","_TMP.R",sep=""))
source("demoIbasam_TMP.R")

## Run simualtions
#RES <- list()
for (i in 1:nSIMUL){
  RES <- demoIbasam(nInit=init,nYears=years # Nb years simulated
                    , CC.Temp=tempCC # Water Temperature increase (keep constant if 0)
                    , CC.Amp=ampCC # Flow amplitude increase (keep constant if 1)
                    , CC.Sea=seaCC #.75 # decresaing growth condition at sea (seqeunce from 1 to .75; keep constant if 1)
                    , fisheries=fish.state, stage = fish.stage, fishing_rate=c(rate1,rate2,rate3)
                    , returning=TRUE # if TRUE, return R object contaning all data (very long)
                    , plotting=FALSE,window=FALSE,success=FALSE,empty=TRUE
  )
  #RES <- RES[RES$year>init,]
  save(RES,file=paste("RESsimul","iSIMUL","-",i,".RData",sep=""))
  
}
#save(RES,file=paste("RESsimul",iSIMUL,".RData",sep=""))


##________________ Plot CC______________ ###
    env<-RES[[2]]
    #env <- look_environment_data() # CRASHED under Rstudio!
    #plot(look_environment_data())
    nyear <- init+years -1
    env$year <- rep(1:nyear,each=365)
    #colnames(env) <- c("days", "temperatures","logrelflow","year")


    meanT <- meanQ <- array(,dim=c(nyear,3))
    muT <- muQ <-diffQ <- NULL
    for (y in 1:nyear){
      meanT[y,] <- quantile(env$temperatures[env$year==y],probs=c(0.025, 0.5, 0.975),na.rm = TRUE)
      muT[y] <- mean(env$temperatures[env$year==y],na.rm = TRUE)

      #meanQ[y,] <- quantile(env$logrelflow[env$year==y],probs=c(0.025, 0.5, 0.975),na.rm = TRUE)
      meanQ[y,2] <- quantile(env$logrelflow[env$year==y],probs = c(0.5) ,na.rm = TRUE)
      meanQ[y,1] <- min(env$logrelflow[env$year==y],na.rm = TRUE)
      meanQ[y,3] <- max(env$logrelflow[env$year==y],na.rm = TRUE)
      muQ[y] <- mean(env$logrelflow[env$year==y],na.rm = TRUE)
      diffQ[y] <- meanQ[y,3] - meanQ[y,1]
    }


    pdf("vIBASAM.pdf")

    par(mfrow=c(2,2))

    colfunc <- colorRampPalette(c("black", "red"))

    plot(NULL,xlim=c(1,365),ylim=c(0,25),xlab="Days",ylab="Temperature",main="Temperature")
    for (y in 1:nyear){
      points(env$temperatures[env$year==y],type='l',col=colfunc(nyear)[y])
      # points(env$temperatures[env$year==1],type='l',col=colfunc(nYears)[1])
      # points(env$temperatures[env$year==25],type='l',col=colfunc(nYears)[25])
      # points(env$temperatures[env$year==nYears],type='l',col=colfunc(nYears)[nYears])
    }

    plot(NULL,xlim=c(1,nyear),ylim=c(0,25),xlab="Years",ylab="Temperature")
    points(meanT[,2],pch=16)
    points(muT,pch=17)
    points(env$mT,pch=17,col=2,type='l')
    segments(1:nyear, meanT[,1],1:nyear, meanT[,3])
    abline(h=12.674299,lty=2)
    data <- data.frame(y=meanT[,2],x=1:nyear)
    abline(lm(y ~ x, data=data), col="blue",lwd=2)
    legend("topright", c("Expected", "observed"),lty=c(1,1),col=c("red","blue"),bty="n")



    plot(NULL,xlim=c(1,365),ylim=c(0,10),xlab="Days",ylab="Debit", main="Debit")
    for (y in 1:nyear){
      # points(exp(env$logrelflow[env$year==y]),type='l',col=colfunc(nYears)[y])
      points(exp(env$logrelflow[env$year==1]),type='l',col=colfunc(nyear)[1])
      points(exp(env$logrelflow[env$year==round(nyear/2)]),type='l',col=colfunc(nyear)[round(nyear/2)])
      points(exp(env$logrelflow[env$year==nyear]),type='l',col=colfunc(nyear)[nyear])
    }


    plot(NULL,xlim=c(1,nyear),ylim=c(1,8),xlab="Years",ylab="Amplitude (Max - Min)", main="Debit")
    #points(muQ,pch=17)
    #points(meanQ[,2],pch=16)
    #points(muQ,pch=17)
    points(3+env$aF,pch=17,col=2,type="l")
    #segments(1:nYears, meanQ[,1],1:nYears, meanQ[,3])
    points(diffQ,pch=16)
    abline(h=env$mF,lty=2)
    data <- data.frame(y=diffQ,x=1:nyear)
    abline(lm(y ~ x, data=data), col="blue",lwd=2)
    legend("topright", c("Expected", "observed"),lty=c(1,1),col=c("red","blue"),bty="n")
    
    dev.off()
  
  




