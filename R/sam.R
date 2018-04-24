MARSHALL_SAM_URL = 'http://www.nerc-bas.ac.uk/public/icd/gjma/newsam.1957.2007.txt'
HADSLP2_URL = 'ftp://ftp.cdc.noaa.gov/Datasets.other/hadslp2/slp.mnmean.real.nc'

#' @export
load_sam_marshall <- function(source_url = MARSHALL_SAM_URL) {
    sam_data <- utils::read.csv(source_url, sep = '', skip = 2, stringsAsFactors = FALSE)

    # The data is in the format 'Year, Jan, Feb, ..., Dec', so rename the columns with integers to be used for melt
    colnames(sam_data) <- c('year', 1 : 12)

    sam_data <- reshape2::melt(sam_data, id.vars = 'year', variable.name = 'month')
    sam_data$year <- strtoi(sam_data$year)
    sam_data$month <- strtoi(sam_data$month)
    sam_data <- sam_data[!is.na(sam_data$value), ]
    sam_data <- sam_data[order(sam_data$year, sam_data$month), ]
    rownames(sam_data) <- 1 : nrow(sam_data)

    return(sam_data)
}

#' @export
load_sam_hadslp2 <- function(reference_period = c('1961-01-01', '1991-01-01'), source_url = HADSLP2_URL, hadslp2_path = NULL) {
    if (is.null(hadslp2_path)) {
        hadslp2_path <- tempfile(fileext = '.nc')
        utils::download.file(source_url, hadslp2_path, quiet = FALSE)
    }
    hadslp2 <- raster::brick(hadslp2_path)

    # Split zones based on latitude
    hadslp2_zones <- hadslp2[[1]]
    raster::values(hadslp2_zones) <- sp::coordinates(hadslp2)[, 2]

    # Calculate zonal means
    hadslp2_zonal_mslp <- raster::zonal(hadslp2, hadslp2_zones, mean)
    zones <- hadslp2_zonal_mslp[, 1]
    hadslp2_zonal_mslp <- hadslp2_zonal_mslp[, 2 : ncol(hadslp2_zonal_mslp)]

    # Calculate SAM
    normalise <- function(x, dates) {
        reference_x <- x[dates >= reference_period[1] & dates < reference_period[2]]
        return((x - mean(reference_x)) / stats::sd(reference_x))
    }
    sam_dates <- strptime(colnames(hadslp2_zonal_mslp), 'X%Y.%m.%d', tz = 'UTC')
    sam_values <- (
        normalise(hadslp2_zonal_mslp[zones == -40, ], sam_dates) -
        normalise(hadslp2_zonal_mslp[zones == -65, ], sam_dates)
    )

    return(data.frame(
        date = sam_dates,
        year = as.integer(strftime(sam_dates, '%Y')),
        month = as.integer(strftime(sam_dates, '%m')),
        value = sam_values
    ))
}

#' Returns Southern Annular Mode data. Caches it into filename unless filename is NULL.
#' @export
load_sam <- function(filename = 'sam.rds', data_source = 'marshall', ...) {
    stopifnot(data_source %in% c('marshall', 'hadslp2'))

    if (!is.null(filename) && file.exists(filename)) {
        return(readRDS(filename))
    }

    if (data_source == 'marshall') {
        data <- load_sam_marshall(...)
    } else {
        data <- load_sam_hadslp2(...)
    }

    if (!is.null(filename)) {
        saveRDS(data, filename)
    }

    return(data)
}
