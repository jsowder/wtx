# Figure out unmapped parcels
wtx_parcel <-
  wtx_property %>%
  filter(propertyType != 'P' | is.na(propertyType)) %>%
  mutate(
    unmapped = st_is_empty(geometry)
    ,condo = case_when(
      prop_id %in% c(184298) ~ '0323.05S48 - AUSTIN AVE FLATS, ORIG TAYLOR & BEALL Blk 7 Lt A3'
      ,prop_id %in% c(341103) ~ '0055.56S48 - Bandera Ranch Turnbull- Boozer Ph 2 Blk 1 Lot 2'
      ,doingBusinessAs == 'BENT TREE PLACE CONDO' ~ 'Bent Tree Place'
      ,prop_id %in% c(139519, 139541) ~ 'Bent Tree Place'
      ,str_detect(legalDescription, '(?i)window box') ~ 'Window Box Condos'
      ,TRUE ~ condo)
    , imprv_only =
      legalDescription %>% toupper() %>% str_detect('IMP ONLY|IMPS ONLY|IMPROVEMENT ONLY|USE: F2') |
      doingBusinessAs %>% toupper() %>% str_detect('IMP ONLY|IMPS ONLY|IMPROVEMENT ONLY|USE: F2')
    , condo_related =
      legalDescription %>% toupper() %>% str_detect(' CONDO | CONDO|^CONDO |TOWNHOMES') |
      doingBusinessAs %>% toupper() %>% str_detect(' CONDO | CONDO|^CONDO |TOWNHOMES')
    , .after = prop_id
  ) %>%
  # Value per acre
  mutate(
    imprv_val = market_val - land_val
    ,val_per_acre = market_val/acreage
    ,val_per_acre_land = land_val/acreage
    ,val_per_acre_improve = imprv_val/acreage) %>%
  filter(!is.na(val_per_acre), !is.infinite(val_per_acre)) %>%
  filter(!is.na(val_per_acre_land), !is.infinite(val_per_acre_land)) %>%
  filter(!is.na(val_per_acre_improve), !is.infinite(val_per_acre_improve)) %>%
  glimpse()

usethis::use_data(wtx_parcel, overwrite = TRUE)
