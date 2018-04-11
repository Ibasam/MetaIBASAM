### Matrice de connectivité 12.02.18 ##
setwd("~/Master_S4_Stage/Phase2_Matrice_connectivité/Data")

##### I. Rappel des données ####
aire=read.table("Aire2015.txt", h=T)
nom=as.vector(c("COUESNON","LEFF","TRIEUX","JAUDY","LEGUER","YAR","DOURON","PENZE","ELORN",
                "AULNE","GOYEN","ODET","AVEN","LAITA","SCORFF","BLAVET"))
couleur=c("darkmagenta","chartreuse","red","skyblue","peru","lightslateblue","orange","black", 
          "darkgreen", "salmon4","coral", "gold","gray62","blue","deeppink","seagreen1")




##### II. Proportions d'aire pour avoir une proba selon l'aire #####
# + aire forte, + ratio fort, + proba forte
ratio_aire=matrix(data=NA, nrow=1, ncol= 16)
colnames(ratio_aire)=nom
for (i in 1:16){
  ratio_aire[1,i]=aire[i,1]/sum(aire)}
# j'obtiens g(mobile)




##### III. Réglage des paramètres a et b avec distances prédites pour le kernel de localisation#####

##### 1. Modèle kernel de dispersion de localisation #####
Kexp=function(a, b, distance){
  b/(2*pi*a*a*gamma(2/b))*exp((-distance^b)/(a^b))}

##### 2. Voir effet b #####
dist=seq(from=5, to= 370, by=1)
plot(dist, Kexp(1, 1.5, dist), type="l")
lines(dist, Kexp(1, 1, dist), col="green")
lines(dist, Kexp(1, 0.7, dist), col="blue")
lines(dist, Kexp(1, 0.5, dist), col="red")
lines(dist, Kexp(1, 0.4, dist), col="orange")
lines(dist, Kexp(1, 0.35, dist), col="cyan")
# plus b est petit, plus les queues de distribution sont épaisses

##### 3. Voir effet a #####
dist=seq(from=5, to= 370, by=1)
plot(dist, Kexp(0.1, 0.4, dist), type="l", xlim=c(0, 100))
lines(dist, Kexp(0.2, 0.4, dist), col="red")
lines(dist, Kexp(0.5, 0.4, dist), col="blue")
lines(dist, Kexp(1, 0.4, dist), col="green")
# plus a est petit, plus les faibles distances attirent les individus

##### 4. Choix du couple #####
#on recherche couple (a, b) tel que p(dist 50km) est environ égale à p(dist infinie)
#mais avec p(dist 40km) différente de p(dist 50km)
#pour avoir 16 valeurs de distances uniformément réparties afin d'estimer a et b, dont 50
dist_Kexp=seq(from=4, to= 370, by=23)

#on teste quelques a avec quelques b pour voir quel couple fonctionne avec le a donné
plot(dist_Kexp, Kexp(1.5, 0.50, dist_Kexp), xlim=c(0,100), type="b")
lines(dist_Kexp, Kexp(1.5, 0.7, dist_Kexp), col="blue")
lines(dist_Kexp, Kexp(1.5, 0.4, dist_Kexp), col="green")
lines(dist_Kexp, Kexp(1.5, 0.6, dist_Kexp), col="red") 

#on compare les quelques couples qui fonctionnent bien
plot(dist_Kexp, Kexp(1.5, 0.6, dist_Kexp), xlim=c(0,100), type="b") 
lines(dist_Kexp, Kexp(1.0, 0.5, dist_Kexp), col="cyan", type="b")    #mieux que 1.5
lines(dist_Kexp, Kexp(0.5, 0.45, dist_Kexp), col="green", type="b")  #moins que 1.0
lines(dist_Kexp, Kexp(0.2, 0.34, dist_Kexp), col="red", type="b")    #moins que 1.0
lines(dist_Kexp, Kexp(0.1, 0.30, dist_Kexp), col="orange", type="b") #moins que 1.0

##### 5. Décision : je garde a=1.0 et b=0.5 ####




##### IV. Calcul du kernel total avec a, b et les distances, puis de la matrice pour Couesnon #####
distance=read.table("Distances.txt", h=T)
h=0.942

connect_kernel=matrix(data=NA, nrow=16, ncol=16)
rownames(connect_kernel)=nom
colnames(connect_kernel)=nom
diag(connect_kernel)=h
connect_kernel #crée la future matrice de connectivité

#origine = couesnon
par(mfrow=c(2,2))
dist=distance[1,-1] #j'enleve le terme "homing"
attrac_d=Kexp(1, 0.5, unlist(dist)) #attractivité du site fonction de distance
plot(unlist(dist), attrac_d, col=couleur[-1]) 

attrac_ad=vector(mode="numeric", length = 15)
ratio_aire_bis=vector(mode="numeric", length = 15)
for (i in 1:15){
  ratio_aire_bis=ratio_aire[,-1]
  attrac_ad[i]=attrac_d[i]*ratio_aire_bis[i]} #attractivité du site fonction de distance et aire
