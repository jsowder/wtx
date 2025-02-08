wtx_vacancy <-
  read_csv('data-source/_Vacancy Data.csv')

usethis::use_data(wtx_vacancy, overwrite = TRUE)
