test_that("output is a df", {
  is.data.frame(get_hdr_data(country_or_aggregation = 'MUS',
               year = seq(1990, 2020),
               indicator = 'abr',
               apikey = HDR_API))
})