plot(unlist(dist), attrac_ad, col=couleur[-1])

proba_attract_ad=attrac_ad/sum(attrac_ad) #proba d'attractivité du site fonction distance at aire
sum(proba_attract_ad)

proba_dispersion=proba_attract_ad*(1-h) #proba de dispersion de Couesnon vers autre pop
plot(unlist(dist), proba_dispersion, col=couleur[-1])
proba50=data.frame(unlist(dist), proba_dispersion)
sum(proba50[which(proba50[,1]<=50), 2])
mtext(paste("Somme proba quand d<50km =", sum(proba50[which(proba50[,1]<=50), 2])), cex = 0.7)

plot(proba_dispersion, xaxt="n", col.lab="white", col=couleur[-1])
xtick=seq(1,15,1)
axis(side=1, at=xtick, labels = F)
text(x=xtick,  par("usr")[3], col=couleur[-1],
     labels = nom[-1], srt = 70, pos = 1, xpd = TRUE, cex=0.6, offset = 2.5)

connect_kernel[1,-1]=proba_dispersion #je remplis ma matrice pour Couesnon en tant que pop origine
sum(connect_kernel[1,]) #je retombe bien sur 1




##### V. Matrice de connectivité pour toutes les pop #####

pdf("Kernel.pdf")
for (i in 1:16){
  par(mfrow=c(2,2))
  
  attrac_d=vector(mode="numeric", length=15)
  attrac_d=Kexp(1, 0.5, unlist(distance[i,-i])) #attractivité du site fonction de distance
  plot(unlist(distance[i,-i]), attrac_d, xlab="distance(km)", ylab="Attractivité fonction distance", lwd=2,
       main=paste("Population d'origine :",rownames(connect_kernel)[i]), cex.main=0.8, col=couleur[-i]) 
  
  attrac_ad=vector(mode="numeric", length = 15)
  ratio_aire_bis=vector(mode="numeric", length = 15)
  for (j in 1:15){
    ratio_aire_bis=ratio_aire[,-i]
    attrac_ad[j]=attrac_d[j]*ratio_aire_bis[j]} #attractivité du site fonction de distance et aire
  plot(unlist(distance[i,-i]), attrac_ad, xlab="distance(km)", ylab="Attractivité fonction distance et aire",
       main=paste("Population d'origine :",rownames(connect_kernel)[i]), cex.main=0.8, col=couleur[-i], lwd=2)
  
  proba_attract_ad=vector(mode="numeric", length = 15)
  proba_attract_ad=attrac_ad/sum(attrac_ad) #proba d'attractivité du site fonction distance et aire
  sum(proba_attract_ad)
  
  proba_dispersion=vector(mode="numeric", length = 15)
  proba_dispersion=proba_attract_ad*(1-h) #proba de dispersion de pop i vers pop j
  
  plot(unlist(distance[i,-i]), proba_dispersion, ylab="Probabilité de dispersion", xlab="distance(km)", lwd=2,
       main=paste("Population d'origine :",rownames(connect_kernel)[i]), cex.main=0.8, col=couleur[-i])
  proba50=data.frame(unlist(distance[i,-i]), proba_dispersion)
  sum(proba50[which(proba50[,1]<=50), 2])
  mtext(paste("Somme proba quand d<50km =", round(sum(proba50[which(proba50[,1]<=50), 2]), digits=5)), cex = 0.8)

  plot(proba_dispersion, xaxt="n", col.lab="white", cex.main=0.8, col=couleur[-i], lwd=2,
       main=paste("Probabilité de disperser en venant de",rownames(connect_kernel)[i]))
  xtick=seq(1,15,1)
  axis(side=1, at=xtick, labels = F)
  text(x=xtick,  par("usr")[3], col=couleur[-i], font=2,
       labels = nom[-i], srt = 45, pos = 1, xpd = TRUE, cex=0.6, offset = 2.5)
  
  connect_kernel[i,-i]=proba_dispersion
}
dev.off()

connect_kernel


##### IX. Création des 3 matrices de connectivités #####
h=0.942
for (i in 1:16){
  connect[i,i]=h}
for (i in 1:16){
  for (j in 1:16){
    if (i!=j){
      connect[i,j]=(1-h)*proba_a[i,j]}}}
write.table(connect, paste("Mat_log_connectivite_0.942.txt"))

h=1.00
for (i in 1:16){
  connect[i,i]=h}
for (i in 1:16){
  for (j in 1:16){
    if (i!=j){
      connect[i,j]=(1-h)*proba_a[i,j]}}}
write.table(connect, paste("Mat_log_connectivite_1.00.txt"))

h=0.80
for (i in 1:16){
  connect[i,i]=h}
for (i in 1:16){
  for (j in 1:16){
    if (i!=j){
      connect[i,j]=(1-h)*proba_a[i,j]}}}
write.table(connect, paste("Mat_log_connectivite_0.80.txt"))

