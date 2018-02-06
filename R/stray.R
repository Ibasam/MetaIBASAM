#npop =10

# Area of populations
area = runif(npop, 100, 1000)


## Coordinates between popualtions
x <- rnorm(npop, 0, 1)
y <- rnorm(npop, 0, 1)
coord <- cbind(x,y)



## Calculate euclidean distance between populations
euc.dist <- function(x, y) sqrt(sum((x - y) ^ 2))
dist <- array(,dim=c(npop, npop))
for(i in 1:nrow(coord)) {
  for(j in 1:nrow(coord)) {
  dist[i,j] <- euc.dist(coord[i,],coord[j,])
}}
dist


## Plot distance matrix
dim <- ncol(dist)
image(1:dim, 1:dim, dist, axes = FALSE, xlab="", ylab="")
axis(1, 1:dim, 1:npop, cex.axis = 0.5, las=3)
axis(2, 1:dim, 1:npop, cex.axis = 0.5, las=1)
text(expand.grid(1:dim, 1:dim), sprintf("%0.1f", dist), cex=0.6)

## Probability of straying / euclidean distance
invlogit = function(x) { 1/(1+exp(-x)) }
mstray <- dist
alpha <- c(-2, -3, 2)
for(i in 1:nrow(coord)) {
  for(j in 1:nrow(coord)) {
    mstray[i,j] <- invlogit(alpha[1] + alpha[2]*(dist[i,j]-mean(dist[]))/sd(dist[]) + alpha[3]*(area[j]-mean(area[]))/sd(area[]))
  }}

diag(mstray) <- 0 # homing

# Plot prob straying / distance
plot(dist[,1], mstray[,1])

# require(lattice)
# levelplot(mstray)
# 
# require(corrplot)  
# corrplot(mstray, method="circle")
# 
# dist_mi <- 1/dist # one over, as qgraph takes similarity matrices as input
# library(qgraph)
# qgraph(dist_mi, layout='spring', vsize=3)
# 
# ## Cumulative proportion of strayers
# barplot(colSums(mstray),names.arg=paste0(1:npop),main="Cumulative proportion of strayers (%)")


## Plot distance matrix
pdf("R/straying.pdf")
dim <- ncol(mstray)
image(1:dim, 1:dim, mstray, axes = FALSE, xlab="Pop. origin", ylab="Pop. mig", main="Rate of straying (%)")
axis(1, 1:dim, 1:npop, cex.axis = 0.5, las=3)
axis(2, 1:dim, 1:npop, cex.axis = 0.5, las=1)
text(expand.grid(1:dim, 1:dim), sprintf("%0.2f", mstray*100,"%"), cex=0.6)
dev.off()

save(mstray, file="R/straying.RData")


#barplot(area,names.arg=paste0(1:npop),main="Area of production")

#plot(x,y,pch=NA);text(x,y,labels = 1:npop)


