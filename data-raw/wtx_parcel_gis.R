# This data doesn't have useful columns beyond geometry, so just use geometry
wtx_parcel_gis <-
  st_read('data-source/MCAD GIS/Parcels.shp') %>%
  # st_transform(4326) %>%
  rename_with(tolower) %>%
  inner_join(wtx_parcel_tax, multiple = 'all') %>%
  st_make_valid() %>%
  group_by(prop_id) %>%
  summarise(
    geometry = st_union(geometry)  # Merge geometries into one per PROP_ID
    , .groups = "drop"
  ) %>%
  filter(st_geometry_type(.) %in% c("POLYGON", "MULTIPOLYGON")) %>%
  st_join(wtx_neighborhoods, largest = T) %>%
  st_join(wtx_zoning %>% select(ZONING, LANDUSEPLA), largest = T) %>%
  st_make_valid()

usethis::use_data(wtx_parcel_gis, overwrite = TRUE)
