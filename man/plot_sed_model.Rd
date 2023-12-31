% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_sed_model.R
\name{plot_sed_model}
\alias{plot_sed_model}
\title{Plot sedimentation modelling results}
\usage{
plot_sed_model(
  model_results = NULL,
  plot_res = 1,
  x_lab = "depth (m)",
  y_lab = "sed rate cm/kyr",
  keep_editable = FALSE,
  palette_name = "rainbow",
  color_brewer = "grDevices"
)
}
\arguments{
\item{model_results}{Wavelet object created using the \code{\link{analyze_wavelet}} function}

\item{plot_res}{Numbers to be used as input form the \code{\link{flmw}}output
options 1-8 option 1: slope coefficient, option 2: r squared,
option 3: nr of components, option 4: difference to origin, option 5: slope coefficient percentile
option 6: r squared percentile, option 7: nr of components percentile,
option 8: difference to origin percentile. If the output of the  \code{\link{sum_power_sedrate}} function is used
then input should be option 1: sum max power option 2: nr of components}

\item{x_lab}{Label for x-axis \code{Default="depth (m)"}}

\item{y_lab}{Label for y-axis \code{Default=""sed rate cm/kyr""}}

\item{keep_editable}{Keep option to add extra features after plotting  \code{Default=FALSE}}

\item{palette_name}{Name of the color palette which is used for plotting.
The color palettes than can be chosen depends on which the R package is specified in
the color_brewer parameter. The included R packages from which palettes can be chosen
from are; the 'RColorBrewer', 'grDevices', 'ColorRamps' and 'Viridis' R packages.
There are many options to choose from so please
read the documentation of these packages \code{Default=rainbow}.
The R package 'viridis' has the color palette options: “magma”, “plasma”,
“inferno”, “viridis”, “mako”, and “rocket”  and “turbo”
To see the color palette options of the The R pacakge 'RColorBrewer' run
the RColorBrewer::brewer.pal.info() function
The R package 'colorRamps' has the color palette options:"blue2green",
"blue2green2red", "blue2red",    "blue2yellow", "colorRamps",    "cyan2yellow",
"green2red", "magenta2green", "matlab.like", "matlab.like2" and    "ygobb"
The R package 'grDevices' has the built in  palette options:"rainbow",
"heat.colors", "terrain.colors","topo.colors" and "cm.colors"
To see even more color palette options of the The R pacakge 'grDevices' run
the grDevices::hcl.pals() function}

\item{color_brewer}{Name of the R package from which the color palette is chosen from.
The included R packages from which palettes can be chosen
are; the RColorBrewer, grDevices, ColorRamps and Viridis R packages.
There are many options to choose from so please
read the documentation of these packages. "\code{Default=grDevices}}
}
\value{
Returns a plot of sedimentation rates vs depth and a value which was generated using
the \code{\link{flmw}} or \code{\link{sum_power_sedrate}} functions
}
\description{
The \code{\link{plot_sed_model}} function is used plot/re-plot the results from the
\code{\link{flmw}} and  \code{\link{sum_power_sedrate}} functions
}
\examples{
\donttest{
#estimate sedimentation rate for the the magnetic susceptibility record
# of the Sullivan core of Pas et al., (2018).

mag_wt <- analyze_wavelet(data = mag,
dj = 1/100,
lowerPeriod = 0.1,
upperPeriod = 254,
verbose = FALSE,
omega_nr = 10)

#increase n_simulations to better define the red noise spectral power curve
mag_wt_red_noise <- model_red_noise_wt(wavelet=mag_wt,
n_simulations=10, # increase for a better constrained result
run_multicore=FALSE,
verbose=FALSE)

sedrates <- sum_power_sedrate(red_noise=mag_wt_red_noise,
wavelet=mag_wt,
percentile=0.75,
sedrate_low = 0.5,
sedrate_high = 4,
spacing = 0.05,
cycles = c(2376,1600,1180,696,406,110),
x_lab="depth",
y_lab="sedrate",
run_multicore=FALSE,
genplot = FALSE,
palette_name = "rainbow",
color_brewer= "grDevices",
verbose=FALSE)

plot_sed_model(model_results=sedrates,
plot_res=1,
x_lab = "depth (m)",
y_lab = "sed rate cm/kyr",
keep_editable=FALSE,
palette_name = "rainbow",
color_brewer= "grDevices")
}


}
