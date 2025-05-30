% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lag_1.R
\name{lag_1}
\alias{lag_1}
\title{lag-1 autocorrelation coefficient}
\usage{
lag_1(
  data = NULL,
  n_sim = 10,
  run_multicore = FALSE,
  win_max = NULL,
  win_min = NULL,
  verbose = FALSE
)
}
\arguments{
\item{data}{Input data set  should consist of a matrix with 2 columns with first column being depth and the second column being a proxy}

\item{n_sim}{number of simulations to be ran}

\item{run_multicore}{Run function using multiple cores \code{Default="FALSE"}}

\item{win_max}{maximum window size}

\item{win_min}{minimum window size}

\item{verbose}{print text}
}
\value{
Returns a matrix which contains 3 columns
column 1: depth/time matrix
column 2: mean autocorrelation coefficient
column 3: sd autocorrelation coefficient
}
\description{
The \code{\link{lag_1}} function calculates the lag-1 autocorrelation coefficient using a windowed analysis
monte carlo analysis
}
\examples{
\donttest{
#The example uses the magnetic susceptibility data set of Pas et al., (2018).
# perform the CWT
mag_wt <- analyze_wavelet(data = mag,
dj = 1/100,
lowerPeriod = 0.1,
upperPeriod = 254,
verbose = FALSE,
omega_nr = 10)

#Track the 405 kyr eccentricity cycle in a wavelet spectra

#mag_track <- track_period_wavelet(astro_cycle = 405,
#                                   wavelet=mag_wt,
#                                   n.levels = 100,
#                                   periodlab = "Period (meters)",
#                                   x_lab = "depth (meters)")

#Instead of tracking, the tracked solution data set mag_track_solution is used
mag_track <- mag_track_solution

mag_track_complete <- completed_series(
  wavelet = mag_wt,
  tracked_curve = mag_track,
  period_up = 1.2,
  period_down = 0.8,
  extrapolate = TRUE,
  genplot = FALSE
)

# smooth the tracking of the 405 kyr eccentricity cycle
mag_track_complete <- loess_auto(time_series = mag_track_complete,
genplot = FALSE, print_span = FALSE)
#convert period in meters to sedrate depth vs time
mag_track_time<- curve2tune(data=mag,
                           tracked_cycle_curve=mag_track_complete,
                           tracked_cycle_period=405,
                           genplot = FALSE,
                           keep_editable=FALSE)

mag_lag_1 <- lag_1(data = mag_track_time,n_sim = 10,
run_multicore = FALSE,
win_max = 505,
win_min = 150,
verbose=FALSE)

}
}
\author{
Michiel Arts
}
