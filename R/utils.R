.add_lag <- function(year, month, lag) {
    month <- month - 1
    if (month + lag > 11) {
        year <- year + floor((month + lag) / 12)
    }
    month <- (month + lag) %% 12
    return(c(year, month + 1))
}

#' @export
get_for_dates <- function(data, dates, lag = 0) {
    data_dates <- cbind(data$year, data$month)
    for (i in 1 : nrow(data_dates)) {
        data_dates[i, ] <- .add_lag(data_dates[i, 1], data_dates[i, 2], lag)
    }
    data[match(
        100 * (dates$year + 1900) + dates$mon + 1,
        100 * data_dates[, 1] + data_dates[, 2]
    ), ]
}
