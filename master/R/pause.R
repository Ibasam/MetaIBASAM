#  pause the execution of an R script until a file is created and loaded
# créer une fonction pause()
pause <- function(file.name)
{
  i = 0
  while (!file.exists(file.name)) {
    i = i + 1
    if (i == 1) {cat("\n"); cat("waiting for immigrants")} else {cat(".")}
    #if (i == 1) {message("\n waiting for immigrants")} else {message(".")}
    Sys.sleep(2) # check every 1 second
  }
}