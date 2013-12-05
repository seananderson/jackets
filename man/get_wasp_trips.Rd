\name{get_wasp_trips}
\alias{get_wasp_trips}
\title{Calculate wasp trips from raw RFID data}
\usage{
  get_wasp_trips(x,
    time_format = "\%m/\%d/\%Y \%H:\%M:\%S",
    diff_address_home = 2, diff_address_away = -2,
    print_progress = TRUE, add_time = 0)
}
\arguments{
  \item{x}{A data.frame containing columns named
  \code{uid}, \code{address}, and \code{time}. The
  \code{time} should be in character format and match the
  format declared to the argument \code{time_format}.
  \code{uid} should be of type character and \code{address}
  of type integer.}

  \item{time_format}{Time format to be passed to
  \code{strptime}.}

  \item{diff_address_home}{First difference value of
  \code{address} that should correspond to a ways being
  considered "home".}

  \item{diff_address_away}{First difference value of
  \code{address} that should correspond to a ways being
  considered "away".}

  \item{print_progress}{Should the uid be printed? Useful
  to monitor progress when running this function over large
  datasets.}

  \item{add_time}{A quantity of time to add to each time
  recording. Should be in the same format as
  \code{time_format}.}
}
\value{
  A data.frame containing columns of time, uid, trip type
  (away or home), and time away or home.
}
\description{
  Calculate wasp trips from raw RFID data. This function is
  structured for use with the \pkg{dplyr} package. In other
  words, it is meant to be used on a chunk of data (say for
  one uid).
}
\details{
  Note that if there are no trips recorded then the
  \code{trips} value will be returned as \code{"IGNORE"}
  and a dummy time in the year 1980 will be returned. This
  behaviour is required to comply with the \pkg{data.table}
  package.
}

