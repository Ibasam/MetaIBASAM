immigrants <-
function (filename) 
{
    .C("immigrants", as.character(filename), PACKAGE = "metaIbasam")
    invisible(NULL)
}