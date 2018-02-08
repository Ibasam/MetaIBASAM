check_smoltification <-
function () 
{
    .C("check_smoltification", PACKAGE = "metaIbasam")
    invisible(NULL)
}
