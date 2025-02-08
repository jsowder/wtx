wtx_street_inventory <-
  st_read('data-source/Street Inventory/StreetInventory.shp') %>%
  st_make_valid()

usethis::use_data(wtx_street_inventory, overwrite = TRUE)
