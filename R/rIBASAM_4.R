library(Ibasam)
  
  ##First read in the arguments listed at the command line
  # args=(commandArgs(TRUE))
  
  # Popualtion of origin: 4
  # Number of popualtions: 4

## Load straying scenario
load("R/straying.RData")

  
  CC_Temp=0
  CC_Amp=0
  fisheries = TRUE
   fishing_rate = c(0.15, 0.15, 0.15)
    plotting = TRUE
    window = FALSE
     returning = FALSE
      success = TRUE
       empty = TRUE
       # 10=10
  empty()
    def <- defaultParameters()
    def$envParam[9] <- 200811 *0.1      #attention grosse pop
    mm <- river_climate_model(10 + 1, CC_Temp, CC_Amp)
    Reset_environment()
    Prepare_environment_vectors(mm$temperatures, mm$logrelflow)
    setup_environment_parameters(def$envParam)
    setup_collection_parameters(def$colParam)
    set_collecID(55)
    time_tick(90)
    add_individuals(def$gParam)
    add_individuals(def$parrParam)
    add_individuals(def$smoltsParam)
    go_summer()
    popo <- observe()
    add_individuals(def$grilseParam)
    add_individuals(def$mswParam)
    go_winter()
    popa <- observe()
    if (returning || success) {
        results <- observe()
    }
    ratios <- matrix(NA, nrow = 10, ncol = 4)
    winterM <- matrix(NA, nrow = 10, ncol = 6)
    summerM <- matrix(NA, nrow = 10, ncol = 18)
    ally <- summarize.oneyear(popo, popa)
    sptm <- NULL
    pb <- txtProgressBar(1, 10, style = 3)
    for (y in 1:10) {
        setTxtProgressBar(pb, y)
        ptm <- proc.time()
        spring()
        summer()
        
        if (fisheries) {
            rates <- cbind(grilses = rep(fishing_rate[1], 10), 
                msw = rep(fishing_rate[2], 10))
            fishing(rates[y, ])
        }        
        
        popo <- observe()
        if (returning || success) {
            results <- rbind(results, popo)
        }
        ratios[y, ] <- unlist(proportions.population(popo))
        summerM[y, ] <- unlist(important.indicator.summer.population(popo))
        autumn()
        winter()
        popa <- observe()
        
        # STRAYING
        #emmigrants("nom de fichier", straying_rates for 1SW & MSW)
        #pause("nom de fichier")
        #immigrants("nom de fichier")
        # emmigrants(paste0("tmp/Pop_",Pop,"_",y,".txt"),c(0.1,0.1))
        # popb <- observe()
        # pause(paste0("tmp/Pop_",Pop_im,"_",y,".txt")) # R script to pause the execution of Ibasam until immigrant file (e.g. mig_AtoB) is created in a specific folder
        # immigrants(paste0("tmp/Pop_",Pop_im,"_",y,".txt"))
        # popc <- observe()
        
        for (Pop.e in 1:4){
          # 4: population of origin
          # Pop.e: emigrate to population Pop.e
          if(Pop.e == 4) { 
            next 
            } else {
          emfile <- paste("tmp/Mig_",4,"-",Pop.e,"_",y,".txt",sep="")
          #pstray <- c(0.1,0.1)
          pstray <- c(mstray[4, Pop.e], mstray[4, Pop.e])
          emmigrants(emfile,pstray)
          } # end if
        } # end Pop.e
        
        popb <- observe()
        
        for (Pop.i in 1:4){
          # 4: population of origin
          # Pop.i: immigrate from population Pop.i
          if(Pop.i == 4) { 
            next 
          } else {
          imfile <- paste("tmp/Mig_",Pop.i,"-",4,"_",y,".txt",sep="")
          pause(imfile) # R script to pause the execution of Ibasam until immigrant file (e.g. mig_AtoB) is created in a specific folder
          immigrants(imfile)
          } # end if
        } # end Pop.i

        popc <- observe()
        
        if (returning || success) {
            results <- rbind(results, popa)
        }
        winterM[y, ] <- unlist(important.indicator.winter.population(popa))
        ally <- append.oneyear(popo, popa, ally)
        sptm <- rbind(sptm, proc.time() - ptm)
    }
    if (plotting) {
        pdf(paste('tmp/Res_Pop',4,'.pdf',sep=''))
        op <- par(mfrow = c(2, 2))
        plot_proportions_population(ratios, window = window)
        plot_winterM(winterM, window = window)
        plot_summerM(summerM, window = window)
        plotevolution(ally, window = window)
        par(mfrow = c(2, 1))
        if (success) {
            newwindow(window)
            suc <- temporal_analyse_origins(results, 1:10, 
                plotting = plotting, titles = "Strategy success through time")
        }
        newwindow(window)
        plot(ts(sptm[, 1]), main = "CPU time needed per year", 
            ylab = "seconds", xlab = "years", bty = "l", sub = paste("Total:", 
                round(sum(sptm[, 1]), 3)))
        lines(lowess(sptm[, 1]), col = 2, lty = 2)
        par(op)  
        dev.off()
    }
        