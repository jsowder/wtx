wtx_parcel_use <-
  read_csv('data-source/MCAD/MCAD Property Use Codes.csv') %>%
  select(-property_use_cd)

usethis::use_data(wtx_parcel_use, overwrite = TRUE)
