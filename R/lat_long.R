#' Extract latitude and longitude
#'
#' @description
#' A short description...
#'
#' @param parcel A spatial object representing a parcel.
#'
#' @returns
#' A named numeric vector with `latitude` and `longitude`.
lat_long <- function(parcel) {
  # Calculate the centroid of the parcel geometry
  centroid <- st_centroid(parcel)

  # Extract coordinates and return as a vector
  coords <- st_coordinates(centroid)
  return(c(latitude = coords[2], longitude = coords[1]))
}
