#' Fetch data from HDR API
#'
#' @param country_or_aggregation 
#' @param year numeric
#' @param indicator str
#' @param apikey str
#' @param query default NULL, else 'detailed' for complete information
#'
#' @return a dataframe
#' @export
#'
#' @examples
#' get_hdr_data(country_or_aggregation = 'all_countries', apikey = HDR_API, indicator = 'co2_prod', query = 'detailed')
get_hdr_data = function(country_or_aggregation = NULL, year = NULL, indicator = NULL, apikey, query = NULL){
  
  metadata = readRDS('data/metadata.rds')
  
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
      
      stop('You provided a wrong value for year, range is [1950:2050]')
      
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
  
  req = httr2::request(base)
  
  req = httr2::req_method(req, 'GET')
  
  req = httr2::req_url_query(req,
                            "apikey" = apikey,
                            "countryOrAggregation" = paste(country_or_aggregation, collapse = ','),
                            "year" = paste(year, collapse = ','),
                            "indicator" = paste(indicator, collapse = ','))
  
  resp = httr2::req_perform(req)
  
  if(resp$status_code==200){
    
    resp = jsonlite::fromJSON(rawToChar(resp$body))
    
    return(resp)
    
  } else {
    
    stop(paste0("Error ", resp$status_code))
  
  }
  
}
