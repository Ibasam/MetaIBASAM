demoIbasam <-
  function (nInit #nbr d'année pour faire burn-in
            ,nYears #nbr d'année pour faire simulation
            , npop # Number of populations
            , Pop.o # Population of origin
            , rPROP
            , CC.Temp # effects of climate change in freshwater on temperature
            , CC.Amp # effects of climate change in freshwater on flow
            , CC.Sea # effects of climate change at sea
            , fisheries = TRUE, stage = TRUE, fishing_rate=c(.15, .15, .15) ## fishing effects
            , plotting = TRUE, window = FALSE, returning = TRUE, success = FALSE, empty = TRUE
            , aire 
            , Rmax
            , alpha
            , pstray # Dispersal probability
  ) 
  {
    
    #Initialization & Preparation:
    empty()
    def <- defaultParameters()
    
    #### PARAMETERS ####
    # If maxRIV <0 or maxSEA <0, NO trade-offs
    kappaRIV=0.001
    kappaSEA=0.001
    
    heriRIV=0.14
    heriSEA=0.14
    
    maxSEA=50
    sigSEA=100
    
    maxRIV=5
    sigRIV=3.7
    
    SP0=0.9841606*1.005
    SP1=0.9914398*1.005
    SP1S=0.9967923*1.002
    SP1M=0.9863295*1.002
    SPnM=0.9911798*1.002
    SPn=0.99775*1.002
    
    #les paramètres qu'il faut changer 
    #aire de production * proportion de l'aire qu'on prend rPROP
    def$envParam[9] <- aire*rPROP
    #Rmax
    def$colParam[41]=aire*rPROP*Rmax
    #alpha
    def$colParam[40]=alpha
    
    #on retrouve l'aire et la proportion d'aire un peu partout, alors il faut aussi les changer
    #c'est en fait ce qui a été fait ici
    def$gParam[1] <- round(def$envParam[9]*8*0.15)
    def$parrParam[1] <- round(def$gParam[1]*0.011)
    def$smoltsParam[1] <- round(def$gParam[1]*0.03)
    def$grilseParam[1] <- round(def$gParam[1]*0.003)
    def$mswParam[1] <- round(def$gParam[1]*0.0005)
    
    #pourquoi on décide Rmax=2? en plus ce n'est pas la bonne unité, Rmax en tacons0+/100m²
    #def$colParam[41] <- def$envParam[9]*2   #2 oeufs / m2
    
    
    #19:24 = forme du compromis (maxRIV,sigRIV,kappaRIV,maxSEA,sigSEA,kappaSEA)
    def$colParam[19:24] <- c(maxRIV,sigRIV,kappaRIV,maxSEA,sigSEA,kappaSEA)
    #63 = h?ritabilit? de la croissance en rivi?re
    def$colParam[63] <- heriRIV
    #67 = h?ritabilit? de la croissance en mer
    def$colParam[67] <- heriSEA
    #survies
    def$colParam[13:18] <- c(SP0,SP1,SP1S,SP1M,SPnM,SPn) #daily survival prob parr 0 to 0.5; daily survival prob parr 0.5 to 1.0; daily survival prob smolts 0.5 to run; daily survival prob parr mature 0.5 to 1.0; daily survival prob parr mature n.5 to n+1; daily survival prob parr any other situations
    
    #### ENVIRONMENT ####
    mm <- river_climate_model(nInit + nYears + 1, CC.Temp, CC.Amp)
    Reset_environment()
    Prepare_environment_vectors(mm$temperatures, mm$logrelflow)
    setup_environment_parameters(def$envParam)
    setup_collection_parameters(def$colParam)
    
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
    
    #### INITIALIZING POPULATION ####
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
    
    
    ## RUN
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
      
      #### FISHING ####
      #popo <- observe() # state BEFORE fisheries
      if (fisheries) {
        fishing(rates[y,])
      }
      
      popo <- observe() # state AFTER fisheries        
      if (returning || success) {
        results <- rbind(results, popo)
      }
      
      ratios[y, ] <- unlist(proportions.population(popo))
      summerM[y, ] <- unlist(important.indicator.summer.population(popo))
      
      autumn()
      winter()
      
      #### STRAYING ####
      #emmigrants("nom de fichier", straying_rates for 1SW & MSW)
      #pause("nom de fichier")
      #immigrants("nom de fichier")
      # emmigrants(paste0("tmp/Pop_",Pop,"_",y,".txt"),c(0.1,0.1))
      # popb <- observe()
      # pause(paste0("tmp/Pop_",Pop_im,"_",y,".txt")) # R script to pause the execution of Ibasam until immigrant file (e.g. mig_AtoB) is created in a specific folder
      # immigrants(paste0("tmp/Pop_",Pop_im,"_",y,".txt"))
      # popc <- observe()
      
      for (Pop.e in 1:npop){
        # Pop.o: population of origin
        # Pop.e: emigrate to population Pop.e
        if(Pop.e == Pop.o) { 
          next 
        } else {
          emfile <- paste("tmp/Mig_",Pop.o,"-",Pop.e,"_",y,".txt",sep="") 
          #i c'est l'indice pour nSimu définit dans scriptR 
          #y c'est le numéro de l'année en incluant celles de burnin 
          #pstray <- c(0.1,0.1)
          emmigrants(emfile, pstray[Pop.e])
        } # end if
      } # end Pop.e
      
      #pope <- observe()
      
      for (Pop.i in 1:npop){
        # Pop.o: population of origin
        # Pop.i: immigrate from population Pop.i
        if(Pop.i == Pop.o) { 
          next 
        } else {
          imfile <- paste("tmp/Mig_",Pop.i,"-",Pop.o,"_",y,".txt",sep="")
          pause(imfile) # R script to pause the execution of Ibasam until immigrant file (e.g. mig_AtoB) is created in a specific folder
          immigrants(imfile)
        } # end if
      } # end Pop.i
      
      # popi <- observe()
      # if (returning || success) {
      #   results <- rbind(results, pope)
      # }
      
      
      popa <- observe() 
      if (returning || success) {
        results <- rbind(results, popa)
      }
      
      
      winterM[y, ] <- unlist(important.indicator.winter.population(popa))
      ally <- append.oneyear(popo, popa, ally)
      sptm <- rbind(sptm, proc.time() - ptm)
    }
    
    #### PLOT ####
    if (plotting) {
      pdf(paste('tmp/Res_Pop',Pop.o,'.pdf',sep=''))
      # ecrase à chaque fois l'ancier pdf, ne garde que celui de la dernière simulation
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
      dev.off()
    }
    if (returning) {
      #return(list(results,mm))
      return(results)
    }
    else {
      invisible(NULL)
    }
  }
