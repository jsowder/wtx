crime_types <-
  read_csv('data-source/Police/penal_codes.csv') %>%
  mutate(Charge = Charge %>% str_remove('\\*.*') %>% str_squish())

wtx_police_calls <-
  readxl::read_excel('data-source/Police/Crime and Police Data.xls', skip = 11) %>%
  select(Reported_Date, Report_Time, Neighborhood = ...8, Location, `Preliminary Description`, `Preliminary Offense`, `Case #`) %>%
  fill(Neighborhood, .direction = "down") %>%
  filter(!is.na(Location)) %>%
  mutate(Reported_Date = Reported_Date %>% as.numeric() %>% as.Date(origin = "1899-12-30"),
         Report_Time = Report_Time %>% parse_time('%H%M'),
         Code = `Preliminary Offense` %>% str_extract('(?<=PC )\\d{2}\\.\\d{2,3}')) %>%
  left_join(crime_types) %>%
  glimpse()

usethis::use_data(wtx_police_calls, overwrite = TRUE)
