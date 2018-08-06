

nom=as.vector(c("COUESNON","LEFF","TRIEUX","JAUDY","LEGUER","YAR","DOURON","PENZE","ELORN",
                "AULNE","GOYEN","ODET","AVEN","LAITA","SCORFF","BLAVET"))

load("~/Documents/RESEARCH/PROJECTS/IBASAM/MetaIBASAM/analysis/Matrices_Laplace_AireLog.RData")


##### 1. Aire production #####
# vecteur Aire estimée en 2015 dans cet ordre, unité m²
# Couesnon, Leff, Trieux, Jaudy, Leguer, Yar, Douron, Penze, 
# Elorn, Aulne, Goyen, Odet, Aven, Laïta, Scorff, Blavet
aireScript=c(110794, 72305, 213733, 47561, 197283, 37104, 95451, 106753, 
             164699, 252659, 53603, 249049, 142686, 669028, 229027, 393985)


#### DISTANCE
D=read.table("~/Documents/RESEARCH/PROJECTS/IBASAM/MetaIBASAM/data/Distances.txt", h=T)
D=as.matrix(D)
metrics capture isolation

# Distance weighted
W <- 1 / D
W[(W=="Inf")] <- NA
rtot <- rowSums(W, na.rm=TRUE)


# Proximity index
library(FastKNN)
k=2 # number of neigbours
nn=dist.nn=aire.nn=array(,dim=c(16,k))
for (i in 1:16) {
  nn[i,] = k.nearest.neighbors(i, D, k = k)
dist.nn[i,] <- D[i,nn[i,]]
aire.nn[i,] <- aireScript[nn[i,]] / 1000
}


PX=rowMeans(dist.nn)/rowMeans(aire.nn)


library(FNN)
knn.dist(D,k=k)

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


## Scenario 11
sc=list()

for (i in 1:3){
  tmp=list()
  Nmoy5der=NULL
load(paste0("~/Documents/RESEARCH/STAGES/2018/M2-Floren Hugon/results/4_Nmoy5der_Sc",i,"1.RData"))
 tmp[[1]] <- Nmoy5der
 Nmoy5der=NULL
 load(paste0("~/Documents/RESEARCH/STAGES/2018/M2-Floren Hugon/results/4_Nmoy5der_Sc",i,"2.RData"))
 tmp[[2]] <- Nmoy5der
 sc[[i]]<-tmp
 }

df <- data.frame(aire=log10(aireScript/1000)
                 #, isolation = rtot
                 , isolation = PX
                 , sc11=sc[[1]][[1]][1,1:16]
                 , sc12=sc[[1]][[2]][1,1:16]
                 , sc21=sc[[2]][[1]][1,1:16]
                 , sc22=sc[[2]][[2]][1,1:16]
                 , sc31=sc[[3]][[1]][1,1:16]
                 , sc32=sc[[3]][[2]][1,1:16]            
                 )
#df$perc_sc12<- (df$sc12-df$sc11)/df$sc11
df$perc_sc21<- (df$sc21-df$sc11)/df$sc11
df$perc_sc22<- (df$sc22-df$sc12)/df$sc12
df$perc_sc31<- (df$sc31-df$sc11)/df$sc11
df$perc_sc32<- (df$sc32-df$sc12)/df$sc12





par(mfrow = c(2, 1))

#cex = 1.5-PX # Proximity index
#cex=rtot*5 #Distance weighted
cex=(aireScript/sum(aireScript))/.03

x <- 1:16
#x <- D[1,]

plot(NULL, xlim=range(x),ylim=c(1,3),xlab="", ylab="log10(Abondance)",xaxt='n')
axis(side = 1, at=x,labels=nom,las=2)
#text(1:16, log10(df$sc31),labels=rownames(df),cex=.7,pos=3,offset = 2)
points(x,log10(df$sc11),col=paste0("#000000",50),pch=16,cex=cex);
points(x,log10(df$sc21),col=paste0("#000000",75),pch=16,cex=cex);
points(x,log10(df$sc31),col=paste0("#000000"),pch=16,cex=cex);

points(x,log10(df$sc12),col=paste0("#FF0000",50),pch=16,cex=cex)
points(x,log10(df$sc22),col=paste0("#FF0000",75),pch=16,cex=cex)
points(x,log10(df$sc32),col=paste0("#FF0000"),pch=16,cex=cex)




plot(NULL, xlim=range(x),ylim=c(-,75),xlab="", ylab="Change in abundance (%)",xaxt='n')
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
axis(side = 1, at=x,labels=nom,las=2)
#text(x, df$perc_sc31*100,labels=rownames(df),cex=.7,pos=3,offset = 2)
#points(x, df$perc_sc11*100, pch=16, col=paste0("#000000",50))
points(x, df$perc_sc21*100, pch=16, col=paste0("#000000",85),cex=cex)
points(x, df$perc_sc31*100, pch=16, col=paste0("#000000"),cex=cex)

