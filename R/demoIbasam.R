demoIbasam <-
  function (nInit,nYears
            , CC.Temp, CC.Amp
            , CC.Sea
            , fisheries = TRUE, stage = TRUE, fishing_rate=c(.15, .15, .15)
            , plotting = FALSE, window = FALSE, returning = TRUE, success = FALSE, empty = TRUE) 
  {
    
    #Initialization & Preparation:
    empty()
    def <- defaultParameters()
    
    #on change les param?tres environnementaux et d'?mergence
    def$envParam[9] <- 200811*rPROP#1/10 du scorff
    def$gParam[1] <- round(def$envParam[9]*8*0.15)
    def$parrParam[1] <- round(def$gParam[1]*0.011)
    def$smoltsParam[1] <- round(def$gParam[1]*0.03)
    def$grilseParam[1] <- round(def$gParam[1]*0.003)
    def$mswParam[1] <- round(def$gParam[1]*0.0005)
    def$colParam[41] <- def$envParam[9]*2#2 oeufs / m2
    #19:24 = forme du compromis (maxRIV,sigRIV,kappaRIV,maxSEA,sigSEA,kappaSEA)
    def$colParam[19:24] <- c(maxRIV,sigRIV,kappaRIV,maxSEA,sigSEA,kappaSEA)
    #63 = h?ritabilit? de la croissance en rivi?re
    def$colParam[63] <- heriRIV
    #67 = h?ritabilit? de la croissance en mer
    def$colParam[67] <- heriSEA
    #survies
    def$colParam[13:18] <- c(SP0,SP1,SP1S,SP1M,SPnM,SPn) #daily survival prob parr 0 to 0.5; daily survival prob parr 0.5 to 1.0; daily survival prob smolts 0.5 to run; daily survival prob parr mature 0.5 to 1.0; daily survival prob parr mature n.5 to n+1; daily survival prob parr any other situations
    
    ## ENVIRONMENT:
    mm <- river_climate_model(nInit, nYears + 1, CC.Temp, CC.Amp)
    Reset_environment()
    Prepare_environment_vectors(mm$temperatures, mm$logrelflow)
    setup_environment_parameters(def$envParam)
    setup_collection_parameters(def$colParam)
    
    
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
    ratios <- matrix(NA, nrow = nInit+nYears, ncol = 4)
    winterM <- matrix(NA, nrow = nInit+nYears, ncol = 6)
    summerM <- matrix(NA, nrow = nInit+nYears, ncol = 18)
    ally <- summarize.oneyear(popo, popa)
    sptm <- NULL
    
    # Oceanic growth conditions:
    MeanNoiseSea <- c(rep(1,nInit),seq(1,CC.Sea,length=nYears))
    #mm$MeanNoiseSea <- MeanNoiseSea
    
    ## Define fishing rates  
    if (fisheries) {
      if(stage){
        rates <- cbind(
          grilses=c(rep(.15,nInit),rep(fishing_rate[1],nYears))
          ,msw=c(rep(.15,nInit),rep(fishing_rate[2],nYears))
        )         
      } else {
        rates <- cbind(
          Small=c(rep(.15,nInit),rep(fishing_rate[1],nYears))
          ,Med=c(rep(.15,nInit),rep(fishing_rate[2],nYears))
          ,Big=c(rep(.15,nInit),rep(fishing_rate[3],nYears))
        )
      }
    }
    
    pb   <- txtProgressBar(1, nYears+nInit, style=3) # initilazing progress bar
    for (y in 1:(nYears+nInit)) {
      #cat("Year: ",y,"of ",nYears, "\n")
      setTxtProgressBar(pb, y) # progress bar
      
      # Oceanic growth conditions:
      def$envParam[1] <- MeanNoiseSea[y]
      setup_environment_parameters(def$envParam)
      
      ptm <- proc.time()
      spring()
      summer()
      popo <- observe() # state BEFORE fisheries
      if (fisheries) {
        fishing(rates[y,])
      }
      # popo <- observe() # state AFTER fisheries        
      if (returning || success) {
        results <- rbind(results, popo)
      }
      ratios[y, ] <- unlist(proportions.population(popo))
      summerM[y, ] <- unlist(important.indicator.summer.population(popo))
      
      autumn()
      winter()
      popa <- observe() 
      if (returning || success) {
        results <- rbind(results, popa)
      }
      winterM[y, ] <- unlist(important.indicator.winter.population(popa))
      ally <- append.oneyear(popo, popa, ally)
      sptm <- rbind(sptm, proc.time() - ptm)
    }
    if (plotting) {
      op <- par(mfrow = c(2, 2))
      plot_proportions_population(ratios, window = window)
      plot_winterM(winterM, window = window)
      plot_summerM(summerM, window = window)
      plotevolution(ally, window = window)
      par(mfrow = c(2, 1))
      if (success) {
        newwindow(window)
        suc <- temporal_analyse_origins(results, 1:nYears, 
                                        plotting = plotting, titles = "Strategy success through time")
      }
      newwindow(window)
      plot(ts(sptm[, 1]), main = "CPU time needed per year", 
           ylab = "seconds", xlab = "years", bty = "l", sub = paste("Total:", 
                                                                    round(sum(sptm[, 1]), 3)))
      lines(lowess(sptm[, 1]), col = 2, lty = 2)
      par(op)
    }
    if (returning) {
      return(list(results,mm))
      #return(results)
    }
    else {
      invisible(NULL)
    }
  }
