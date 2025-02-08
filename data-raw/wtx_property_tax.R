wtx_property_tax <-
  read_csv('data-source/MCAD Additional Data/MCAD Tax Estimates.csv') %>%
  filter(description %in% c(
     'WACO, CITY OF'
    ,'Waco Tourism Public Improvement District'
    ,'WACO PUBLIC IMPRV DIST#1 1988'
    ,'Tax Increment Dist# 1'
    ,'Waco Public Imp Dist# 2 - 2003'
    ,'Tax Increment Dist# 3'
    ,'Tax Increment Dist# 4'
    ,'Tif4 Floyd Casey Development Agreement'
  ))

usethis::use_data(wtx_property_tax, overwrite = TRUE)
