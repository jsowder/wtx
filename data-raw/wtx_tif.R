wtx_tif <-
  st_read('data-source/Waco Misc Shapefiles/Tax Increment Finance Zone.shp') %>%
  st_make_valid() %>%
  select(TIF_ZONE = TIF_ID)

usethis::use_data(wtx_tif, overwrite = TRUE)
