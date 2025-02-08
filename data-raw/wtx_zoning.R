wtx_zoning <-
  st_read('data-source/Zoning/waco_zoning.shp') %>%
  st_make_valid() %>%
  select(ZONE_ID, ZONING, LANDUSEPLA)

usethis::use_data(wtx_zoning, overwrite = TRUE)
