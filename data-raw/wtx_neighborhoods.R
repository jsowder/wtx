wtx_neighborhoods <-
  st_read('data-source/MCAD GIS/WacoNBHD.shp') %>%
  select(NBHD_NAME) %>%
  # st_transform(4326) %>%
  st_make_valid()

usethis::use_data(wtx_neighborhoods, overwrite = TRUE)
