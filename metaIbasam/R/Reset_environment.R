Reset_environment <-
function () 
{
    .C("Reset_environment", PACKAGE = "metaIbasam")
    invisible(NULL)
}
