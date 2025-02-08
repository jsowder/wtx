## code to prepare `wtx_parcels` dataset goes here

wtx_uses <-
  read_csv('data-source/MCAD Additional Data/MCAD Property Use Codes.csv')

wtx_assessments <-
  read_csv('data-source/MCAD Additional Data/MCAD Property Values.csv') %>%
  filter(
    situs_state == 'TX'
    , prop_val_yr == '2024'
    , is.na(`...42`)
    , is.na(`...43`)
    , is.na(`...44`)
  ) %>%
  select(-c(`...42`,`...43`,`...44`))

wtx_parcels <-
  wtx_parcels_raw %>%
  st_join(wtx_neighborhoods, largest = T) %>%
  st_join(wtx_zoning, largest = T) %>%
  left_join(wtx_assessments, join_by("PROP_ID" == "prop_id"), multiple = 'first') %>%
  left_join(wtx_uses, join_by("PROP_ID" == "prop_id"), multiple = 'first') %>%
  left_join(wtx_street_fees %>% select(PROP_ID = `Property ID`, `Property Name`, `Property Status`, `Land Use`, `Development Unit`, `DeveIopment Intensity`, FEE_ADDRESS = Address)
            , by = join_by(PROP_ID)) %>%
  unite("address"
        , c(situs_num, situs_street_prefx, situs_street, situs_street_sufix, situs_city, situs_state, situs_zip)
        , sep = ' '
        , na.rm = T) # %>%
  # rowwise() %>%
  # transmute(PROP_ID
  #           , address
  #           , legal_acreage
  #           , market
  #           , assessed_val
  #           , land_val = max(land_hstd_val, land_non_hstd_val)
  #           , imprv_val = max(imprv_hstd_val, imprv_non_hstd_val)
  #           , property_use = property_use_desc
  #           , Owner
  # )

usethis::use_data(wtx_parcels, overwrite = TRUE)
