#' Update RSS Feed
#'
#' @description
#' Waco uses IQM2 for hosting meeting agendas, etc.
#' This is being retired in 2027, so they will move on to another service. Hopefully Legistar,
#' because there's already packages for scraping that
#'
#' @param rss_url A single string representing the URL of the RSS feed.
#'
#' @returns
#' A tibble containing the RSS feed data with documents extracted from descriptions.
#'
#' @export
rss_update <- function(rss_url){

  get_documents <- function(desc){
    agendas <-
      desc %>%
      read_html() %>%
      html_elements('a')

    tibble(
      name = agendas %>% html_text2(),
      link = agendas %>% html_attr('href')
    ) %>%
      deframe()
  }

  rss_data <-
    rss_url %>%
    tidyfeed(clean_tags = F) %>%
    rowwise() %>%
    mutate(documents = list(item_description %>% get_documents())) %>%
    unnest_wider(documents)

  return(rss_data)

}

# rss_url <- "https://wacocitytx.iqm2.com/Services/RSS.aspx?Feed=Calendar&Group=1047"
# main <- rss_update("https://wacocitytx.iqm2.com/Services/RSS.aspx?Feed=Calendar")
# council <-rss_update("https://wacocitytx.iqm2.com/Services/RSS.aspx?Feed=Calendar&Group=1000")
# plan <- rss_update("https://wacocitytx.iqm2.com/Services/RSS.aspx?Feed=Calendar&Group=1047")
