
wtx_zoning <-
  system.file("extdata", "Waco Zoning", "waco_zoning.shp", package = "wtx") %>%
  st_read() %>%
  select(ZONE_ID, ZONING, LANDUSEPLA) %>%
  st_make_valid()

usethis::use_data(wtx_zoning, overwrite = TRUE)

# Write some interesting code
starwars %>%
  dplyr::filter(!is.na(mass) & !is.na(height)) %>%
  mutate(bmi = mass / ((height / 100) ^ 2)) %>%
  select(name, bmi) %>%
  arrange(desc(bmi))
