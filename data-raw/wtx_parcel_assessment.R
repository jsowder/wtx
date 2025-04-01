shifter <- function(df, condition) {
  # Capture the user-supplied condition
  cond_expr <- enexpr(condition)

  # Identify which column is referenced (require exactly one)
  cond_vars <- all.vars(cond_expr)
  if (length(cond_vars) != 1) {
    stop("Condition must reference exactly one column.")
  }

  # Find that column's index in the data frame
  start_col <- match(cond_vars, names(df))
  if (is.na(start_col)) {
    stop(paste0("Column '", cond_vars, "' not found in 'df'."))
  }

  # Keep shifting (one column at a time) for rows meeting `condition`,
  # until no rows match
  repeat {
    # Which rows currently meet the condition?
    rows_meet <- df %>%
      mutate(.row_id = row_number()) %>%
      filter(!!cond_expr) %>%
      pull(.row_id)

    # If no rows meet the condition, we're done
    if (length(rows_meet) == 0) break

    # Shift columns left by 1 for those rows only
    for (col_i in start_col:(ncol(df) - 1)) {
      df[rows_meet, col_i] <- df[rows_meet, col_i + 1]
    }

    # Overwrite the last column in those rows with NA
    df[rows_meet, ncol(df)] <- NA
  }

  df
}

wtx_parcel_assessment <-
  read_csv('data-source/MCAD/MCAD Property Values.csv') %>%
  mutate(across(everything(), as.character)) %>%
  shifter(situs_state != "TX") %>%
  shifter(str_length(addr_state) > 2) %>%
  shifter(prop_val_yr != '2024') %>%
  select(-starts_with('...')) %>%
  unite("situs_address"
        , c(starts_with("situs_"), -any_of("situs_unit")),
        , sep = ' '
        , remove = F
        , na.rm = T) %>%
  type_convert()

usethis::use_data(wtx_parcel_assessment, overwrite = TRUE)
