Omega <-
function (time_step_length) 
{
    return(unlist(.C("Omega", as.double(time_step_length), as.double(0), 
        PACKAGE = "metaIbasam")[[2]]))
}
