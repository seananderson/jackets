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
#' @param uid A vector of uid values.
#' @param address A vector of numeric addresses.
#' @param time A vector of times in character format. Should match the
#' format specified in \code{time_format}.
#' @param time_format Time format to be passed to
#' \code{strptime}.
#' @param diff_address_home First difference value of \code{address}
#' that should correspond to a ways being considered "home".
#' @param diff_address_away First difference value of \code{address}
#' that should correspond to a ways being considered "away".
#' @param print_progress Should the uid be printed? Useful to monitor
#' progress when running this function over large datasets.
#' @param correct_time_stamps Should the time stamps be corrected. The
#' values are hardcoded in the function.
#' @return
#' A data.frame containing columns of time, trip type, and time away
#' or home.
#' @export

get_wasp_trips <- function(uid, address, time, time_format =
  "%m/%d/%Y %H:%M:%S", diff_address_home = 2, diff_address_away = -2,
  print_progress = TRUE, correct_time_stamps = TRUE) {
  # Make a data.frame with the arguments:
  x <- data.frame(uid, address, time)
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
  x$uid <- NULL
  # And make a dummy time object that we'll use below
  dummy_time <- strptime("01/01/1980 14:47:10", format = time_format)
  # If there are any rows to work with, take the first difference of the
  # times. This gives us time between trips:
  if (nrow(x) > 0) {
    if(correct_time_stamps) {
      # Now correct the time stamps:
      actual_time <- strptime("11/05/2013 14:47:10", format = time_format)
      preset_time <- strptime("02/11/2005 05:50:34", format = time_format)
      x$time <- x$time + (actual_time - preset_time)
    }
      x$time <- strptime(x$time, format = time_format)

    x$time_diff <- as.numeric(c(NA, diff(x$time)))
    out <- x
  } else {
    # data.table needs a matching data.frame; we'll delete these rows after
    out <- data.frame(time = dummy_time, trips = "IGNORE", time_diff =
      999, stringsAsFactors = FALSE)
    #out$time_diff <- as.numeric(out$time_diff)
  }
  # And return the data frame for this chunk:
  return(out)
}
