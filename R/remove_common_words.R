#' Remove Common Words from a Dataframe Column
#'
#' @description
#' A short description...
#'
#' @param df A dataframe.
#' @param column A column in `df` to process, captured as a symbol.
#' @param top_n Optional. A numeric value indicating the number of top common words to remove, defaulting to 100.
#'
#' @returns
#' The dataframe with an additional column containing the processed text, with the most common words removed.
#'
#' @export
remove_common_words <- function(df, column, top_n = 100) {
  column <- enquo(column)  # Capture the column as a symbol

  # Tokenize words and count occurrences
  word_counts <- df %>%
    unnest_tokens(word, !!column) %>%
    count(word, sort = TRUE)

  # Get the top N most common words
  top_words <- word_counts %>%
    slice_max(n, n = top_n) %>%
    pull(word)

  # Function to remove top words from text
  remove_top_words <- function(text, top_words) {
    words <- unlist(strsplit(text, "\\s+"))  # Split into words
    words <- words[!words %in% top_words]  # Remove common words
    paste(words, collapse = " ")  # Reconstruct phrase
  }

  # Create new column name dynamically
  new_column_name <- paste0(rlang::as_name(column), "_cleaned")

  # Apply function to dataframe
  df <- df %>%
    mutate(!!new_column_name := map_chr(!!column, ~ remove_top_words(.x, top_words)))

  return(df)
}
