## code to prepare `metadata` dataset goes here
library(httr2)
library(jsonlite)
library(hdrapi)

meta_values = c(
  'Countries', 
  'Indicators',
  'HDGroups',
  'HDRegions',
  'Dimensions',
  'Indices'
)

metadata = lapply(meta_values, function(meta_item){
  get_meta(value = meta_item, apikey = HDR_API)
})

names(metadata) = meta_values
usethis::use_data(metadata, overwrite = TRUE)
