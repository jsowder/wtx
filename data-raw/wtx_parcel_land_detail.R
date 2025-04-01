wtx_parcel_land_detail <-
  read_csv('data-source/MCAD/MCAD Land Details.csv') %>%
  group_by(prop_id) %>%
  # Sometimes there are two rows for a prop_id - these rows should be combined by summing area
  # Less clear on frontage/depth, so I'm going for the max of each
  summarise(
    across(c(acreage, sqft, land_market, prod_val), ~ sum(.x, na.rm = TRUE))
    , across(c(eff_front, eff_depth), ~ max(.x, na.rm = TRUE))
    ) %>%
  rename(land_val = land_market, land_prod_val = prod_val) %>%
  select_if(~ n_distinct(.x) > 1) # If a column has the same value for each row, drop it

usethis::use_data(wtx_parcel_land_detail, overwrite = TRUE)
