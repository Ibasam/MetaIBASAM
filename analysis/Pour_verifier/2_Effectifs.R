# Obtention des effectifs retours sur 50 ans, 16.04.18 #

##### 0. Nommer #####
nom_annee=c(paste0("Annee_", seq(1,50,1)))
nom_pop=c(paste0("Pop",seq(1,16,1)))
nom_simu=c(paste0("Simu",seq(1,30,1)))
nom_scenario=c(11,12,21,22,31,32)


##### I. Travail sur la pop 1 sur la simulation 1 sur le scenario 11 #####

##### 1. Chargement des données #####
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/1_Retours_Sc11.RData")
table(as.factor(retours_pop$Pop1$Simu)) #bien


##### 2. Effectifs pour simulation 1 sur pop 1 #####
effectif=matrix(data=NA, ncol=50, nrow=9)
rownames(effectif)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
colnames(effectif)=nom_annee
data=retours_pop$Pop1[which(retours_pop$Pop1$Simu==1),]
for (i in 16:65){
  effectif[1,i-15]=dim(data[which(data$Female==1 & data$AgeSea<2 & data$year==i),])[1]
  effectif[2,i-15]=dim(data[which(data$Female==1 & data$AgeSea>=2 & data$year==i),])[1]
  effectif[3,i-15]=dim(data[which(data$Female==0 & data$AgeSea<2 & data$year==i),])[1]
  effectif[4,i-15]=dim(data[which(data$Female==0 & data$AgeSea>=2 & data$year==i),])[1]
  effectif[5,i-15]=dim(data[which(data$Female==1 & data$year==i),])[1]
  effectif[6,i-15]=dim(data[which(data$Female==0 & data$year==i),])[1]
  effectif[7,i-15]=dim(data[which(data$AgeSea<2 & data$year==i),])[1]
  effectif[8,i-15]=dim(data[which(data$AgeSea>=2 & data$year==i),])[1]
  effectif[9,i-15]=dim(data[which(data$year==i),])[1]
}
effectif
sum(effectif[9,]) #on retrouve les 4423 individus :)



##### II. Comptage des effectifs pour 3 simulations de la pop 1 #####
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/1_Retours_Sc11.RData")
Ep1sc11=list()
for (s in 1:3){ #essai avec 3 simul pour voir si ça marche
  data=retours_pop$Pop1[which(retours_pop$Pop1$Simu==s),]
  E=matrix(data=NA, ncol=50, nrow=9)
  rownames(E)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
  colnames(E)=nom_annee
  
  for (i in 16:65){
    E[1,i-15]=dim(data[which(data$Female==1 & data$AgeSea<2 & data$year==i),])[1]
    E[2,i-15]=dim(data[which(data$Female==1 & data$AgeSea>=2 & data$year==i),])[1]
    E[3,i-15]=dim(data[which(data$Female==0 & data$AgeSea<2 & data$year==i),])[1]
    E[4,i-15]=dim(data[which(data$Female==0 & data$AgeSea>=2 & data$year==i),])[1]
    E[5,i-15]=dim(data[which(data$Female==1 & data$year==i),])[1]
    E[6,i-15]=dim(data[which(data$Female==0 & data$year==i),])[1]
    E[7,i-15]=dim(data[which(data$AgeSea<2 & data$year==i),])[1]
    E[8,i-15]=dim(data[which(data$AgeSea>=2 & data$year==i),])[1]
    E[9,i-15]=dim(data[which(data$year==i),])[1]
  }
  Ep1sc11[[s]]=E #je stocke le tableau effectif dans la liste 
}
names(Ep1sc11)=c(paste0("Simu",seq(1,3,1)))

sum(Ep1sc11$Simu1[9,]) #on a bien les 4423 individus



