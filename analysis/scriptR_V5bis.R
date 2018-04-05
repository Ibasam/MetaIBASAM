library(metaIbasam) #loading Ibasam R script


#setwd(paste("REPbase","scenario","/",sep=""))
#Sys.setlocale('LC_ALL','C') 
#source(paste("scriptIBASAM","vIBASAM","iSIMUL","_TMP.R",sep=""))
#source(paste("demoIbasam","iSIMUL","_TMP.R",sep=""))
source("demoIbasam_V3bis.R")


##### 1. Aire production #####
# vecteur Aire estimée en 2015 dans cet ordre, unité m²
# Couesnon, Leff, Trieux, Jaudy, Leguer, Yar, Douron, Penze, 
# Elorn, Aulne, Goyen, Odet, Aven, Laïta, Scorff, Blavet
aireScript=c(110794, 72305, 213733, 47561, 197283, 37104, 95451, 106753, 
             164699, 252659, 53603, 249049, 142686, 669028, 229027, 393985)


##### 2. Stock-recrutement #####
# vecteur Rmax dans le même ordre, on prend les estimations médianes, unité nbr tacons0+/100m²
#RmaxScript=c(12.41, 27.32, 16.28, 31.95, 25.30, 15.94, 25.98, 40.51, 
#             29.17, 4.319, 36.23, 31.48, 20.26, 23.51, 15.13, 14.62)

# vecteur alpha dans le même ordre, on prend les estimations médianes
#alphaScript=c(0.03140, 0.06913, 0.04119, 0.08084, 0.06401, 0.04034, 0.06575, 0.1025,
#              0.07381, 0.01093, 0.09168, 0.07965, 0.05126, 0.05949, 0.03828, 0.03698)

M=c(0.82032, 1.8058, 1.0760, 2.1118, 1.6723, 1.0537, 1.7174, 2.6776,
    1.9280, 0.28545, 2.3948, 2.0805, 1.3391, 1.5540, 1.0000, 0.96606)
# choix de travailler avec les facteurs multiplicatifs par rapport au Scorff


##### 3. Matrice de connectivite #####
# première matrice h=1, deuxième matrice h=0.942, troisième matrice h=0.80
load("Matrices_Laplace_AireLog.RData")
pstrayScript=connect[[scenarioConnect]]

# vérification sous R : si on crée un vecteur et qu'on dit dans une fonction d'aller
# chercher une valeur de ce vecteur, cela fonctionne
# dans chaque scriptR_pop, on a aireScript[pop] avec le numéro de la pop
# pour chaque lancement de ces scripts, R va chercher la pop-ième valeur du vecteur aireScript
# idem pour Rmax, alpha et pstray
# Si on fait partir 16 pop mais qu'on a pas 16 lignes dans pstray, il dit qu'il y a un problème 


##### 4. Changement climatique #####
# scenario 1 c'est absence de CC (temp=0, amp=1, sea=1)
# scenario 2 c'est présence de CC (temp=3, amp=1.25, sea=0.75)
# liste des scénarii de CC testé, ordre tempCC/ampCC/seaCC
env=list(c(0,1,1), c(3,1.25,0.75)) 
# je récupère le scenario dans la liste puis je vais chercher chaque paramètre
tempCC=env[[scenarioEnvi]][1] 
ampCC=env[[scenarioEnvi]][2]
seaCC=env[[scenarioEnvi]][3]



##### 5. Simulations #####
RES <- list()
for (i in 32:98){ #à rechanger pour les autres scenarii 73:100 ou 1:nSimu (normalement)
  RES <- demoIbasam_V3(nInit=init,nYears=years # Nb years simulated
                       , npop = Npop # Number of popualtions
                       , Pop.o = popo # Population of origin
                       , rPROP = rPROPScript # Proportion de la taille de pop
                       , CC.Temp=tempCC # Water Temperature increase (keep constant if 0)
                       , CC.Amp=ampCC # Flow amplitude increase (keep constant if 1)
                       , CC.Sea=seaCC #.75 # decreasing growth condition at sea (seqeunce from 1 to .75; keep constant if 1)
                       , fisheries=fish.state, stage = fish.stage, fishing_rate=c(.15,.15,.15)
                       , returning=TRUE # if TRUE, return R object contaning all data (very long)
                       , plotting=TRUE,window=FALSE,success=FALSE,empty=TRUE
                       , aire=aireScript[popo]
                       , Rmax=10*M[popo]     #Rmax reference Scorff * coeff multiplicateur
                       , alpha=0.1*M[popo]   #alpha reference Scorff * coeff multiplicateur
                       , pstray=pstrayScript[popo,]  # Dispersal probability #ligne popo
  )
  RES <- RES[RES$year>init,]
  save(RES,file=paste0("tmp/RESsimul_",popo,".RData"))
  save(RES,file=paste0("results/RESsimul_",popo,"_iSIMUL","-",i,".RData"))
}






