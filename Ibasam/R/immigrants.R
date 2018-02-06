immigrants <-
function (filename) 
{
    .C("immigrants", as.character(filename), PACKAGE = "Ibasam")
    invisible(NULL)
}