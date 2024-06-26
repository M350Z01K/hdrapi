#' Get metadata from the human development report API
#'
#' @param value one from 'Countries', 'Indicators', 'HDGroups', 'HDRegions', 'Dimensions','Indices'
#' @param apikey str
#'
#' @return a dataframe
#' @export
#'
#' @examples 
#' country_list = get_meta(value = 'Countries', apikey = HDR_API)
#' 
#' 
get_meta = function(value, apikey){
  
  req = httr2::request(paste0('https://hdrdata.org/api/Metadata/', value))
  
  req = httr2::req_method(req, 'GET')
  
  req = httr2::req_url_query(req,
                             "apikey" = apikey
  )
  
  response = httr2::req_perform(req)
  
  if (response$status_code == 200){
  
      response = jsonlite::fromJSON(rawToChar(response$body))
    
      return(response)
      
  } else {
    
    print('Error, status code: ', response$status_code)
    
  }
}