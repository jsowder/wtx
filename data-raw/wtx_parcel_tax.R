wtx_parcel_tax <-
  read_csv('data-source/MCAD/MCAD Tax Estimates.csv') %>%
  dplyr::filter(description %in% c(
     'WACO, CITY OF'
    # ,'Waco Tourism Public Improvement District'
    # ,'WACO PUBLIC IMPRV DIST#1 1988'
    # ,'Tax Increment Dist# 1'
    # ,'Waco Public Imp Dist# 2 - 2003'
    # ,'Tax Increment Dist# 3'
    # ,'Tax Increment Dist# 4'
    # ,'Tif4 Floyd Casey Development Agreement'
  )) %>%
  select_if(~ n_distinct(.x) > 1) # If a column has the same value for each row, drop it

usethis::use_data(wtx_parcel_tax, overwrite = TRUE)

# Confirm jurisdiction(s), property tax amounts
# About $120M for City of Waco
wtx_parcel_tax %>%
  group_by(description) %>%
  summarise(
    across(c(market_val, taxable_val, estimated_tax), ~ sum(.x, na.rm = T))
    ) %>%
  arrange(desc(taxable_val))

# Calculate % for each description relative to description = WACO, CITY OF
wtx_parcel_tax %>%
  group_by(description) %>%
  summarise(
    across(c(market_val, taxable_val, estimated_tax), ~ sum(.x, na.rm = T))
  ) %>%
  mutate(
    market_val_pct = market_val / market_val[description == 'WACO, CITY OF']
    , taxable_val_pct = taxable_val / taxable_val[description == 'WACO, CITY OF']
    , estimated_tax_pct = estimated_tax / estimated_tax[description == 'WACO, CITY OF']
  ) %>%
  arrange(desc(taxable_val))

# Confirm one parcel ID per row
wtx_parcel_tax %>%
  group_by(prop_id) %>%
  summarise(n = n()) %>%
  dplyr::filter(n > 1) %>%
  arrange(desc(n))

# Compare against a fresh MCAD pull
wtx_parcel_tax <- wtx_parcel_tax
anti_joined <- wtx_parcel_tax %>% anti_join(wtx_parcel_mcad_fresh)
joined <- wtx_parcel_tax %>% inner_join(wtx_parcel_mcad_fresh, multiple = 'all')
joined %>%
  add_count(prop_id) %>%
  filter(n > 1) %>%
  View()

