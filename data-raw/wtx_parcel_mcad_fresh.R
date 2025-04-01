library(httr)
library(jsonlite)

fetch_mcad <- function(type = c('Real', 'Personal'), year = 2024, page = 1, pagesize = 10000, just_data = T) {

  url <- paste0(
    "https://esearch.mclennancad.org/search/SearchResults?keywords=",
    "PropertyType%3A", type,
    "%20Year%3A", year,
    "&page=", page,
    "&pagesize=", pagesize,
    "&recaptchaToken=&sort=PropertyId%20asc")

  response <- GET(url,
                  add_headers(
                    `Accept` = "*/*",
                    `Sec-Fetch-Site` = "same-origin",
                    `Referer` = "https://esearch.mclennancad.org/search/result?keywords=PropertyType%3AReal%20Year%3A2024",
                    `Sec-Fetch-Dest` = "empty",
                    `Sec-Fetch-Mode` = "cors",
                    `Accept-Language` = "en-US,en;q=0.9",
                    `Accept-Encoding` = "gzip, deflate, br",
                    `User-Agent` = "Mozilla/5.0"
                  ))

  result <- fromJSON(content(response, "text"))
  data <- result$resultsList

  if(just_data) return(data) else return(result)

}

fetch_mcad_all_pages <- function(type = c('Real', 'Personal'), year = 2024){
  all_data <<- list()
  first_result <<- fetch_mcad(year = year, type = type, just_data = F)
  total_pages <<- first_result$totalPages
  all_data[[1]] <<- first_result$resultsList

  if(total_pages > 1){
    for (page in 2:total_pages) {
      all_data[[page]] <<- fetch_mcad(year = year, type = type, page = page)
      message(paste("Page", page, "of", total_pages, "fetched."))
    }}

  result_df <- bind_rows(all_data, .id = 'page_number')
  return(result_df)
}

fetch_mcad_everything <- function(year = 2024){
  print('Fetching Personal Property')
  pers <- fetch_mcad_all_pages(type = 'Personal', year = year)
  print('Fetching Real Property')
  real <- fetch_mcad_all_pages(type = 'Real', year = year)

  result_df <- bind_rows(pers, real)
  return(result_df)
}

wtx_parcel_mcad_fresh <-
  fetch_mcad_everything(year = 2024) %>%
  type_convert() %>%
  select(-page_number) %>%
  rename(prop_id = propertyId)

usethis::use_data(wtx_parcel_mcad_fresh, overwrite = TRUE)
