

#install.packages("doMPI", dependencies=TRUE)
library(doMPI)
# create an MPI cluster object
cl <- startMPIcluster(count=2) # starts two cluster workers, or slaves, as MPI calls them
registerDoMPI(cl) # register the MPI cluster object with the foreach package
closeCluster(cl)

x <- seq(-8, 8, by=0.5)
v <- foreach(y=x, .combine="cbind") %dopar% {
  r <- sqrt(x^2 + y^2) + .Machine$double.eps
  sin(r) / r +}
persp(x, x, v)



## you should have invoked R as:
## mpirun -machinefile .hosts -np 1 R CMD BATCH --no-save doMPI.R doMPI.out
## unless running within a SLURM job, in which case you should do:
## mpirun R CMD BATCH --no-save file.R file.out

library(Rmpi)
library(doMPI)

cl = startMPIcluster()  # by default will start one fewer slave
# than elements in .hosts

registerDoMPI(cl)
clusterSize(cl) # just to check

results <- foreach(i = 1:200) %dopar% {
  out = mean(rnorm(1e6))
}

closeCluster(cl)

mpi.quit()







library(doParallel)
cl <- makeCluster(2)
registerDoParallel(cl)
#foreach(i=1:3) %dopar% sqrt(i)
x <- seq(-8, 8, by=0.5)
v <- foreach(y=x, .combine="cbind") %dopar% {
  r <- sqrt(x^2 + y^2) + .Machine$double.eps
  sin(r) / r
  }
persp(x, x, v)

stopCluster(cl)
rm(cl)



results <- foreach(i=1:n, .export=c('demoIbasam'), .packages='metaIbasam') %dopar% {
  # do something cool
}




library(SPEI)
library(parallel)
Define the test list.

Tmin <- list(aa = data.frame(a=1:30, b1=runif(30), b2=runif(30), latitude=runif(30)),
             bb = data.frame(a=1:30, b1=runif(30), b2=runif(30), latitude=runif(30)))

Tmax <- list(aa = data.frame(a=1:30, b1=runif(30), b2=runif(30), latitude=runif(30)),
             bb = data.frame(a=1:30, b1=runif(30), b2=runif(30), latitude=runif(30)))
Make the cluster

clust <- makeCluster(2)
This is the re-written function, but we'll test it out on a simpler function.

pet1 <- function(ind){
Tmin[[ind]]$a + Tmax[[ind]]$a
}
Call the SPEI library and send everything in the workspace to each CPU. This is normally not great form, so forgive me.

clusterEvalQ(clust, library(SPEI))
clusterExport(clust, ls())
Run the parLapply function

pet_test <- parLapply(clust, 1:length(Tmin), pet1)