#' Calculate wasp trips from raw RFID data
#'
#' Calculate wasp trips from raw RFID data. This function is
#' structured for use with the \pkg{data.table} package. In other
#' words, it is meant to be used on a chunk of data (say for one uid),
#' and the argument input format is conducive to working with the
#' \pkg{data.table} package.
#'
#' Note that if there are no trips recorded then the \code{trips}
#' value will be returned as \code{"IGNORE"} and a dummy time in the
#' year 1980 will be returned. This behaviour is required to comply
#' with the \pkg{data.table} package.
#'
#' @param x A data.frame containing columns named \code{uid},
#' \code{address}, and \code{time}. The \code{time} should be in
#' character format and match the format declared to the argument
#' \code{time_format}. \code{uid} should be of type character and
#' \code{address} of type integer.
#' @param time_format Time format to be passed to
#' \code{strptime}.
#' @param diff_address_home First difference value of \code{address}
#' that should correspond to a ways being considered "home".
#' @param diff_address_away First difference value of \code{address}
#' that should correspond to a ways being considered "away".
#' @param print_progress Should the uid be printed? Useful to monitor
#' progress when running this function over large datasets.
#' @param correct_time_stamps Should the time stamps be corrected. The
#' values are currently hard-coded into the function.
#' @return
#' A data.frame containing columns of time, uid, trip type (away or
#' home), and time away or home.
#' @export

get_wasp_trips <- function(x, time_format = "%m/%d/%Y %H:%M:%S",
  diff_address_home = 2, diff_address_away = -2,
  print_progress = TRUE, correct_time_stamps = TRUE) {
  # Print the uid to keep track of progress:
  if(print_progress) message(as.character(x$uid[1]))
  # Take a first difference on the address column:
  x$diff_address <- c(NA, diff(x$address))
  # Set up a new column and set the values all to NA:
  x$trips <- NA
  # Now set all trip values to "home" if the diff_address matches
  # diff_address_home:
  x$trips[x$diff_address == diff_address_home] <- "home"
  # And "away"...
  x$trips[x$diff_address == diff_address_away] <- "away"
  # Remove all rows that weren't home or away:
  x <- x[-which(is.na(x$trips)), ]
  # Remove these columns to save memory:
  x$diff_address <- NULL
  x$address <- NULL
  # If there are any rows to work with, take the first difference of the
  # times. This gives us time between trips:
  if (nrow(x) > 0) {
    x$time <- strptime(x$time, format = time_format)
    if(correct_time_stamps) {
      # Now correct the time stamps:
      actual_time <- strptime("11/05/2013 14:47:10", format = time_format)
      preset_time <- strptime("02/11/2005 05:50:34", format = time_format)
      x$time <- x$time + (actual_time - preset_time)
    }
    x$time_diff <- as.numeric(c(NA, diff(x$time)))
    out <- x
    return(out)
  }
}
