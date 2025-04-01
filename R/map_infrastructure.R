#' Map Infrastructure Cost
#'
#' @description
#' A short description...
#'
#' @param data A dataset, likely a spatial object.
#' @param map_center Optional. A numeric vector representing the map's center coordinates.
#' @param zoom Optional. A numeric value for the zoom level.
#' @param pitch Optional. A numeric value for the pitch.
#' @param bearing Optional. A numeric value for the bearing.
#' @param legend_title Optional. A title for the legend.
#'
#' @returns
#' A map visualization. The function will instead raise an error if required columns aren't present in the data.
#'
#' @export
map_infrastructure_cost <-
  function(
    data
    , map_center = NULL
    , zoom = 12
    , pitch = 80
    , bearing = 270
    , legend_title = NULL) {

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
        st_centroid(st_union(st_geometry(data))) %>%
        st_transform(data, crs = 4326) %>%
        st_coordinates() %>%
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

    data <-
      data %>%
      mutate(tooltip_me = paste0(format_value(!!rlang::sym(value_column)), " - ", coalesce(`Property Name`, Owner), " ", Address))

    # Create the map
    mapdeck(
      style = mapdeck_style("dark"),
      location = map_center, # Center the map using the calculated centroid
      zoom = zoom,
      pitch = pitch,
      bearing = bearing
    ) %>%
      add_polygon(
        data = data %>% st_transform(4326),
        fill_colour = value_column,    # Column used for color mapping
        elevation = value_column,     # Column used for elevation
        elevation_scale = 0.0001,    # Scale elevation appropriately
        palette = custom_palette_matrix, # Apply custom color matrix
        update_view = F,
        tooltip = "tooltip_me",
        legend = T,
        legend_format = list(fill_colour = legend_format),
        legend_options = list(fill_colour = list(
          title = legend_title
        ))
      )
  }
