check_return <-
function () 
{
    .C("check_return", PACKAGE = "metaIbasam")
    invisible(NULL)
}