points(x, df$perc_sc12*100, pch=16, col=paste0("#FF0000",50),cex=cex)
points(x, df$perc_sc22*100, pch=16, col=paste0("#FF0000",85),cex=cex)
points(x, df$perc_sc32*100, pch=16, col=paste0("#FF0000"),cex=cex)

# abline(lm(perc_sc32*100 ~ aire, data=df), col=paste0("#FF0000"),lwd=2)
# abline(lm(perc_sc22*100 ~ aire, data=df), col=paste0("#FF0000",85),lwd=2)
# abline(lm(perc_sc12*100 ~ aire, data=df), col=paste0("#FF0000",50),lwd=2)
# 
# abline(lm(perc_sc21*100 ~ aire, data=df), col=paste0("#000000",85),lwd=2)
# abline(lm(perc_sc31*100 ~ aire, data=df), col=paste0("#000000"),lwd=2)








par(mfrow = c(2, 1))

#cex = 1.5-PX
cex=rtot*5
plot(NULL, xlim=range(df$aire),ylim=c(1,3),xlab="log10(Aire production)", ylab="log10(Abondance)")
text(df$aire, log10(df$sc31),labels=rownames(df),cex=.7,pos=3,offset = 1)
points(df$aire,log10(df$sc11),col=paste0("#000000",50),pch=16,cex=cex);abline(lm(log10(sc11) ~ aire, data=df), col=paste0("#000000",50),lwd=2)
points(df$aire,log10(df$sc21),col=paste0("#000000",75),pch=16,cex=cex);abline(lm(log10(sc21) ~ aire, data=df), col=paste0("#000000",75),lwd=2)
points(df$aire,log10(df$sc31),col=paste0("#000000"),pch=16,cex=cex);abline(lm(log10(sc31) ~ aire, data=df), col=paste0("#000000"),lwd=2)

points(df$aire,log10(df$sc12),col=paste0("#FF0000",50),pch=16,cex=cex);abline(lm(log10(sc12) ~ aire, data=df), col=paste0("#FF0000",50),lwd=2)
points(df$aire,log10(df$sc22),col=paste0("#FF0000",75),pch=16,cex=cex);abline(lm(log10(sc22) ~ aire, data=df), col=paste0("#FF0000",75),lwd=2)
points(df$aire,log10(df$sc32),col=paste0("#FF0000"),pch=16,cex=cex);abline(lm(log10(sc32) ~ aire, data=df), col=paste0("#FF0000"),lwd=2)




cex=rtot*5 #Distance weighted
plot(NULL, xlim=range(df$aire),ylim=c(-75,75),xlab="log10(Aire production)", ylab="Change in abundance (%)")
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
text(df$aire, df$perc_sc31*100,labels=rownames(df),cex=.7,pos=3,offset = 1)
#points(df$aire, df$perc_sc11*100, pch=16, col=paste0("#000000",50))
points(df$aire, df$perc_sc21*100, pch=16, col=paste0("#000000",85),cex=cex)
points(df$aire, df$perc_sc31*100, pch=16, col=paste0("#000000"),cex=cex)

points(df$aire, df$perc_sc12*100, pch=16, col=paste0("#FF0000",50),cex=cex)
points(df$aire, df$perc_sc22*100, pch=16, col=paste0("#FF0000",85),cex=cex)
points(df$aire, df$perc_sc32*100, pch=16, col=paste0("#FF0000"),cex=cex)

abline(lm(perc_sc32*100 ~ aire, data=df), col=paste0("#FF0000"),lwd=2)
abline(lm(perc_sc22*100 ~ aire, data=df), col=paste0("#FF0000",85),lwd=2)
abline(lm(perc_sc12*100 ~ aire, data=df), col=paste0("#FF0000",50),lwd=2)

abline(lm(perc_sc21*100 ~ aire, data=df), col=paste0("#000000",85),lwd=2)
abline(lm(perc_sc31*100 ~ aire, data=df), col=paste0("#000000"),lwd=2)

# lw1 <- loess( perc_sc31*100 ~ aire,data=df)
# j <- order(df$aire)
# lines(df$aire[j],lw1$fitted[j],col="#000000",lwd=3)
# 
# lw1 <- loess( perc_sc21*100 ~ aire,data=df)
# j <- order(df$aire)
# lines(df$aire[j],lw1$fitted[j],col=paste0("#000000",85),lwd=3)
# 
# lw1 <- loess( perc_sc32*100 ~ aire,data=df)
# j <- order(df$aire)
# lines(df$aire[j],lw1$fitted[j],col="#FF0000",lwd=3)
# 
# lw1 <- loess( perc_sc12*100 ~ aire,data=df)
# j <- order(df$aire)
# lines(df$aire[j],lw1$fitted[j],col=paste0("#FF0000",50),lwd=3)
# 
# lw1 <- loess( perc_sc22*100 ~ aire,data=df)
# j <- order(df$aire)
# lines(df$aire[j],lw1$fitted[j],col=paste0("#FF0000",85),lwd=3)



####

#df$isolation<-log10(df$isolation)
cex=(aireScript/sum(aireScript))*15
#cex = 2-PX

