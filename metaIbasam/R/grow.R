grow <-
function (time_step_length) 
{
    .C("grow", as.double(time_step_length), PACKAGE = "metaIbasam")
    invisible(NULL)
}
