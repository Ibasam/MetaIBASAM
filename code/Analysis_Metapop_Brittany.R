

load("~/Documents/RESEARCH/PROJECTS/IBASAM/MetaIBASAM/data/Varinterest_mcmc.RData")
area <- read.csv2("data/Surf_ERR.csv",header = T)
area <- area[area[,1] %in% names(vartrendlist$N_MSW),]
area <- area[,ncol(area)] / 100 # by 100m2



#str(vartrendlist)
npop = length(vartrendlist$N_MSW)
N_MSW<-N_SW<-F_MSW<-F_SW<-R<-list()
for (l in 1:npop){
  N_SW[[l]] <- apply(vartrendlist$N_SW[[l]],2,quantile,probs=.5)
  N_MSW[[l]] <- apply(vartrendlist$N_MSW[[l]],2,quantile,probs=.5)
  F_SW[[l]] <- apply(vartrendlist$F_SW[[l]],2,quantile,probs=.5)
  F_MSW[[l]] <- apply(vartrendlist$F_MSW[[l]],2,quantile,probs=.5)
  R[[l]] <- apply(vartrendlist$R[[l]],2,quantile,probs=.5,na.rm=T)
}



pdf(file = "data/Metapop_Brittany.pdf")
#### ABUNDANCES FOR EACH POPULATIONS
colors <- c("#00BFFF", "#1C86EE","#8B7500")
par(mfrow=c(3,2))
for (l in 1:npop){
  tmp <- N_SW[[l]]
  plot(NULL, xlim=c(0,length(tmp)),ylim=c(0,max(tmp)),xaxt='n',xlab="",ylab="Abundance",main=names(vartrendlist$N_MSW)[l])
  axis(1,at=1:length(tmp),labels = names(tmp),las=2, cex=.5)
  points(1:length(tmp),tmp,type="b", col=colors[1])
  tmp <- N_MSW[[l]]
  points(1:length(tmp),tmp,type="b", col=colors[2])
  legend("topright", c("1SW", "MSW"), fill = colors, bty = "n")
  
  sw <- N_SW[[l]]
  msw <- N_MSW[[l]]
  plot(NULL, xlim=c(0,length(tmp)),ylim=c(0,50),xaxt='n',xlab="",ylab="% MSW",main=names(vartrendlist$N_MSW)[l])
  axis(1,at=1:length(tmp),labels = names(tmp),las=2, cex=.5)
  points(1:length(tmp),(msw/(sw+msw))*100,type="b", col=colors[2])
  #legend("topright", c("1SW", "MSW"), fill = colors, bty = "n")
}





par(mfrow=c(2,2))
#### ABUNDANCE
colors <- c("#00BFFF", "#1C86EE","#8B7500")
df <- data.frame(SW = unlist(lapply(N_SW,mean)),MSW = unlist(lapply(N_MSW,mean)))
rownames(df)<-names(vartrendlist$N_MSW)
data <- t(as.matrix(df))
barplot(data, col=colors[1:2] , border="white", beside=F, 
        #legend=rownames(data),
        cex.names=0.7,las=2,las=2,
        xlab="",ylab="Abundance (mean over time, 1992-2015)"
        #, font.lab=2
        )
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
legend("topright", rownames(data), fill = colors, bty = "n")

data2 <- data
data2["SW",] <- data["SW",]/data["SW","SCORFF"]
data2["MSW",] <- data["MSW",]/data["MSW","SCORFF"]
barplot(data2, col=colors[1:2] , border="white", beside=T, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Ratio # Scorff (mean over time, 1992-2015)"
        #, font.lab=2
)
abline(h=1,lty=2)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
legend("topright", rownames(data2), fill = colors, bty = "n")


#### DENSITY
colors <- c("#00BFFF", "#1C86EE","#8B7500")
df <- data.frame(SW = unlist(lapply(N_SW,mean))/area,MSW = unlist(lapply(N_MSW,mean))/area)
rownames(df)<-names(vartrendlist$N_MSW)
data <- t(as.matrix(df))
barplot(data, col=colors[1:2] , border="white", beside=F, 
        #legend=rownames(data),
        cex.names=0.7,las=2,las=2,
        xlab="",ylab="Density (100m2, mean over time, 1992-2015)"
        #, font.lab=2
)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
legend("topright", rownames(data), fill = colors, bty = "n")

