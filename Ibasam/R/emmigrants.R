emmigrants <-
function (filename,probStray) 
{
    if(length(probStray)<2) probStray=c(probStray,probStray)
    .C("emmigrants", as.character(filename), as.double(probStray), PACKAGE = "Ibasam")
    invisible(NULL)
}