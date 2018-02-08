post_repro_mortality <-
function () 
{
    .C("post_repro_mortality", PACKAGE = "metaIbasam")
    invisible(NULL)
}
