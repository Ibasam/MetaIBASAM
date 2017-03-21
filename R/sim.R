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
pop <- function(nameA,nameB,p,time){
  #res=NULL
  x = 100
  res <- x
  for (y in 1:10){
    
    # Emigrants
    em = rbinom(1,x,p)
    Sys.sleep(time)
    write(em,file=paste("stray_",nameA,"to",nameB,"_",y,".txt",sep="")) # emigrants from A
    
    # Immigrants
    file.name = paste("stray_",nameB,"to",nameA,"_",y,".txt",sep="") # file name of immigrants from pop B
    pause(file.name) # check if file.name exists
    im <- as.numeric(read.table(file.name)) # immigrants from pop B
    x = x - em + im
    system(paste("rm ",file.name,sep="")) # cleaning once read
    res <-c(res,x)
  }
  return(res)
}


##First read in the arguments listed at the command line
args=(commandArgs(TRUE))
# Here you should add some error exception handling code
# in case the number of passed arguments doesn't match what
# you expect (check what Forester did in his example)

# Parse the arguments (in characters) and evaluate them
# vec1 <- eval( parse(text=args[1]) )

test <- pop(nameA=args[1],nameB=args[2],p= as.numeric(args[3]), time=args[4])

save(test, file=paste("Res_",args[1],args[2],args[3],".RData",sep=""))
