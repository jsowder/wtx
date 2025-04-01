.First <- function() {
  if (interactive()) {
    options(scipen=999)
    suppressMessages(require(devtools))
    suppressMessages(require(tidyverse))
    suppressMessages(require(magrittr))
    library(sf)
    library(mapdeck)
    library(scales)
    load_all()
    conflicted::conflicts_prefer(dplyr::filter, dplyr::lag, magrittr::extract, magrittr::set_names)
  }
}