##### III. Toutes les pop du scenario 11 ######
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/1_Retours_Sc11.RData")
Esc11=list()
Ep=list()
for (p in 1:16){
  for (s in 1:30){
    E=matrix(data=NA, ncol=50, nrow=9)
    rownames(E)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
    colnames(E)=nom_annee
    data=retours_pop[[p]][which(retours_pop[[p]]$Simu==s),]
    
    for (i in 16:65){
      E[1,i-15]=dim(data[which(data$Female==1 & data$AgeSea<2 & data$year==i),])[1]
      E[2,i-15]=dim(data[which(data$Female==1 & data$AgeSea>=2 & data$year==i),])[1]
      E[3,i-15]=dim(data[which(data$Female==0 & data$AgeSea<2 & data$year==i),])[1]
      E[4,i-15]=dim(data[which(data$Female==0 & data$AgeSea>=2 & data$year==i),])[1]
      E[5,i-15]=dim(data[which(data$Female==1 & data$year==i),])[1]
      E[6,i-15]=dim(data[which(data$Female==0 & data$year==i),])[1]
      E[7,i-15]=dim(data[which(data$AgeSea<2 & data$year==i),])[1]
      E[8,i-15]=dim(data[which(data$AgeSea>=2 & data$year==i),])[1]
      E[9,i-15]=dim(data[which(data$year==i),])[1]
    }
    Ep[[s]]=E #je stocke le tableau effectif pour chaque simulation s
  }
  Esc11[[p]]=Ep #je stocke la liste effectif des 30 simulations pour chaque population p
  names(Esc11[[p]])=nom_simu[1:30] #on nomme les 30 simulations
}
names(Esc11)=nom_pop[1:16] #on nomme les 16 populations

#setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
#save(Esc11, file="2_Nb_Retours_Sc11.RData") 
#je sauvegarde le calcul des effectifs pour le scenario 11




##### IV. Effectifs moyens des retours #####

##### 1. Chargement des données #####
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/2_Nb_Retours_Sc11.RData")
#Esc11, liste pour chaque pop [[p]], il y a les 30 simulations [[s]]


##### 2. Pour la population 1 #####
EMoyp1sc11=matrix(data=NA, ncol=50, nrow=9)
rownames(EMoyp1sc11)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
colnames(EMoyp1sc11)=nom_annee

for (l in 1:9){
  effA=vector(mode="numeric", length=50) #je crée effA, va stocker l'effectif moyen pour chaque année
  for (a in 1:50){
    eff=vector(mode="numeric", length = 30) #pour chaque simulation, je stocke la valeur
    for (s in 1:30){
      eff[s]=Esc11$Pop1[[s]][l,a] #je récupère les valeurs effectifs sur mon année des 30 simul
    }
    effA[a]=mean(eff) #je fais la moyenne de l'effectif de l'année sur les 30 simul
  }
  EMoyp1sc11[l,]=round(effA, digits=0) #on le fait pour chaque ligne du tableau
}
EMoyp1sc11 #donne effectif moyen pour la pop 1 au scénario 11


##### 3. Pour toutes les populations #####
EMoysc11=list()
for (p in 1:16){
  Epsc11moy=matrix(data=NA, ncol=50, nrow=9)
  rownames(Epsc11moy)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
  colnames(Epsc11moy)=nom_annee #crée matrice effectif moyen de la pop p
  
  for (l in 1:9){
    effA=vector(mode="numeric", length=50)
    for (a in 1:50){
      eff=vector(mode="numeric", length = 30)
      for (s in 1:30){
        eff[s]=Esc11[[p]][[s]][l,a]
      }
      effA[a]=mean(eff)
    }
    Epsc11moy[l,]=round(effA, digits=0)
  }
  EMoysc11[[p]]=Epsc11moy
}
names(EMoysc11)=nom_pop[1:16]
EMoysc11 #liste pour chaque pop, j'obtiens le tableau des effectifs moyen


##### 4. Pour la métapopulation #####
#somme des effectifs moyen de toutes les pop pour chaque année
Metapopsc11=EMoysc11[[1]]+EMoysc11[[2]]+EMoysc11[[3]]+EMoysc11[[4]]+EMoysc11[[5]]+EMoysc11[[6]]+
  EMoysc11[[7]]+EMoysc11[[8]]+EMoysc11[[9]]+EMoysc11[[10]]+EMoysc11[[11]]+EMoysc11[[12]]+EMoysc11[[13]]+
  EMoysc11[[14]]+EMoysc11[[15]]+EMoysc11[[16]]
