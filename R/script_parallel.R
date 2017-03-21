setwd("/home/basp-meco88/Documents/RESEARCH/PROJECTS/IBASAM/MetaIBASAM/R")



# /!\ toujours mettre 0.0 au lieu de 0!!!!


# library(parallel)
# #detectCores() # nb of cores available
# nPop = 10
# if(nPop > detectCores()) stop("too many populations")
# 



## Approche 1
### Necessite une ré-initilaisation d'Ibasam avec tous les individus
# initsA <- initialisation de la popA au début des simuls
# initsB <- initialisation de la popB au début des simuls
# 
# for (i.année in 1:50){
#   
#   popA <- mcparallel(ibasam(initsA))
#   popB <- mcparallel(ibasam(initsB))
#   
#   mccollect(list(popA,popB),wait=T)
#   
#   initsA <- popA - dispersionA2B + dispersionB2A
#   initsB <- popB - dispersionB2A + dispersionA2B
#   
# }


## Approche 2

#  pause the execution of an R script until a file is created and loaded
# créer une fonction pause()
pause = function(file.name)
{
  while (!file.exists(file.name)) {
    Sys.sleep(1)
  }
}


## Conditonner 

# Test
pop <- function(nameA,nameB,time){
  #res=NULL
  x = 100
  res <- x
  for (y in 1:10){

  # Emigrants
  em = rbinom(1,x,p=.1)
  Sys.sleep(time)
  write(em,file=paste("stray_",nameA,"to",nameB,"_",y,".txt",sep="")) # emigrants from A
  
  # Immigrants
  file.name = paste("stray_",nameB,"to",nameA,"_",y,".txt",sep="") # file name of immigrants from pop B
  #pause(file.name) # check if file.name exists
  im <- as.numeric(read.table(file.name)) # immigrants from pop B
  #system(paste("rm ",file.name,sep="")) # cleaning once read
  x = x - em #+ im
  res <-c(res,x)
  }
  return(res)
}
pop(nameA = "A",nameB = "B", time = 1)
pop(nameA = "B",nameB = "A", time = 1)

#library(parallel)
# initsA=100
# initsB=50
# for (y in 1:50){
# 
#   popA <- mcparallel(pop("A","B",initsA,1))
#   popB <- mcparallel(pop("B","A",initsB,5))
# 
#   #mccollect(list(popA,popB),wait=T)
# 
#   initsA <- popA
#   initsB <- popB
# 
# }
pop.name <-rbind(c("A","B"),c("B","A"))
time <- c(1,2)
df <- data.frame(names.pop=cbind(pop.name,time))
results <- mclapply(1:2, function(i) pop(nameA=df$names.pop[i,1], nameB=df$names.pop[i,2], time=df$names.pop[i,3]), mc.cores = 2)