plot(NULL, xlim=range(df$isolation),ylim=c(1,3),xlab="Isolation", ylab="log10(Abondance)")
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
text(df$isolation, log10(df$sc31),labels=rownames(df),cex=.7,pos=3,offset = 1)
points(df$isolation,log10(df$sc11),col=paste0("#000000",50),pch=16,cex=cex);abline(lm(log10(sc11) ~ isolation, data=df), col=paste0("#000000",50),lwd=2)
points(df$isolation,log10(df$sc21),col=paste0("#000000",75),pch=16,cex=cex);abline(lm(log10(sc21) ~ isolation, data=df), col=paste0("#000000",75),lwd=2)
points(df$isolation,log10(df$sc31),col=paste0("#000000"),pch=16,cex=cex);abline(lm(log10(sc31) ~ isolation, data=df), col=paste0("#000000"),lwd=2)

points(df$isolation,log10(df$sc12),col=paste0("#FF0000",50),pch=16,cex=cex);abline(lm(log10(sc12) ~ isolation, data=df), col=paste0("#FF0000",50),lwd=2)
points(df$isolation,log10(df$sc22),col=paste0("#FF0000",75),pch=16,cex=cex);abline(lm(log10(sc22) ~ isolation, data=df), col=paste0("#FF0000",75),lwd=2)
points(df$isolation,log10(df$sc32),col=paste0("#FF0000"),pch=16,cex=cex);abline(lm(log10(sc32) ~ isolation, data=df), col=paste0("#FF0000"),lwd=2)




plot(NULL, xlim=range(df$isolation),ylim=c(-75,75),xlab="Isolation", ylab="Change in abundance (%)")
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
text(df$isolation, df$perc_sc31*100,labels=rownames(df),cex=.7,pos=3,offset = 1)
#points(df$aire, df$perc_sc11*100, pch=16, col=paste0("#000000",50))
points(df$isolation, df$perc_sc21*100, pch=16, col=paste0("#000000",75),cex=cex)
points(df$isolation, df$perc_sc31*100, pch=16, col=paste0("#000000"),cex=cex)

points(df$isolation, df$perc_sc12*100, pch=16, col=paste0("#FF0000",50),cex=cex)
points(df$isolation, df$perc_sc22*100, pch=16, col=paste0("#FF0000",75),cex=cex)
points(df$isolation, df$perc_sc32*100, pch=16, col=paste0("#FF0000"),cex=cex)




####
df$attrac<-(colSums(connect$h0.80))

cex=1#(aireScript/sum(aireScript))*15
#cex = 2-PX

plot(NULL, xlim=range(df$attrac),ylim=c(1,3),xlab="Attractiveness", ylab="log10(Abondance)")
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
text(df$attrac, log10(df$sc31),labels=rownames(df),cex=.7,pos=3,offset = 1)
points(df$attrac,log10(df$sc11),col=paste0("#000000",50),pch=16,cex=cex);abline(lm(log10(sc11) ~ attrac, data=df), col=paste0("#000000",50),lwd=2)
points(df$attrac,log10(df$sc21),col=paste0("#000000",75),pch=16,cex=cex);abline(lm(log10(sc21) ~ attrac, data=df), col=paste0("#000000",75),lwd=2)
points(df$attrac,log10(df$sc31),col=paste0("#000000"),pch=16,cex=cex);abline(lm(log10(sc31) ~ attrac, data=df), col=paste0("#000000"),lwd=2)

points(df$attrac,log10(df$sc12),col=paste0("#FF0000",50),pch=16,cex=cex);abline(lm(log10(sc12) ~ attrac, data=df), col=paste0("#FF0000",50),lwd=2)
points(df$attrac,log10(df$sc22),col=paste0("#FF0000",75),pch=16,cex=cex);abline(lm(log10(sc22) ~ attrac, data=df), col=paste0("#FF0000",75),lwd=2)
points(df$attrac,log10(df$sc32),col=paste0("#FF0000"),pch=16,cex=cex);abline(lm(log10(sc32) ~ attrac, data=df), col=paste0("#FF0000"),lwd=2)




plot(NULL, xlim=range(df$attrac),ylim=c(-75,75),xlab="Attractiveness", ylab="Change in abundance (%)")
abline(h=0,lty=1,lwd=2,col=paste0("#000000",50))
text(df$attrac, df$perc_sc31*100,labels=rownames(df),cex=.7,pos=3,offset = 1)
#points(df$aire, df$perc_sc11*100, pch=16, col=paste0("#000000",50))
points(df$attrac, df$perc_sc21*100, pch=16, col=paste0("#000000",75),cex=cex)
points(df$attrac, df$perc_sc31*100, pch=16, col=paste0("#000000"),cex=cex)

points(df$attrac, df$perc_sc12*100, pch=16, col=paste0("#FF0000",50),cex=cex)
points(df$attrac, df$perc_sc22*100, pch=16, col=paste0("#FF0000",75),cex=cex)
points(df$attrac, df$perc_sc32*100, pch=16, col=paste0("#FF0000"),cex=cex)


