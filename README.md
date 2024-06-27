
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Easily access the Human Develpment Report Data via API

## Installation

You can install the development version of hdrapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("M350Z01K/hdrapi")
```

API documentation:
<https://hdr.undp.org/data-center/documentation-and-downloads>

API GitHub: [HDRData](https://github.com/HDRData/api)

``` r
library(hdrapi)
```

## Get your API key

Described in the following
[manual](https://hdr.undp.org/sites/default/files/2023-24_HDR/HDRO_data_api_manual.pdf)

Store your api key in your `.Rprofile` as described
[here](https://stackoverflow.com/questions/37700436/how-to-store-api-key-in-rprofile)

## API overview

Get a list of all indicators and search for a keyword:

``` r
indicator_list = get_meta(value = 'Indicators',apikey =HDR_API)

indicator_list[grep('education', indicator_list$name, ignore.case = T),]
#>    code
#> 48 se_f
#> 49 se_m
#>                                                                               name
#> 48 Population with at least some secondary education, female (% ages 25 and older)
#> 49   Population with at least some secondary education, male (% ages 25 and older)
```

Get a list the countries and their isocodes. Search the code for a
particular country (must be spelled right)

``` r
country_list = get_meta(value = 'Countries', apikey = HDR_API)

country_list[grep('mauritius', country_list$name, ignore.case = T),]
#>     code      name
#> 123  MUS Mauritius
```

More information can be extracted by using the following values
`HDGroups`, `HDRegions`, `Dimensions`, `Indices`

## Query examples

``` r
get_hdr_data(country_or_aggregation = 'all_countries',
             apikey = HDR_API,
             indicator = 'co2_prod',
             query = 'detailed')
```

Extract Adolescent Birth Rate and CO2 emissions for years 2014 and 2020
for Mauritius, Angola, and the United Arab Emirates

``` r
get_hdr_data(country_or_aggregation = c('MUS', 'AGO', 'ARE'),
             apikey = HDR_API,
             year = c(2014, 2020),
             indicator = c('abr', 'co2_prod'))
```

Extract all indicators for Mauritius (iso3: MUS) in year 2014

``` r
get_hdr_data(country_or_aggregation = 'MUS',
             apikey = HDR_API,
             year = 2014)
```

Since no data is available for the year 1950, the following query
returns an empty list

``` r
get_hdr_data(country_or_aggregation = 'MUS',
             apikey = HDR_API,
             year = 1950)
```
