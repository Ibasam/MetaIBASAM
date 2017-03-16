





## Approche 1
### Necessite une ré-initilaisation d'Ibasam avec tous les individus
initsA <- initialisation de la popA au début des simuls
initsB <- initialisation de la popB au début des simuls

for (i.année in 1:50){
  
  popA <- mcparallel(ibasam(initsA))
  popB <- mcparallel(ibasam(initsB))
  
  mccollect(list(popA,popB),wait=T)
  
  initsA <- popA - dispersionA2B + dispersionB2A
  initsB <- popB - dispersionB2A + dispersionA2B
  
}


## Approche 2

library(parallel)
#detectCores() # nb of cores available
nPop = 10
if(nPop > detectCores()) stop("too many populations")

popA <- function(){
  
  
  
}
while (!file.exists(your.file.name)) {
  Sys.sleep(1)
}
