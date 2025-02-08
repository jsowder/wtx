wtx_parcel_land_detail <-
  read_csv('data-source/MCAD Additional Data/MCAD Land Details.csv') %>%
  group_by(prop_id) %>%
  # Sometimes there are two rows for a prop_id - these rows should be combined by summing area
  # Less clear on frontage/depth, so I'm going for the max of each
  summarise(
    across(c(acreage, sqft, land_market, prod_val), ~ sum(.x, na.rm = TRUE))
    , across(c(eff_front, eff_depth), ~ max(.x, na.rm = TRUE))
    )

usethis::use_data(wtx_parcel_land_detail, overwrite = TRUE)

object.size(wtx_parcel_land_detail)
object.size(wtx_parcels)
