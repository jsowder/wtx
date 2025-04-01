wtx_finance_revenue <-
  read_csv('data-source/Waco Finance/revenue_budget-2025-02-09.csv') %>%
  transmute(fiscalyear, fiscalmonth
            , object
            , multiyear
            , accountstatus
            , functiongroup
            , fundgroup
            , fund
            , organization
            , segment2
            # , segment3
            , project
            # , accountdescription
            , actual, revisedbudget, originalbudget, obligatedamount
            # , encumbrance, unencumberedbalance
            # , ltdoriginalbudget, ltdrevisedbudget
  ) %>%
  filter(fiscalyear == 2024) %>%
  glimpse()

usethis::use_data(wtx_finance_revenue, overwrite = TRUE)
