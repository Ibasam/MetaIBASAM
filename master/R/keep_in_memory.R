keep_in_memory <-
function () 
{
    .C("keep_in_memory", PACKAGE = "metaIbasam")
    invisible(NULL)
}
