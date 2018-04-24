.add_lag <- function(year, month, lag) {
    month <- month - 1
    if (month + lag > 11) {
        year <- year + floor((month + lag) / 12)
    }
    month <- (month + lag) %% 12
    return(c(year, month + 1))
}

#' Get rows for the given dates
#'
#' Returns rows matching the provided dates.
#'
#' @param data Data, typically loaded using load_soi/iod/sam, for which the
#' first column is an integer year and the second column is an integer month
#' @param dates Dates to grab corresponding rows for. Can be any type
#' supporting the format command (e.g., Date, POSIXlt, POSIXct)
#' @param lags Number of months to lag matching. For instance, lag = 1
#' corresponds to matching to date to the previous month in the data.
#' @export
get_for_dates <- function(data, dates, lag = 0) {
    data_dates <- cbind(data$year, data$month)
    for (i in 1 : nrow(data_dates)) {
        data_dates[i, ] <- .add_lag(data_dates[i, 1], data_dates[i, 2], lag)
    }
    data[match(
        format(dates, '%Y-%m'),
        sprintf('%04d-%02d', data_dates[, 1], data_dates[, 2])
    ), ]
}
