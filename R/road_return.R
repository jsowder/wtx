#' Calculate road return values
#'
#' @description
#' A short description...
#'
#' @param roads A spatial object containing roads.
#' @param per_sqft Optional. A logical value indicating whether to return values per square foot. Defaults to `TRUE`.
#' @param annualized Optional. A logical value indicating whether the costs should be annualized. Defaults to `TRUE`.
#' @param just_value Optional. A logical value. If `TRUE`, the function returns only the surrounding values. Defaults to `FALSE`.
#' @param just_revenue Optional. A logical value. If `TRUE`, the function returns only the surrounding revenues. Defaults to `FALSE`.
#'
#' @returns
#' A numeric vector representing the differences between surrounding revenues and road costs for each road. If `per_sqft` is `TRUE`, values are per square foot. The function returns only surrounding values if `just_value` is `TRUE`, or only surrounding revenues if `just_revenue` is `TRUE`.
road_return <- function(
    roads
    , per_sqft = T
    , annualized = T
    , just_value = F
    , just_revenue = F
) {

  # Buffer all roads at once
  road_buffers <- st_buffer(roads, 75, endCapStyle = "FLAT")

  # Find intersecting parcels for each road buffer
  intersections <- st_intersects(wtx_parcel, road_buffers, sparse = FALSE)

  # Calculate surrounding value and revenue for each road
  surrounding_values <- apply(intersections, 2, function(col) {
    sum(parcels$assessed_val[col], na.rm = TRUE)
  })

  if(just_value) return(surrounding_values)

  surrounding_revenues <- surrounding_values * 0.00797753
  if(just_revenue) return(surrounding_revenues)

  # Calculate the cost for each road
  road_costs <- road_cost(roads, annualized = annualized)

  # Compute the difference for each road
  differences <- surrounding_revenues - road_costs

  road_sqfts <- roads$SECTLGTH * roads$ROWWIDTH
  if(per_sqft) differences <- differences / road_sqfts

  return(differences)
}

# Testing
if(FALSE) {
wtx_street_inventory %>%
  head(10) %>%
  mutate(
    cost = road_cost(.),
    return = road_return(., annualized = T)
  ) %>%
  glimpse()
}
