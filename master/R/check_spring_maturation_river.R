check_spring_maturation_river <-
function () 
{
    .C("check_spring_maturation_river", PACKAGE = "metaIbasam")
    invisible(NULL)
}
