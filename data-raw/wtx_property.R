# Join all the useful property info into one table
wtx_property <-
  wtx_parcel_gis %>% # Start with GIS otherwise you get an error
  right_join(wtx_parcel_tax, join_by(prop_id), multiple = 'last') %>%
  full_join(wtx_parcel_mcad_fresh %>%
              select(prop_id, propertyType, legalDescription, ownerName, doingBusinessAs, address, subdivision, condo, appraisedValue, detailUrl
              )
            , join_by(prop_id), multiple = 'last') %>%
  left_join(wtx_parcel_use %>% select(prop_id, property_use_desc), join_by(prop_id), multiple = 'first') %>%
  left_join(wtx_parcel_land_detail, join_by(prop_id), multiple = 'first') %>%
  left_join(wtx_street_fees %>% select(prop_id = `Property ID`, `Property Name`, `Property Status`, `Land Use`, `Development Unit`, `DeveIopment Intensity`)
            ,multiple = 'first'
            ,join_by(prop_id)) %>%
  unite(col = 'hash', ownerName, doingBusinessAs, address, na.rm = T, remove = F, sep = ' ') %>%
  mutate(keywords = hash %>% extract_keywords(tfidf_cutoff = .25, keywords_per_row = 2)) %>%
  relocate(geometry) %>%
  relocate(c(propertyType, keywords, legalDescription, address, property_use_desc
             , market_val, taxable_val, estimated_tax
  ), .after = prop_id) %>%
  st_make_valid() %>%
  glimpse()

usethis::use_data(wtx_property, overwrite = TRUE)