EMoysc11[[17]]=Metapopsc11
names(EMoysc11)[17]=c("Metapop")


setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
save(EMoysc11, file="2_NbMoyen_Retours_Sc11.RData") 




##### V. Pour les scenarii restants #####
# SUR MACHINE GENET

for (sce in 2:6){
  load(paste0("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/1_Retours_Sc",nom_scenario[sce],".RData"))
  Esc=list()
  Ep=list()
  for (p in 1:16){
    for (s in 1:30){
      E=matrix(data=NA, ncol=50, nrow=9)
      rownames(E)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
      colnames(E)=nom_annee
      data=retours_pop[[p]][which(retours_pop[[p]]$Simu==s),]
      
      for (i in 16:65){
        E[1,i-15]=dim(data[which(data$Female==1 & data$AgeSea<2 & data$year==i),])[1]
        E[2,i-15]=dim(data[which(data$Female==1 & data$AgeSea>=2 & data$year==i),])[1]
        E[3,i-15]=dim(data[which(data$Female==0 & data$AgeSea<2 & data$year==i),])[1]
        E[4,i-15]=dim(data[which(data$Female==0 & data$AgeSea>=2 & data$year==i),])[1]
        E[5,i-15]=dim(data[which(data$Female==1 & data$year==i),])[1]
        E[6,i-15]=dim(data[which(data$Female==0 & data$year==i),])[1]
        E[7,i-15]=dim(data[which(data$AgeSea<2 & data$year==i),])[1]
        E[8,i-15]=dim(data[which(data$AgeSea>=2 & data$year==i),])[1]
        E[9,i-15]=dim(data[which(data$year==i),])[1]
      }
      Ep[[s]]=E #je stocke le tableau effectif pour chaque simulation s
    }
    Esc[[p]]=Ep #je stocke la liste effectif des 30 simulations pour chaque population p
    names(Esc[[p]])=nom_simu[1:30] #on nomme les 30 simulations
  }
  names(Esc)=nom_pop[1:16] #on nomme les 16 populations
  

  # Effectifs moyens pour toutes les populations
  EMoysc=list()
  for (p in 1:16){
    Epscmoy=matrix(data=NA, ncol=50, nrow=9)
    rownames(Epscmoy)=c("1SW_F", "MSW_F", "1SW_M", "MSW_M", "F", "M", "1SW", "MSW", "Total")
    colnames(Epscmoy)=nom_annee #crée matrice effectif moyen de la pop p
    
    for (l in 1:9){
      effA=vector(mode="numeric", length=50)
      for (a in 1:50){
        eff=vector(mode="numeric", length = 30)
        for (s in 1:30){
          eff[s]=Esc[[p]][[s]][l,a]
        }
        effA[a]=mean(eff)
      }
      Epscmoy[l,]=round(effA, digits=0)
    }
    EMoysc[[p]]=Epscmoy
  }
  names(EMoysc)=nom_pop[1:16]
  EMoysc #liste pour chaque pop, j'obtiens le tableau des effectifs moyen
  
  
  #Pour la métapopulation
  #somme des effectifs moyen de toutes les pop pour chaque année
  Metapopsc=EMoysc[[1]]+EMoysc[[2]]+EMoysc[[3]]+EMoysc[[4]]+EMoysc[[5]]+EMoysc[[6]]+
    EMoysc[[7]]+EMoysc[[8]]+EMoysc[[9]]+EMoysc[[10]]+EMoysc[[11]]+EMoysc[[12]]+EMoysc[[13]]+
    EMoysc[[14]]+EMoysc[[15]]+EMoysc[[16]]
  EMoysc[[17]]=Metapopsc
  names(EMoysc)[17]=c("Metapop")
  
  
  setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
  save(EMoysc, file=paste0("2_NbMoyen_Retours_Sc",nom_scenario[sce],".RData"))
  
}