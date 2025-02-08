wtx_zoning_restrictions <-
  read_csv('data-source/Zoning/zone_restrictions.csv', show_col_types = F)

usethis::use_data(wtx_zoning_restrictions, overwrite = TRUE)
