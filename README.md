# climatedata

This is a package that simplifies downloading a few climate indices.

## Installation

This package is not in CRAN right now. Just install using devtools and github

    devtools::install_github('mbertolacci/climatedata')

## Usage

This package helps you download a few climate indices for use in data analysis. At present, indices for the [Indian Ocean Dipole](http://www.jamstec.go.jp/frsgc/research/d1/iod/iod/dipole_mode_index.html), the [Southern Oscillation Index](http://www.bom.gov.au/climate/current/soi2.shtml), and the [Southern Annular Mode](http://www.bom.gov.au/climate/enso/history/ln-2010-12/SAM-what.shtml) are supported.

### Overview

There are three functions for download data, `load_iod`, `load_soi` and `load_sam`. Common to each of these is an argument named `filename` (defaults described for each call), wherein the downloaded data will be cached so that subsequent calls to this function do not require internet connectivity. This behaviour can be disabled by setting `filename = NULL`.

### Indian Ocean Dipole (via the Dipole Mode Index provided by [JAMSTEC](http://www.jamstec.go.jp/frsgc/research/d1/iod/iod/dipole_mode_index.html))

To download this index, call

    iod_data <- climatedata::load_iod()

This will also create a file in the working directory, 'iod.rds', caching this data, so subsequent calls do not go to the server (see Overview for more details).

### Southern Oscillation Index (via the [Australian Bureau of Meteorology](http://www.bom.gov.au/climate/current/soi2.shtml))

To download this index, call

    soi_data <- climatedata::load_soi()

This will also create a file in the working directory, 'soi.rds', caching this data, so subsequent calls do not go to the server (see Overview for more details).

### Southern Annular Mode (either the [Marshall index](https://legacy.bas.ac.uk/met/gjma/sam.html), or calculated from [HadSLP2](http://www.metoffice.gov.uk/hadobs/hadslp2/))

To download this index, call

    sam_data <- climatedata::load_sam(data_source = 'marshall')

for the Marshall index, and

    sam_data <- climatedata::load_sam(data_source = 'hadslp2')

for the HadSLP2 source, where the latter is calculated as per Gong and Wang (1999).
