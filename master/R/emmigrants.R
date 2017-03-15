emmigrants <-
function (filename,probStray) 
{
    .C("emmigrants", as.character(filename), as.double(probStray), PACKAGE = "Ibasam")
    invisible(NULL)
}