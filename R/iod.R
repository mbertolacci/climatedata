IOD_JAMSTEC_URL = 'http://www.jamstec.go.jp/frcgc/research/d1/iod/DATA/dmi.monthly.txt'
IOD_NOAA_URL = 'https://psl.noaa.gov/gcos_wgsp/Timeseries/Data/dmi.had.long.data'

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

#' @export
load_iod_noaa <- function(source_url = IOD_NOAA_URL) {
    iod_data_lines <- readLines(source_url)
    iod_data_lines[2 : (which(iod_data_lines == '-9999') - 1)]
    iod_data_content <- paste0(
        iod_data_lines[2 : (which(iod_data_lines == '-9999') - 1)],
        collapse = '\n'
    )
    iod_data_raw <- read.table(textConnection(iod_data_content))

    years <- iod_data_raw[, 1]
    subset(data.frame(
        year = rep(years, each = 12),
        month = rep(1 : 12, length(years)),
        dmi = as.vector(as.matrix(iod_data_raw[, -1]))
    ), dmi != -9999)
}

#' Returns Indian Ocean Dipole data. Caches it into filename unless filename is NULL.
#' @export
load_iod <- function(filename = 'iod.rds', data_source = c('noaa', 'jamstec'), ...) {
    data_source <- match.arg(data_source)

    if (!is.null(filename) && file.exists(filename)) {
        return(readRDS(filename))
    }

    data <- list(
        noaa = load_iod_noaa,
        jamstec = load_iod_jamstec
    )[[data_source]](...)

    if (!is.null(filename)) {
        saveRDS(data, filename)
    }

    return(data)
}
