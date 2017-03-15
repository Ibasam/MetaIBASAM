
library(parallel)
#detectCores() # nb of cores available
nPop = 10
if(nPop > detectCores()) stop("too many populations")