data2 <- data
data2["SW",] <- data["SW",]/data["SW","SCORFF"]
data2["MSW",] <- data["MSW",]/data["MSW","SCORFF"]
barplot(data2, col=colors[1:2] , border="white", beside=T, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Ratio Density # Scorff (100m2, mean over time, 1992-2015)"
        #, font.lab=2
)
abline(h=1,lty=2)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
legend("topright", rownames(data2), fill = colors, bty = "n")


#### PROPORTION
colors <- c("#00BFFF", "#1C86EE","#8B7500")
SW = unlist(lapply(N_SW,mean))
MSW = unlist(lapply(N_MSW,mean))
df <- data.frame(prop=(MSW/(SW+MSW))*100)
rownames(df)<-names(vartrendlist$N_MSW)
data <- t(as.matrix(df))
barplot(data, col=colors[2] , border="white", beside=F, 
        #legend=rownames(data),
        cex.names=0.7,las=2,las=2,
        xlab="",ylab="%MSW (mean over time, 1992-2015)"
        #, font.lab=2
)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
#legend("topright", rownames(data), fill = colors, bty = "n")

data2 <- data
data2 <- data/data[,"SCORFF"]
barplot(data2, col=colors[2] , border="white", beside=T, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Ratio MSW # Scorff (mean over time, 1992-2015)"
        #, font.lab=2
)
abline(h=1,lty=2)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
#legend("topright", rownames(data2), fill = colors, bty = "n")



#### EXPLOITATION
colors <- c("#FF6A6A", "#FF3030", "#FFFFFF")
df <- data.frame(SW = unlist(lapply(F_SW,mean)),MSW = unlist(lapply(F_MSW,mean)))
rownames(df)<-names(vartrendlist$F_MSW)
data <- t(as.matrix(df))
barplot(data, col=colors[1:2] , border="white", beside=F, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Exploitation (mean over time, 1992-2015)"
        #, font.lab=2
)
#axis(1,at = 1:npop, labels =names(vartrendlist$F_MSW),las=2)
legend("topright", rownames(data), fill = colors, bty = "n")

data2 <- data
data2["SW",] <- data["SW",]/data["SW","SCORFF"]
data2["MSW",] <- data["MSW",]/data["MSW","SCORFF"]
barplot(data2, col=colors[1:2] , border="white", beside=T, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Ratio # Scorff (mean over time, 1992-2015)"
        #, font.lab=2
)
abline(h=1,lty=2)
#axis(1,at = 1:npop, labels =names(vartrendlist$F_MSW),las=2)
legend("topright", rownames(data2), fill = colors, bty = "n")


#### RECRUITMENT
colors <- c("#00BFFF", "#1C86EE","#8B7500")
df <- data.frame(R = unlist(lapply(R,mean, na.rm=T)))
rownames(df)<-names(vartrendlist$R)
data <- t(as.matrix(df))
barplot(data, col=colors[3] , border="white", beside=F, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Recruitment (mean over time, 1992-2015)"
        #, font.lab=2
)
#axis(1,at = 1:npop, labels =names(vartrendlist$N_MSW),las=2)
#legend("topright", rownames(data), fill = colors[3], bty = "n")

data2 <- data
data2["R",] <- data["R",]/data["R","SCORFF"]
barplot(data2, col=colors[3] , border="white", beside=T, 
        #legend=rownames(data),
        cex.names=0.7,las=2,
        xlab="",ylab="Ratio # Scorff (mean over time, 1992-2015)"
        #, font.lab=2
)
abline(h=1,lty=2)
#axis(1,at = 1:npop, labels =names(vartrendlist$F_MSW),las=2)
#legend("topright", rownames(data2), fill = colors[3], bty = "n")

dev.off()
