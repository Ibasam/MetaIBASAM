reinitialize_parr_maturation <-
function () 
{
    .C("reinitialize_parr_maturation", PACKAGE = "metaIbasam")
    invisible(NULL)
}
