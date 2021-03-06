% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{get_for_dates}
\alias{get_for_dates}
\title{Get rows for the given dates}
\usage{
get_for_dates(data, dates, lag = 0)
}
\arguments{
\item{data}{Data frame, typically loaded using load_soi/iod/sam, which has
integer year and month columns.}

\item{dates}{Dates to grab corresponding rows for. Can be any type
supporting the format command (e.g., Date, POSIXlt, POSIXct)}

\item{lags}{Number of months to lag matching. For instance, lag = 1
corresponds to matching to date to the previous month in the data.}
}
\description{
Returns rows matching the provided dates.
}
