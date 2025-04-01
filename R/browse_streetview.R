#' Browse Street View
#'
#' @description
#' A short description...
#'
#' @param parcels A data frame containing parcel information, including an `Address` column.
#' @param title Optional. A single string for the app's title. Defaults to `"Street View"`.
#' @param limit Optional. A numeric value to limit the number of parcels viewed. Defaults to 50.
#'
#' @returns
#' A Shiny app is launched to browse street views, using the given parcels.
browse_streetview <-
  function(
    parcels,
    title = "Street View",
    limit = 50
  ){
    library(googleway)
    library(shiny)
    library(DT)
    googleway::set_key(Sys.getenv("GOOGLE_API_KEY"))
    google_streetview_v <- Vectorize(google_streetview)

    display_me_with_images <-
      parcels %>%
      head(limit) %>%
      mutate(
        image_url = Address %>% google_streetview_v(output = 'html')
        ,`Street View` = paste0('<img src="', image_url, '" height="200" />')
        ,Link = paste0('<a href="https://www.google.com/maps/search/?api=1&query=', Address
                       , '" target="_blank">View</a>')
      ) %>%
      relocate(`Street View`, Link) %>%
      select(-image_url) %>%
      st_drop_geometry()

    # Define the Shiny UI
    ui <- fluidPage(
      titlePanel(title),
      dataTableOutput("address_table")
    )

    # Define the Shiny server
    server <- function(input, output) {
      output$address_table <- renderDataTable({
        datatable(
          display_me_with_images,
          escape = FALSE, # Allows rendering HTML for the image column
          options = list(
            autoWidth = TRUE,
            pageLength = 25,
            paging = TRUE
          ),
          rownames = FALSE
        )
      })
    }

    # Run the app
    shinyApp(ui = ui, server = server)
  }
