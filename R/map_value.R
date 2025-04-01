#' Map value
#'
#' @description
#' A short description...
#'
#' @param data A spatial data object.
#' @param value_column A single string. Optional. Default is 'val_per_acre'.
#' @param tooltip_column A single string. Optional.
#' @param map_center A numeric vector of length 2. Optional.
#' @param zoom A single numeric value. Optional.
#' @param pitch A single numeric value. Optional.
#' @param bearing A single numeric value. Optional.
#' @param legend_title A single string. Optional.
#'
#' @returns
#' The function generates a map visualizing the data.
#'
#' @export
map_value <-
  function(
    data
    , value_column = 'val_per_acre'
    , tooltip_column = NULL
    , map_center = NULL
    , zoom = 12
    , pitch = 80
    , bearing = 270
    , legend_title = NULL
  ) {

    mapdeck::set_token(Sys.getenv("MAPBOX_TOKEN"))

    # Define the custom color matrix with alpha (opacity)
    opacity <- 200
    custom_palette_matrix <- matrix(
      c(
        0, 128, 0, opacity,    # Green
        255, 255, 0, opacity,  # Yellow
        255, 165, 0, opacity,  # Orange
        255, 0, 0, opacity,    # Red
        128, 0, 128, opacity   # Purple
      ),
      ncol = 4,
      byrow = TRUE
    )

    # Determine default map center based on the centroid of the dataset
    if (is.null(map_center)) {
      # Default to the centroid of the data
      map_center <-
        sf::st_centroid(sf::st_union(sf::st_geometry(data))) %>%
        sf::st_transform(crs = 4326) %>%
        sf::st_coordinates() %>%
        as.numeric()
    }

    if (is.null(legend_title)){legend_title <- value_column}

    # Format Legend Dollars
    legend_format <- function(value) {
      value <- as.numeric(value)  # Ensure value is numeric
      # paste0("$", format(floor(value / 5e6) * 5e6, big.mark = ",")) # Round down to nearest 5 million
      paste0("$", round(value / 5e6) * 5, "M")  # Round to nearest 5M and format as $5M, $10M, etc.
    }

    # Create tooltips with formatted values and owner names
    format_value <- function(value) {
      value <- as.numeric(value)  # Ensure value is numeric
      paste0("$", round(value / 1e6, 2), "M")  # Format as $0.3M, $5.2M, etc.
    }

    if (is.null(tooltip_column)){
      data <-
        data %>%
        mutate(tooltip_me = paste0(format_value(!!rlang::sym(value_column)), " - ", coalesce(`Property Name`, ownerName), " ", address))
    } else {
      data <-
        data %>%
        mutate(tooltip_me = paste0(format_value(!!rlang::sym(value_column)), " - ", !!rlang::sym(tooltip_column)))
    }

    data <- data %>%
      filter(unmapped == FALSE) %>%
      sf::st_cast("MULTIPOLYGON") %>%
      sf::st_transform(4326) %>%
      sf::st_make_valid()

    # Create the map
    mapdeck::mapdeck(
      style = mapdeck_style("dark"),
      location = map_center, # Center the map using the calculated centroid
      zoom = zoom,
      pitch = pitch,
      bearing = bearing
    ) %>%
      mapdeck::add_polygon(
        data = data,
        fill_colour = value_column,    # Column used for color mapping
        elevation = value_column,     # Column used for elevation
        elevation_scale = 0.0001,    # Scale elevation appropriately
        palette = custom_palette_matrix, # Apply custom color matrix
        update_view = F,
        tooltip = "tooltip_me",
        legend = T,
        legend_format = list(fill_colour = legend_format),
        legend_options = list(fill_colour = list(title = legend_title))
      )
  }

# wtx_parcel %>%
#   map_value()

