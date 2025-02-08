wtx_parcels_raw <-
  st_read('data-source/McLennan_CAD_GIS/Parcels.shp') %>%
  st_make_valid() %>%
  st_intersection(wtx_city_limits) %>%
  filter(PROP_ID != 0) %>%
  group_by(PROP_ID) %>%
  summarise(
    geometry = st_union(geometry),  # Merge geometries into one per PROP_ID
    .groups = "drop"
  ) %>%
  filter(st_geometry_type(geometry) %in% c("POLYGON", "MULTIPOLYGON"))

usethis::use_data(wtx_parcels_raw, overwrite = TRUE)
