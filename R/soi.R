BOM_SOI_URL = 'ftp://ftp.bom.gov.au/anon/home/ncc/www/sco/soi/soiplaintext.html'

#' @export
load_soi_bom <- function(source_url = BOM_SOI_URL) {
    soi_html <- xml2::read_html(source_url)

    # HACK(mike): can't find a way to use namespace:: syntax with an infix operator, so import it this way
    `%>%` <- rvest::`%>%`
    soi_pre <- soi_html %>% rvest::html_node('pre') %>% rvest::html_text()

    soi_data <- utils::read.csv(textConnection(soi_pre), sep = '', stringsAsFactors=FALSE)
    # The data is in the format 'Year, Jan, Feb, ..., Dec', so rename the columns with integers to be used for melt
    colnames(soi_data) <- c('year', 1 : 12)

    soi_data <- reshape2::melt(soi_data, id.vars = 'year', variable.name = 'month')
    soi_data$year <- strtoi(soi_data$year)
    soi_data$month <- strtoi(soi_data$month)

    soi_data <- soi_data[!is.na(soi_data$value), ]
    soi_data <- soi_data[order(soi_data$year, soi_data$month), ]

    return(soi_data)
}

#' Returns Southern Ocean Oscillation data. Caches it into filename unless filename is NULL.
#' @export
load_soi <- function(filename = 'soi.rds', data_source = 'bom', ...) {
    stopifnot(data_source == 'bom')

    if (!is.null(filename) && file.exists(filename)) {
        return(readRDS(filename))
    }

    data <- load_soi_bom(...)

    if (!is.null(filename)) {
        saveRDS(data, filename)
    }

    return(data)
}