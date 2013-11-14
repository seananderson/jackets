\name{get_wasp_trips}
\alias{get_wasp_trips}
\title{Calculate wasp trips from raw RFID data}
\usage{
  get_wasp_trips(uid, address, time,
    time_format = "\%m/\%d/\%Y \%H:\%M:\%S",
    diff_address_home = 2, diff_address_away = -2,
    print_progress = TRUE)
}
\arguments{
  \item{uid}{A vector of uid values.}

  \item{address}{A vector of numeric addresses.}

  \item{time}{A vector of times in character format. Should
  match the format specified in \code{time_format}.}

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
}
\value{
  A data.frame containing columns of time, trip type, and
  time away or home.
}
\description{
  Calculate wasp trips from raw RFID data. This function is
  structured for use with the \pkg{data.table} package. In
  other words, it is meant to be used on a chunk of data
  (say for one uid), and the argument input format is
  conducive to working with the \pkg{data.table} package.
}
\details{
  Note that if there are no trips recorded then the
  \code{trips} value will be returned as \code{"IGNORE"}
  and a dummy time in the year 1980 will be returned. This
  behaviour is required to comply with the \pkg{data.table}
  package.
}

