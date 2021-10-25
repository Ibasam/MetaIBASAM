reinitialize_salmon_maturation <-
function () 
{
    .C("reinitialize_salmon_maturation", PACKAGE = "metaIbasam")
    invisible(NULL)
}
