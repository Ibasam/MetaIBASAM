# S?rie d'abondances, calcul PE, synchronie 17.04.18

nom_annee=c(paste0("Annee_", seq(1,50,1)))
nom_pop=c(paste0("Pop",seq(1,16,1)))
nom_scenario=c(11,12,21,22,31,32)
nom=as.vector(c("COUESNON","LEFF","TRIEUX","JAUDY","LEGUER","YAR","DOURON","PENZE","ELORN",
                "AULNE","GOYEN","ODET","AVEN","LAITA","SCORFF","BLAVET"))


load("2_NbMoyen_Retours_Sc11.RData")

EMoysc$Pop1 #1 tableau par pop qui me donne les effectifs moyens sur les 30 simulations



##### I. S?rie d'abondance totale pour calcul PE et synchronie #####

##### 1. Pour le Couesnon #####
plot(EMoysc$Pop1[9,], main="S?rie d'abondance des retours dans le Couesnon", 
     cex.main=0.9, xlab="Ann?e", ylab="Abondance", xaxt="n", type="l")
axis(side=1, at=seq(1,50,2), labels = seq(1,50,2), cex.axis=0.9)

ecart=sd(EMoysc$Pop1[9,]) #?cart type autour de l'ensemble de la s?rie
moy=mean(EMoysc$Pop1[9,]) #moyenne de la s?rie d'abondance
cv=ecart/moy #CV de la s?rie d'abondance

abline(h=moy,col="orange")
polygon(x = c(0,50,50,0), y=c(moy+ecart,moy+ecart,moy-ecart,moy-ecart), 
        col=rgb(0,0,0,alpha=0.1), border=F)


##### 2. Pour toutes les populations #####
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/2_NbMoyen_Retours_Sc11.RData")
setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Output")
pdf(file = "Serie_Abondance_Sc11.pdf")
for (p in 1:16){
  ecart=sd(EMoysc[[p]][9,]) #?cart type autour de l'ensemble de la s?rie
  moy=mean(EMoysc[[p]][9,]) #moyenne de la s?rie d'abondance
  cv=ecart/moy                #CV de la s?rie d'abondance
  
  plot(EMoysc[[p]][9,], type="l", main=paste0("S?rie d'abondance retours dans le ",nom[p]),
       xlab="Ann?e", ylab="Abondance", xaxt="n", ylim=c(moy*0.80, moy*1.20), cex.main=0.9, lwd=2)
  axis(side=1, at=seq(1,50,5), labels = colnames(seq(1, 50, 5)), cex.axis=0.9)
  
  mtext(paste0("moyenne = ",moy, ", ?cart type = ",round(ecart, digits=3)," et CV = ",round(cv, digits=3)))
  
  abline(h=moy,col="orange", lwd=2)
  polygon(x = c(0,50,50,0), y=c(moy+ecart,moy+ecart,moy-ecart,moy-ecart), 
          col=rgb(0,0,0,alpha=0.1), border=F)}


##### 3. Pour la m?tapopulation #####
ecart=sd(EMoysc$Metapop[9,]) #?cart type autour de l'ensemble de la s?rie
moy=mean(EMoysc$Metapop[9,]) #moyenne de la s?rie d'abondance
cv=ecart/moy                   #CV de la s?rie d'abondance

plot(EMoysc$Metapop[9,], type="l", main="S?rie d'abondance retours dans la METAPOPULATION",
     xlab="Ann?e", ylab="Abondance", xaxt="n", ylim=c(moy*0.80, moy*1.20), cex.main=0.9, lwd=2)
axis(side=1, at=seq(1,50,5), labels = colnames(seq(1, 50, 5)), cex.axis=0.9)
#lines(Metapopsc11[7,], col="red", lwd=2) #repr?sentation s?rie 1SW
#lines(Metapopsc11[8,], col="blue",lwd=2) #repr?sentation s?rie MSW

mtext(paste0("moyenne = ",moy, ", ?cart type = ",round(ecart, digits=3)," et CV = ",round(cv, digits=3)))

abline(h=moy,col="orange",lwd=2)
polygon(x = c(0,50,50,0), y=c(moy+ecart,moy+ecart,moy-ecart,moy-ecart), 
        col=rgb(0,0,0,alpha=0.1), border=F)




##### III. Calcul de l'effet portfolio et de l'indice de synchronie #####
library(ecofolio)
help(package = "ecofolio") # il me faut une matrice avec en ligne le temps et en colonne les pop

matPE=matrix(data=NA, nrow=50, ncol=16)
colnames(matPE)=nom
rownames(matPE)=nom_annee
for (p in 1:16){
  matPE[,p]=EMoysc[[p]][9,]}
matPE

pe_mv(matPE, type="linear", ci=T) #1.329
# m?tapop 1.3 fois plus stable que si c'?tait une pop isol?e mais ici PAS DE CONNECTIVITE
# effet portfolio d? ? autre chose ici? 
synchrony(matPE) #0.2635 ?a c'est bien :) car 1 synchrone, 0 asynchrone

plot_mv(as.data.frame(matPE), show="linear", main="Calcul de l'effet portfolio, m?thode mean-variance",
        xlab = "Mean en ?chelle log", ylab = "Variance en ?chelle log", lwd=2, cex.main=0.9)
mtext(paste0("PE = ", round(pe_mv(matPE, type="linear", ci=T)$pe, digits=3),
             " & synchronie = ", round(synchrony(matPE), digits=3)), side=3)

dev.off()



