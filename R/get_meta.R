library(httr2)
library(jsonlite)

#' Title
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