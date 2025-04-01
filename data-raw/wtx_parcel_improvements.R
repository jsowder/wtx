wtx_parcel_improvements <-
  read_csv('data-source/MCAD/MCAD Improvement Details.csv') %>%
  select_if(~ n_distinct(.x) > 1) # If a column has the same value for each row, drop it

usethis::use_data(wtx_parcel_improvement_detail, overwrite = TRUE)

# Most common improvement by value? Residential Main Area
# Most common improvement by square footage? Commercial Paved Areas
wtx_parcel_improvement_detail %>%
  group_by(imprv_type_desc, imprv_det_typ_desc) %>%
  summarise(
    n = n_distinct(prop_id)
    , sqft = sum(sqft, na.rm = T)
    , imprv_det_val = sum(imprv_det_val, na.rm = T)
  ) %>%
  mutate(val_per_sqft = imprv_det_val/sqft) %>%
  arrange(desc(val_per_sqft)) %>%
  View()