##### IV. Pour les autres sc?nario #####
for (sce in 1:6){
  load(paste0("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/2_NbMoyen_Retours_Sc",nom_scenario[sce],".RData"))
  setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses")
  pdf(file = paste0("Serie_AbondanceBIS_Sc",nom_scenario[sce],".pdf"))
  
  #pour les pop
  for (p in 1:16){
    ecart=sd(EMoysc[[p]][9,]) #?cart type autour de l'ensemble de la s?rie
    moy=mean(EMoysc[[p]][9,]) #moyenne de la s?rie d'abondance
    cv=ecart/moy                #CV de la s?rie d'abondance
    
    plot(EMoysc[[p]][9,], type="l", main=paste0("S?rie d'abondance retours dans le ",nom[p]),
         xlab="Ann?e", ylab="Abondance", xaxt="n", ylim=c(moy*0.8, moy*1.2), cex.main=0.9, lwd=2)
    #mettre *0.8 et *1.2 qd c'est pour les scenarii sans CC
    axis(side=1, at=seq(1,50,5), labels = colnames(seq(1, 50, 5)), cex.axis=0.9)
    
    mtext(paste0("moyenne = ",moy, ", ?cart type = ",round(ecart, digits=3)," et CV = ",round(cv, digits=3)))
    
    abline(h=moy,col="orange", lwd=2)
    polygon(x = c(0,50,50,0), y=c(moy+ecart,moy+ecart,moy-ecart,moy-ecart), 
            col=rgb(0,0,0,alpha=0.1), border=F)}
  
  
  #pour la m?tapopulation
  ecart=sd(EMoysc$Metapop[9,]) #?cart type autour de l'ensemble de la s?rie
  moy=mean(EMoysc$Metapop[9,]) #moyenne de la s?rie d'abondance
  cv=ecart/moy                   #CV de la s?rie d'abondance
  
  plot(EMoysc$Metapop[9,], type="l", main="S?rie d'abondance retours dans la METAPOPULATION",
       xlab="Ann?e", ylab="Abondance", xaxt="n", ylim=c(moy*0.5, moy*1.5), cex.main=0.9, lwd=2)
  axis(side=1, at=seq(1,50,5), labels = colnames(seq(1, 50, 5)), cex.axis=0.9)
  #lines(Metapopsc11[7,], col="red", lwd=2) #repr?sentation s?rie 1SW
  #lines(Metapopsc11[8,], col="blue",lwd=2) #repr?sentation s?rie MSW
  
  mtext(paste0("moyenne = ",moy, ", ?cart type = ",round(ecart, digits=3)," et CV = ",round(cv, digits=3)))
  
  abline(h=moy,col="orange",lwd=2)
  polygon(x = c(0,50,50,0), y=c(moy+ecart,moy+ecart,moy-ecart,moy-ecart), 
          col=rgb(0,0,0,alpha=0.1), border=F)

  
  #effet portfolio et de l'indice de synchronie
  matPE=matrix(data=NA, nrow=50, ncol=16)
  colnames(matPE)=nom
  rownames(matPE)=nom_annee
  for (p in 1:16){
    matPE[,p]=EMoysc[[p]][9,]}
  matPE
  
  pe_mv(matPE, type="linear", ci=T) #1.329
  synchrony(matPE) #0.2635 ?a c'est bien :) car 1 synchrone, 0 asynchrone
  
  plot_mv(as.data.frame(matPE), show="linear", main="Calcul de l'effet portfolio, m?thode mean-variance",
          xlab = "Mean en ?chelle log", ylab = "Variance en ?chelle log", lwd=2, cex.main=0.9)
  mtext(paste0("PE = ", round(pe_mv(matPE, type="linear", ci=T)$pe, digits=3),
               " & synchronie = ", round(synchrony(matPE), digits=3)), side=3)
  
  dev.off()
}



##### V. Calcul de la croissance de la m?tapop #####
alpha=vector(mode = "numeric", length = 49)
for (i in 2:50){
  alpha[i-1]=EMoysc$Metapop[9,i]/EMoysc$Metapop[9,i-1]}
mean(alpha) #tx croissance = 1.0018
sd(alpha) #?cart type 0.0159




##### VI. Stockage des infos PE, synchrony et taux de croissance #####
load("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/0_Resume.RData")
PE=NA
InfPE=NA
SupPE=NA
Synchrony=NA
Taux_croiss=NA
Sd_taux_croiss=NA
Resume=cbind(Resume, PE, InfPE, SupPE, Synchrony, Taux_croiss, Sd_taux_croiss)

for (sce in 1:6){
  load(paste0("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData/2_NbMoyen_Retours_Sc",nom_scenario[sce],".RData"))
  
  #calcul matrice pour PE 
  matPE=matrix(data=NA, nrow=50, ncol=16)
  for (p in 1:16){
    matPE[,p]=EMoysc[[p]][9,]}
  
  #calcul PE
  Resume[sce+1,2]=pe_mv(matPE, type="linear", ci=T)$pe
  Resume[sce+1,3]=pe_mv(matPE, type="linear", ci=T)$ci[1]
  Resume[sce+1,4]=pe_mv(matPE, type="linear", ci=T)$ci[2]
  
  #calcul synchronie
  Resume[sce+1,5]=synchrony(matPE)
  
  #calcul croissance m?tapop
  alpha=vector(mode = "numeric", length = 49)
  for (i in 2:50){
    alpha[i-1]=EMoysc$Metapop[9,i]/EMoysc$Metapop[9,i-1]}
  Resume[sce+1,6]=mean(alpha) 
  Resume[sce+1,7]=sd(alpha)
  }
Resume


# r?cup?ration des donn?es empiriques sur ces variables avant enregistrement 
Resume[1,2]=0.9440814
Resume[1,3]=0.6321228
Resume[1,4]=1.4099946
Resume[1,5]=0.610001
Resume[1,6]=1.046805
Resume[1,7]=0.397362

setwd("~/Master_S4_Stage/Phase3_Simulation_Analyses/Scripts&RData")
save(Resume, file="03_Resume.RData")
