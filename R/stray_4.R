

## Coordinates between popualtions
x <- rnorm(4, 0, 1)
y <- rnorm(4, 0, 1)
coord <- cbind(x,y)

## Calculate euclidean distance between populations
euc.dist <- function(x, y) sqrt(sum((x - y) ^ 2))
dist <- array(,dim=c(4, 4))
for(i in 1:nrow(coord)) {
  for(j in 1:nrow(coord)) {
  dist[i,j] <- euc.dist(coord[i,],coord[j,])
}}
dist


## Plot distance matrix
dim <- ncol(dist)
image(1:dim, 1:dim, dist, axes = FALSE, xlab="", ylab="")
axis(1, 1:dim, 1:4, cex.axis = 0.5, las=3)
axis(2, 1:dim, 1:4, cex.axis = 0.5, las=1)
text(expand.grid(1:dim, 1:dim), sprintf("%0.1f", dist), cex=0.6)

## Probability of straying / euclidean distance
invlogit = function(x) { 1/(1+exp(-x)) }
mstray <- dist
alpha <- c(-2, -2)
for(i in 1:nrow(coord)) {
  for(j in 1:nrow(coord)) {
    mstray[i,j] <- invlogit(alpha[1] + alpha[2]*dist[i,j])
  }}

diag(mstray) <- 0

# Plot prob straying / distance
plot(dist[,1], mstray[,1])


## Cumulative proportion of strayers
colSums(mstray)


## Plot distance matrix
pdf("R/straying.pdf")
dim <- ncol(mstray)
image(1:dim, 1:dim, mstray, axes = FALSE, xlab="Pop. origin", ylab="Pop. mig", main="Rate of straying (%)")
axis(1, 1:dim, 1:4, cex.axis = 0.5, las=3)
axis(2, 1:dim, 1:4, cex.axis = 0.5, las=1)
text(expand.grid(1:dim, 1:dim), sprintf("%0.1f", mstray*100), cex=0.6)
dev.off()

save(mstray, file="R/straying.RData")
