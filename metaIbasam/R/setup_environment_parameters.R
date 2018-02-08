setup_environment_parameters <-
function (envParam) 
{
    .C("setup_environment_parameters", as.double(envParam), PACKAGE = "metaIbasam")
    invisible(NULL)
}
