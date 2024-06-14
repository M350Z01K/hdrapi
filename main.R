library(httr2)
library(jsonlite)


meta_url = c('https://hdrdata.org/api/Metadata/',
             'Countries', 
             'Indicators',
             'HDGroups',
             'HDRegions',
             'Dimensions',
             'Indices',
             '?apikey=')



# get_meta = function(value, apikey){
#   url = paste0(meta_url[1], value, meta_url[length(meta_url)], apikey)
#   response = GET(url)
#   if (response$status_code == 200){
#     response = fromJSON(rawToChar(response$content))
#     return(response)
#   } else {
#     print('Error, status code: ', response$status_code)
#   }
#   
# }



get_meta = function(value, apikey){
  
  
  req = request(paste0('https://hdrdata.org/api/Metadata/', value))
  req = req_method(req, 'GET')
  req = req_url_query(req,
                      "apikey" = apikey
                      )
  
  response = req_perform(req)
  
  if (response$status_code == 200){
    response = fromJSON(rawToChar(response$body))
    return(response)
  } else {
    print('Error, status code: ', response$status_code)
  }
}


get_meta('Indicators', HDR_API)





metadata = lapply(meta_url[2:(length(meta_url)-1)], function(meta_item){
  get_meta(meta_item, HDR_API)
})

# TODO : cache the result of the get_meta function upon launching the package
# https://blog.r-hub.io/2021/07/30/cache/


get_hdr_data = function(country_or_aggregation = NULL, year = NULL, indicator = NULL, apikey, query = NULL){
  
  # sanity checks on country
  
  legal_countries = c(metadata[[1]][, 'code'], metadata[[3]][, 'code'], metadata[[4]][, 'code'])
  
  if (!is.null(country_or_aggregation)){
    
    if (any(country_or_aggregation == 'all_countries')){
      
      country_or_aggregation = metadata[[1]][, 'code']
      
    } else if (any(country_or_aggregation == 'all_regions')){
      
      country_or_aggregation = metadata[[4]][, 'code']
      
    } else if (any(country_or_aggregation == 'all_aggregations')){
      
      country_or_aggregation = metadata[[3]][, 'code']
      
    } else if (any(country_or_aggregation %in% legal_countries == T)){
      
      country_or_aggregation = country_or_aggregation
      
    } else {
      
      stop('You provided a wrong value for country_or_aggregation, check possible values in metadata')
      
    }
    
  
    
      
  }
  else {
    
    country_or_aggregation = ''
    
  }
  
  
  
  # sanity checks on year
  
  if (!is.null(year)){
    year_range = seq(1950, 2050, 1)
    if (any(year %in% year_range == T)){
      
      year = year
      
    } else {
      
      stop('You provided a wrong value for year, check possible values in metadata')
      
    }
  }
  else {
    
    year = ''
    
  }
  
  # sanity checks on indicator
  
  legal_ind = c(metadata[[2]][,'code'], metadata[[6]][,'code'])
  
  if (!is.null(indicator)){
    
    if (any(indicator == 'all_indicators')) {
      indicator = metadata[[2]][,'code']
    } else if (any(indicator == 'all_indices')) {
      indicator = metadata[[6]][,'code']
    } else if (any(indicator %in% legal_ind)) {
      indicator = indicator
    } else {
      stop('You provided a wrong value for indicator, check possible values in metadata')
    }
    
  }
  else {
    
    indicator = ''
    
  }
  
  
  if (is.null(query)){
    base = 'https://hdrdata.org/api/CompositeIndices/query'
  } else {
    base = 'https://hdrdata.org/api/CompositeIndices/query-detailed'
  }
  
  
  req = request(base)
  req = req_method(req, 'GET')
  req = req_url_query(req,
                      "apikey" = apikey,
                      "countryOrAggregation" = paste(country_or_aggregation, collapse = ','),
                      "year" = paste(year, collapse = ','),
                      "indicator" = paste(indicator, collapse = ','))
  
  resp = req_perform(req)
  
  if(resp$status_code==200){
    
    
    resp = fromJSON(rawToChar(resp$body))
    
    return(resp)
    
  } else {
    
    print(paste0("Error ", resp$status_code))
    break
  }
  
}

a = get_hdr_data(country_or_aggregation = 'all_countries', apikey = HDR_API, year = 2014, indicator = 'co2_prod', query = 'detailed')
b = get_hdr_data(country_or_aggregation = 'MUS', apikey = HDR_API, year = 2014)
c = get_hdr_data(country_or_aggregation = c('MUS', 'AGO', 'ARE'), apikey = HDR_API, year = c(2014, 2020), indicator = c('abr', 'co2_prod'))
c = get_hdr_data(country_or_aggregation = c('MUS', 'AGO', 'ARE'), apikey = HDR_API, year = 2014)
d = get_hdr_data(country_or_aggregation = 'MUS', apikey = HDR_API, year = 2014)

