#' Calculate wasp trips from raw RFID data
#' 
#' Calculate wasp trips from raw RFID data. This function is structured for
#' use with the \pkg{dplyr} package. In other words, it is meant to be used on
#' a chunk of data (say for one uid).
#' 
#' Note that if there are no trips recorded then the \code{trips} value will
#' be returned as \code{"IGNORE"} and a dummy time in the year 1980 will be
#' returned. This behaviour is required to comply with the \pkg{data.table}
#' package.
#' 
#' @param x A data.frame containing columns named \code{uid}, \code{address},
#'   and \code{time}. The \code{time} should be in character format and match
#'   the format declared to the argument \code{time_format}. \code{uid} should
#'   be of type character and \code{address} of type integer.
#' @param time_format Time format to be passed to \code{strptime}.
#' @param diff_address_home First difference value of \code{address} that
#'   should correspond to a ways being considered "home".
#' @param diff_address_away First difference value of \code{address} that
#'   should correspond to a ways being considered "away".
#' @param print_progress Should the uid be printed? Useful to monitor progress
#'   when running this function over large datasets.
#' @param add_time A quantity of time to add to each time recording. Should be
#'   in the same format as \code{time_format}.
#' @return A data.frame containing columns of time, address, uid, diff_address, trip (away or 
#' home), and time_diff (time difference in seconds).
#' @export

get_wasp_trips <- function(x, time_format = "%m/%d/%Y %H:%M:%S",
  diff_address_home = 2, diff_address_away = -2,
  print_progress = TRUE, add_time = 0) {
  # Print the uid to keep track of progress:
  if(print_progress) message(as.character(x$uid[1]))
  # Take a first difference on the address column:
  x$diff_address <- c(NA, diff(x$address))
  # Set up a new column and set the values all to NA:
  x$trip <- NA
  # Now set all trip values to "home" if the diff_address matches
  # diff_address_home:
  x$trip[x$diff_address == diff_address_home] <- "home"
  # And "away"...
  x$trip[x$diff_address == diff_address_away] <- "away"
  # Remove all rows that weren't home or away:
  x <- x[-which(is.na(x$trip)), ]
  # If there are any rows to work with, take the first difference of the
  # times. This gives us time between trips:
  if (nrow(x) > 0) {
    x$time <- as.POSIXct(strptime(x$time, format = time_format))
    x$time <- x$time + add_time
    x$time_diff <- as.numeric(c(NA, diff(lubridate::seconds(x$time))))
    out <- x
    return(out)
  }
}
