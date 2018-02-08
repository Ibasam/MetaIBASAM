set_collecID <-
function (newID = NULL) 
{
    if (is.null(newID)) 
        newID = round(runif(1, 1, 1000))
    .C("set_collecID", as.integer(newID), PACKAGE = "metaIbasam")
    invisible(NULL)
}
