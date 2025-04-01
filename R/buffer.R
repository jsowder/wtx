#' Create a buffer around geometry
#'
#' @description
#' A short description...
#'
#' @param geometry A geometric object.
#' @param radius Optional. A numeric radius, defaulting to 1.
#' @param center Optional. A geometric center, defaulting to `alico`.
#' @param clean Optional. A logical value indicating whether to cleanly cut the buffer, defaulting to `FALSE`.
#'
#' @returns
#' A buffered geometric object, either intersected with `geometry` for a clean result or retaining full parcels or geometry otherwise.
#'
#' @export
buffer <-
  function(geometry, radius = 1, center = alico, clean = F){
    buffed <-
      center %>%
      st_transform(crs = st_crs(geometry)) %>%
      st_buffer(dist = 5280 * radius)

    # Clean: cut into a clean circle
    # Not clean: keep parcels/geometry whole
    if(clean){
      return(st_intersection(geometry, buffed))
    } else {
      return(geometry[st_intersection(geometry, buffed), ])
    }
  }
