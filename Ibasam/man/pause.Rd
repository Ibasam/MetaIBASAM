\name{arraybind}
\alias{arraybind}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
pause
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
pause()
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file.name}{
%%     ~~Describe \code{x} here~~
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
#  pause the execution of an R script until a file is created and loaded
# créer une fonction pause()
function(file.name)
{
  while (!file.exists(file.name)) {
    Sys.sleep(1)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ misc }
\keyword{ utilities }
\keyword{ programming }
