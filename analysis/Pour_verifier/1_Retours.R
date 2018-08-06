# Tableau des individus retours 13.04.18 

nom_annee=c(paste0("Annee_", seq(1,50,1)))
nom_pop=c(paste0("Pop",seq(1,16,1)))
nom_simu=c(paste0("Simu",seq(1,30,1)))
nom_scenario=c(11,12,21,22,31,32)

##### I. Obtenir les individus qui rentrent de mer #####

##### 1. Essai pour 1 pop et 1 simul #####
load("G:/30Simul/Scenario11/RES_Pop-1_Simu-1.RData")
retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
Simu=1
retours_bis=cbind(retours, Simu)


##### 2. 2 pop et 5 simulations #####
retours_pop=list()
for (p in 1:2){
  load(paste0("G:/30Simul/Scenario11/RES_Pop-",1,"_Simu-1.RData"))
  retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
  Simu=1
  retours_bis=cbind(retours, Simu)
  retours_ter=retours_bis
  for (s in 2:5){
    load(paste0("G:/30Simul/Scenario11/RES_Pop-",1,"_Simu-",s,".RData"))
    retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
    Simu=s
    retours_bis=cbind(retours, Simu)
    retours_ter=rbind(retours_ter, retours_bis)
  }
  retours_pop[[p]]=retours_ter
}
names(retours_pop)=nom_pop[1:2]

table(as.factor(retours_pop[[1]]$Simu)) #permet de vérifier que ça fait bien le travail ;)


##### 3. Pour 2 scénarii, 2 pop et 3 simulations #####

for (sce in 1:2){
  retours_pop=list()
  for (p in 1:2){
    load(paste0("G:/30Simul/Scenario",nom_scenario[sce],"/RES_Pop-",p,"_Simu-1.RData"))
    retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
    Simu=1
    retours_bis=cbind(retours, Simu)
    retours_ter=retours_bis
    for (s in 2:3){
      load(paste0("G:/30Simul/Scenario",nom_scenario[sce],"/RES_Pop-",p,"_Simu-",s,".RData"))
      retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
      Simu=s
      retours_bis=cbind(retours, Simu)
      retours_ter=rbind(retours_ter, retours_bis)
    }
    retours_pop[[p]]=retours_ter
  }
  names(retours_pop)=nom_pop[1:2]
  
  setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
  save(retours_pop, file=paste0("1_Retours_Sc", nom_scenario[sce],".RData"))
}

  
  

##### III. Sur 16 pop, 30 simulations, tous les scénarii #####
# sur MACHINE A DISTANCE GENET 
for (sce in 1:6){
  retours_pop=list()
  for (p in 1:16){
    load(paste0("G:/30Simul/Scenario",nom_scenario[sce],"/RES_Pop-",p,"_Simu-1.RData"))
    retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
    Simu=1
    retours_bis=cbind(retours, Simu)
    retours_ter=retours_bis
    for (s in 2:30){
      load(paste0("G:/30Simul/Scenario",nom_scenario[sce],"/RES_Pop-",p,"_Simu-",s,".RData"))
      retours=RES[which(RES$Returns>=1 & RES$Atsea==0),]
      Simu=s
      retours_bis=cbind(retours, Simu)
      retours_ter=rbind(retours_ter, retours_bis)
    }
    retours_pop[[p]]=retours_ter
  }
  names(retours_pop)=nom_pop[1:16]
  
  setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
  save(retours_pop, file=paste0("1_Retours_Sc", nom_scenario[sce],".RData"))
}