wtx_address_points <-
  st_read('data-source/MCAD GIS/Address_Points.shp') %>%
  mutate(across(ST_NAME:STATE, ~ toupper(.x))) %>%
  buffer(12) %>%
  glimpse()

usethis::use_data(wtx_address_points, overwrite = TRUE)

