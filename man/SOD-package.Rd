\name{SOD-package}
\alias{SOD-package}
\alias{SOD}
\docType{package}
\title{
Heuristict mapping of N-dimensional nodes to M-dimensions
}
\description{
Maps points in N- to M-dimensions (where N > M) using a heuristic that 
tries to retain correct inter-node distances by rearranging nodes
using errors in the inter-node distances induced by gradually shrinking
the number of dimensions.

The primary purpose of this is to represent N-dimensional nodes 
(points) in a 2-D or 3-D space in order to visualise the relationships
between nodes.

Since the method is computationally intensive, two classes are provided
\itemize{
  \item{
    DimSqueezer: 
    Uses openMP* to parallelise the mapping process
  }
  \item{
    DimSqueezer_CL:
    Uses openCL to perform the mapping operation on a GPU
  }
}
*On recent versions of Mac OSX the default compiler is clang rather than
gcc. Unfortunately, clang doesn't support openMP, so the current version
of the configuration script doesn't use openMP on Macs. openCL
acceleration is also dependent on the host computer, so may or may not
be available.
}

\details{
  \tabular{ll}{
    Package: \tab SOD\cr
    Type: \tab Package\cr
    Version: \tab 1.0\cr
    Date: \tab 2013-10-10\cr
    License: \tab GPL-2\cr
  }
  The basic functions are accessed from DimSqueezer objects which are
  reference class objects that provide an interface to the C++ implementation.\cr

  The resulting objects can be used to repeat the mapping using different
  parameter combinations.\cr

  Functions are also provided to specify the manner in which
  dimensionality is reduced;\cr
  \code{parallelDimFactors(...)}\cr
  \code{parallelExpDimFactors(...)},\cr
  and how to plot point positions and
  stress evolution;\cr
  \code{plotPoints(...)}\cr
  \code{plotConcentric(...)}\cr
  \code{plotStress(...)}. 
  
}
\author{
Martin Jakt

Maintainer: Martin Jakt <lmjakt@gmail.com>
}

\references{
  \url{http://martin.jakt.org.uk/r-sod/}\cr
  \url{http://www.gitorious.org/r-sod/}\cr
  If you should use this package in a publication please see the above
  URLs for the appropriate citation.
}
%%~~ Optionally other standard keywords, one per line, from file KEYWORDS in ~~
%%~~ the R documentation directory ~~
\keyword{ package }
\seealso{
\code{\link{DimSqueezer}}\cr 
\code{\link{DimSqueezer_CL}}\cr 
\code{\link{parallelDimFactors}}\cr 
\code{\link{parallelExpDimFactors}}
}

\examples{
%% ~~ simple examples of the most important functions ~~

require(SOD)
\dontrun{
## read in the f186 data set
data("f186", package="SOD")

## f186 contains information about a set of cells. We
## want to use columns 7:12, which contain transcript
## densities to visualise the relationships between the
## cells.
m <- as.matrix( f186[,7:12] )

## Make a normal (openMP) accelarated squeezer object

## use a subset of the rows to reduce the computation time
## for automated checks
r <- 1:200
ds1 <- DimSqueezer$new(m[r,])

## you can also use:
## ds1 <- new("DimSqueezer", m[r,])

## squeeze 200 iterations resulting in a
## 2 dimensional representation.
sq1 <- ds1$squeeze(2, 200)

## Make an openCL accelerated squeezer object
## note this is only available where both the physical
## hardware and the appropriate development environment
## is available.
ds2 <- DimSqueezer_CL$new(m)

## squeeze, 200 iterations using a work group size of 64
## giving a 2 dimensional representation.
sq2 <- ds2$squeeze(2, 200, 64)

## functions to plot the relationships
plotPoints(sq1)

## use columns of f186 to make a more interesting
## plot
plotPoints(sq1, col=hsvScale(f186[r,"Etv2"]), pch=19)
plotPoints(sq1, col=hsvScale(f186[r,"p_Etv2"]), pch=19)

## and a funky plot
plotConcentric(sq1, f186[r,7:12], cex.max=5, pch=19, leg.pos="topleft")

## and to plot the stress mapping.
plotStress(sq1)
}
}
