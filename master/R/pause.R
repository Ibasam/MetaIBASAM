#  pause the execution of an R script until a file is created and loaded
# créer une fonction pause()
pause <- function(file.name)
{
  while (!file.exists(file.name)) {
    Sys.sleep(1) # check every 1 second
  }
}