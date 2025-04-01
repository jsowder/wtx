#' Surrounding Roads
#'
#' @description
#' A short description...
#'
#' @param parcel A parcel represented as an sf object.
#' @param return One of `'area'`, `'annual cost'`, `'repair cost'`, `'everything'`, or `'table'`.
#' @param buffer_distance A numeric value representing buffer distance. Optional, defaults to 75.
#'
#' @returns
#' Depending on the `return` parameter:
#' - `'area'`: Total area of intersecting roads.
#' - `'annual cost'`: Total annual cost of intersecting roads.
#' - `'repair cost'`: Total repair cost of intersecting roads.
#' - `'everything'`: A summary table.
#' - `'table'`: An sf object of intersecting roads.
#'
#' @export
surrounding_roads <- function(
    parcel
    , return = c('area', 'annual cost', 'repair cost', 'everything', 'table')
    , buffer_distance = 75) {
  # parcel <- parcels %>% filter(PROP_ID == '365915')

  # Buffer the parcel
  parcel_buffer <- st_buffer(parcel, buffer_distance)

  # Find intersecting roads
  intersecting_roads <-
    street_inventory %>%
    st_filter(parcel_buffer) %>%
    st_intersection(parcel_buffer) %>%
    select(any_of(names(street_inventory))) %>%
    mutate(road_length = st_length(.),
           road_area = road_length * RDWIDTH,
           road_cost_annual = road_cost(., annualized = T),
           road_cost_immediate = road_cost(., annualized = F),
    )

  # Summarize based on the selected return type
  summary <-
    intersecting_roads %>%
    summarize(
      total_area = sum(road_area, na.rm = TRUE),
      total_annual_cost = sum(road_cost_annual, na.rm = TRUE),
      total_repair_cost = sum(road_cost_immediate, na.rm = TRUE)
    )

  # Return the appropriate value
  if (return == 'area') {
    return(summary$total_area)
  } else if (return == 'annual cost') {
    return(summary$total_annual_cost)
  } else if (return == 'repair cost') {
    return(summary$total_repair_cost)
  } else if (return == 'everything') {
    return(summary)
  } else {
    return(intersecting_roads)
  }
}
