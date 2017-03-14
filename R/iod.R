IOD_JAMSTEC_URL = 'http://www.jamstec.go.jp/frcgc/research/d1/iod/DATA/dmi.monthly.txt'

#' @export
load_iod_jamstec <- function(source_url = IOD_JAMSTEC_URL) {
    iod_data_raw <- utils::read.csv(source_url, sep='', stringsAsFactors=FALSE)

    # The date format is '1870:1:16:0'
    dates <- t(sapply(strsplit(iod_data_raw$Date, ':'), function(date_parts) {
        strtoi(unlist(date_parts)[1 : 2])
    }))

    data.frame(
        year = dates[, 1],
        month = dates[, 2],
        west = iod_data_raw$West,
        east = iod_data_raw$East,
        dmi = iod_data_raw$DMI..West.East.
    )
}

#' Returns Indian Ocean Dipole data. Caches it into filename unless filename is NULL.
#' @export
load_iod <- function(filename = 'iod.rds', data_source = 'jamstec', ...) {
    stopifnot(data_source == 'jamstec')

    if (!is.null(filename) && file.exists(filename)) {
        return(readRDS(filename))
    }

    data <- load_iod_jamstec(...)

    if (!is.null(filename)) {
        saveRDS(data, filename)
    }

    return(data)
}