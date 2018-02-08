restore_in_memory <-
function () 
{
    .C("restore_in_memory", PACKAGE = "metaIbasam")
    invisible(NULL)
}
