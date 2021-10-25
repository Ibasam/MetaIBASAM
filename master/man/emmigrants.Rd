\name{emmigrants}
\alias{emmigrants}
\title{
emmigrants
}
\description{
Provide an interface to select randomly emmigrant anadromous salmon whose information are kept in a txt file
}
\usage{
emmigrants(filename,probStray)
}

\arguments{
  \item{filename}{
    name of file to save informations
}
  \item{probStray}{
    probability to stray away from the current river
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Cyril Piou
Mathieu Buoro
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (filename,probStray) 
{
    .C("emmigrants", as.character(filename), as.double(probStray), PACKAGE = "metaIbasam")
    invisible(NULL)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ misc }
\keyword{ utilities }
\keyword{ programming }
