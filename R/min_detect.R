#' @title Detect and filter out all minima in a signal
#'
#' @description The \code{\link{min_detect}} function is used to detect and
#' filter out local minima in a sinusoidal signal
#'
#'
#' @param data Matrix or data frame with first column being depth or time and
#' the second column being a proxy
#' @param pts the pts parameter specifies how many points to the left/right up/down the peak detect algorithm goes in detecting
#'a peak. The peak detecting algorithm works by comparing the values left/right up/down of it, if the values are both higher or lower
#'then the value a peak. To deal with error produced by this algorithm the pts parameter can be changed which can
#'aid in peak detection. Usually increasing the pts parameter means more peak certainty, however it also means that minor peaks might not be
#'picked up by the algorithm \code{Default=3}
#'
#'@examples
#'#Example in which the ~210yr de Vries cycle is extracted from the Total Solar
#'#Irradiance data set of Steinhilber et al., (2012)
#'#after which all minima are extracted
#'
#'TSI_wt <-
#'analyze_wavelet(
#'data = TSI,
#'dj = 1/200,
#'lowerPeriod = 16,
#'upperPeriod = 8192,
#'    verbose = FALSE,
#'    omega_nr = 6
#'  )
#'
#'de_Vries_cycle <- extract_signal_stable(wavelet=TSI_wt,
#'cycle=210,
#'period_up =1.25,
#'period_down = 0.75,
#'add_mean=TRUE,
#'plot_residual=FALSE)
#'
#'
#'min_de_Vries_cycle <- min_detect(de_Vries_cycle)
#'
#'@return
#'#Returns a matrix with 2 columns
#'first column is depth/time
#'the second column are local minima values
#'
#' @export

min_detect <- function(data = NULL,pts=3) {
  astro_mindetect <- as.data.frame(data)
  astro_mindetect$min <- 0
  for (i in pts:(nrow(data) - pts)) {
    if ((data[i, 2] - data[(i + pts), 2] < 0) &
        (data[i, 2] - data[(i - (pts-1)), 2] < 0))
    {
      astro_mindetect[i, 3] <- 1
    }
  }

  astro_mindetect_error_corr <- astro_mindetect
  astro_mindetect_error_corr <-
    astro_mindetect_error_corr[astro_mindetect_error_corr$min == 1 ,]

  astro_maxdetect <- as.data.frame(data)
  astro_maxdetect$max <- 0
  for (i in pts:(nrow(data) - pts)) {
    if ((data[i, 2] - data[(i + pts), 2] > 0) &
        (data[i, 2] - data[(i - (pts-1)), 2]  > 0))
    {
      astro_maxdetect[i, 3] <- 1
    }
  }

  astro_maxdetect_error_corr <- astro_maxdetect
  astro_maxdetect_error_corr <-
    astro_maxdetect_error_corr[astro_maxdetect_error_corr$max == 1 ,]

  max <- astro_maxdetect_error_corr
  colnames(max) <- c("A", "B", "C")
  min <- astro_mindetect_error_corr
  colnames(min) <- c("A", "B", "C")

  min[, 3] <- -1
  peaks <- rbind(max, min)

  peaks <- peaks[order(peaks[, 1]), ]
  i <- 1
  res_rownr <- nrow(peaks)

  while (i < res_rownr) {
    if ((i < res_rownr) & (peaks[i, 3] == peaks[(i + 1), 3])) {
      if ((i < res_rownr) &(peaks[i, 3]  == 1 & peaks[(i + 1), 3] == 1) &
          (peaks[i, 2] > peaks[(i + 1), 2])) {
        peaks[(i + 1), ] <- NA
        peaks <- na.omit(peaks)
        res_rownr <- res_rownr - 1
      }
      if ((i < res_rownr) &(peaks[i, 3]  == 1 & peaks[(i + 1), 3] == 1) &
          (peaks[i, 2] < peaks[(i + 1), 2])) {
        peaks[i, ] <- NA
        peaks <- na.omit(peaks)
        res_rownr <- res_rownr - 1
      }
      if ((i < res_rownr) &(peaks[i, 3] == -1 & peaks[(i + 1), 3] == -1) &
          (peaks[i, 2] < peaks[(i + 1), 2])) {
        peaks[(i + 1), ] <- NA
        peaks <- na.omit(peaks)
        res_rownr <- res_rownr - 1
      }
      if ((i < res_rownr) &(peaks[i, 3] == -1 & peaks[(i + 1), 3] == -1) &
          (peaks[i, 2] > peaks[(i + 1), 2])) {
        peaks[i, ] <- NA
        peaks <- na.omit(peaks)
        res_rownr <- res_rownr - 1

      }
    }
    if ((peaks[i, 3] != peaks[(i + 1), 3]) |
        is.na(peaks[i, 3] != peaks[(i + 1), 3])) {
      i <- i + 1
    }

  }

  peaks_min <- peaks[peaks[, 3] < 0,]
  return(peaks_min)

}
