#' Get places around a parcel
#'
#' @description
#' A short description...
#'
#' @param parcel A spatial object representing the parcel.
#' @param radius A numeric value specifying the search radius in meters. Optional.
#' @param first Optional. A logical value.
#' @param wholetable Optional. A logical value.
#'
#' @returns
#' A data frame of places within the parcel. If `first` is TRUE, only the first result is returned. If no places are found and `wholetable` is FALSE, a tibble with "none" values is returned.
#'
#' @export
get_places <- function(
    parcel
    , radius = 100
    , first = TRUE
    , wholetable = FALSE
)
{ # Purpose: get Google Maps around a parcel, then filter to the results actually *within* the parcel.
  input_crs <- st_crs(parcel)

  if(!(input_crs$input == "EPSG:4326")){
    parcel <- parcel %>% st_transform(crs = 4326)
  }

  # Calculate the centroid of the parcel geometry
  centroid <- st_centroid(parcel)

  # Extract coordinates and return as a vector
  coords <- st_coordinates(centroid)
  latlong <- c(latitude = coords[2], longitude = coords[1])

  # Fetch all results if batch mode is off and all_places is NULL
  results <-
    google_places(location = latlong, radius = radius, place_type = "establishment") %>%
    pluck("results")

  if (!is.data.frame(results) & !wholetable) {
    return(tibble(vicinity = "none", name = "none", types = list(c("none", "none")), business_status = "none"))
  }

  # Convert Google Places results to an sf object with coordinates
  results_sf <-
    results %>%
    mutate(
      latitude = .data$geometry$location$lat,
      longitude = .data$geometry$location$lng
    ) %>%
    st_as_sf(coords = c("longitude", "latitude"), crs = st_crs(parcel))

  # Filter results within the parcel boundary
  results_within <-
    st_intersection(results_sf, parcel) %>%
    st_drop_geometry()

  if (!wholetable) {
    results_within <- results_within %>%
      select(vicinity, name, types, business_status)
  }

  if (first) return(head(results_within, 1))
  return(results_within)
}
