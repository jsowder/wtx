# This data doesn't have useful columns beyond geometry, so just use geometry
wtx_parcel_gis_raw <-
  st_read('data-source/MCAD GIS/Parcels.shp') %>%
  rename_with(tolower) %>%
  inner_join(wtx_parcel_tax, multiple = 'all') %>%
  st_make_valid()

wtx_parcel_gis_raw %>% filter(map == 225) %>% View()

usethis::use_data(wtx_parcel_gis_raw, overwrite = TRUE)
