#' Calculate road maintenance cost
#'
#' @description
#' A short description...
#'
#' @param road An `sf` object representing the road.
#' @param annualized A logical value. If `TRUE`, returns the annualized maintenance cost; otherwise, returns the short-term cost. Optional.
#' @param measure_length A logical value. If `FALSE`, uses the `SECTLGTH` for calculation instead of the road length. Optional.
#'
#' @returns
#' The calculated cost, either annualized or short-term, as a numeric value.
#'
#' @export
road_cost <- function(
    road
    , annualized = T
    , measure_length = T
){
  # road <- street_inventory %>% filter(Condition == 'Poor') %>% head(1)
  road_area_sqft <- st_length(road) * road$RDWIDTH
  if(measure_length == F) road_area_sqft <- road$SECTLGTH * road$RDWIDTH


  # Maintenance cost estimates based on Waco Trib article: https://wacotrib.com/news/local/government-politics/waco-street-pavement-management-budget/article_ed715b16-c14f-11ef-b02a-27bd95fd3143.html
  cost_short_term <-
    road_area_sqft *
    case_when(
      road$Condition == 'Poor' ~ 540/9
      ,road$Condition == 'Fair' ~ 75/9
      ,road$Condition == 'Good' ~ 24/9
      ,TRUE ~ 1
    ) %>%
    round()

  cost_annualized <-
    road_area_sqft * (
      24/9/6 +     # Microsurfacing/Crack Sealing: Every 5 years, $24/square yard
        75/9/25 +  # Mill/Overlay: Every 25 years, $75/square yard
        540/9/50   # Reconstruction: Every 50 years, $540/square yard
    ) %>%
    round()

  if(annualized) return(cost_annualized)
  else return(cost_short_term)
} %>%
  Vectorize()
