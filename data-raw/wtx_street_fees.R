wtx_street_fees <-
  read_csv('data-source/Street Inventory/Street Maintenance Fees.csv') %>%
  mutate(Fee = parse_number(`Property Monthly Fee`, na = c('#N/A')))

usethis::use_data(wtx_street_fees, overwrite = TRUE)

