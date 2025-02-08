wtx_neighborhoods <-
  st_read('data-source/McLennan_CAD_GIS/WacoNBHD.shp') %>%
  st_make_valid() %>%
  select(NBHD_NAME)

usethis::use_data(wtx_neighborhoods, overwrite = TRUE)
