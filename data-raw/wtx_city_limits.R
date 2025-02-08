wtx_city_limits <-
  st_read('data-source/McLennan_CAD_GIS/City_Limits.shp') %>%
  st_make_valid() %>%
  filter(CITY == 'WACO') %>%
  select(CITY)

usethis::use_data(wtx_city_limits, overwrite = TRUE)
