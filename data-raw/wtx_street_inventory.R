wtx_street_inventory <-
  st_read('data-source/Waco Streets/StreetInventory.shp') %>%
  # st_transform(4326) %>%
  st_make_valid()

usethis::use_data(wtx_street_inventory, overwrite = TRUE)
