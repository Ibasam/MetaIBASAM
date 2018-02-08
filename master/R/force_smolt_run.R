force_smolt_run <-
function () 
{
    .C("force_smolt_run", PACKAGE = "metaIbasam")
    invisible(NULL)
}
