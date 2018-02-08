empty_memory_success <-
function () 
{
    .C("empty_memory_success", PACKAGE = "metaIbasam")
    invisible(NULL)
}
