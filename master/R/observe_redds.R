observe_redds <-
function () 
{
    n <- unlist(.C("length_observe_redds", as.integer(0), PACKAGE = "metaIbasam"))
    if (n > 0) {
        pop <- matrix(unlist(.C("observe_redds", as.double(1:(n * 
            nColObserveRedds)), PACKAGE = "metaIbasam")), ncol = nColObserveRedds, 
            nrow = n, byrow = TRUE)
        pop <- as.data.frame(pop)
    }
    else {
        pop <- as.data.frame(t(rep(NA, nColObserveRedds)))
    }
    colnames(pop) <- ColNamesRedds
    return(pop)
}
