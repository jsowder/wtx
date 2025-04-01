wtx_finance_expense <-
  read_csv('data-source/Waco Finance/operating_budget-2025-02-09.csv') %>%
  transmute(fiscalyear, fiscalmonth
            , multiyear
            , accountstatus
            , functiongroup
            , fundgroup
            , charactercodedescription
            , segment2
            , project
            , fund
            , segment3
            , object
            , organization
            , accountdescription
            , actual, revisedbudget, originalbudget, obligatedamount
            , encumbrance, unencumberedbalance
            , ltdoriginalbudget, ltdrevisedbudget
  ) %>%
  filter(fiscalyear == 2024) %>%
  glimpse()

usethis::use_data(wtx_finance_expense, overwrite = TRUE)
