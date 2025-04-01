#' Standard filter on geometry
#'
#' @description
#' A short description...
#'
#' @param geometry A spatial object.
#'
#' @returns
#' A filtered spatial object with additional area calculations. The object is filtered
#' to include only those with an area greater than 1000 square feet, exclude certain
#' zoning types, and exclude certain land use plans.
#'
#' @export
filter_standard <-
  function(geometry){
    geometry %>%
      mutate(
        area_sq_feet = as.numeric(st_area(.))
        ,area_sq_miles = area_sq_feet / 27878400
        ,area_acres = area_sq_feet / 43560
      ) %>%
      filter(area_sq_feet > 1000) %>%
      filter(!ZONING %in% c('STATE', NULL)) %>%
      filter(!LANDUSEPLA %in% c('Open Space'))
  }
