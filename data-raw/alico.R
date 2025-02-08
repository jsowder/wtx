alico <-
  wtx_zoning %>%
  dplyr::filter(ZONE_ID == 21)

usethis::use_data(alico, overwrite = TRUE)
