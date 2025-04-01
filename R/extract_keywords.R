#' Extract keywords using TF-IDF
#'
#' @description
#' A short description...
#'
#' @param text_column A character vector representing the text to process.
#' @param tfidf_cutoff A numeric value representing the percentile cutoff for TF-IDF. Optional.
#' @param keywords_per_row A numeric value specifying the number of keywords to retain per row. Optional.
#' @param remove_numbers A logical flag indicating whether to remove numerical tokens. Optional.
#' @param min_length A numeric value specifying the minimum length of words to consider. Optional.
#'
#' @returns
#' A character vector of extracted keywords per input text, based on TF-IDF scoring.
#'
#' @export
extract_keywords <- function(text_column, tfidf_cutoff = 0.05, keywords_per_row = 3, remove_numbers = TRUE, min_length = 3) {
  library(tidyverse)
  library(tidytext)
  df <- tibble(text = text_column) %>%
    mutate(row_id = row_number())  # Assign row IDs

  # Tokenize words
  tokenized <- df %>%
    unnest_tokens(word, text)

  # Optionally remove numbers (including decimals)
  if (remove_numbers) {
    tokenized <- tokenized %>%
      filter(!str_detect(word, "^\\d*\\.?\\d+$"))  # Removes whole and decimal numbers
  }

  # Remove short words below min_length
  tokenized <- tokenized %>%
    filter(nchar(word) > min_length)

  # Compute TF-IDF for all words
  tfidf_scores <- tokenized %>%
    count(row_id, word, sort = TRUE) %>%
    bind_tf_idf(word, row_id, n)

  # Determine TF-IDF cutoff based on percentile
  tfidf_threshold <- quantile(tfidf_scores$tf_idf, probs = tfidf_cutoff, na.rm = TRUE)

  # Filter words below the TF-IDF threshold
  filtered_words <- tfidf_scores %>%
    filter(tf_idf >= tfidf_threshold)

  # Keep the top N keywords per row
  keywords <- filtered_words %>%
    group_by(row_id) %>%
    slice_max(tf_idf, n = keywords_per_row) %>%
    summarise(keywords = str_c(word, collapse = " "), .groups = "drop")

  # Merge back with original input order
  result <- df %>%
    left_join(keywords, by = "row_id") %>%
    pull(keywords)  # Extract vector

  return(result)
}

# Example Usage in mutate()
# df <- data.frame(joiner = c("example phrase 3.14 with unique words",
#                             "a an the big example 42.5 phrase with distinct meaning",
#                             "it is so cool 2024.01 uncommon words here",
#                             "example 999.99 words repeated in text"))
#
# df <- df %>%
#   mutate(cleaned_joiner = extract_keywords(joiner, tfidf_cutoff = 0.05, keywords_per_row = 2, remove_numbers = TRUE, min_length = 3))
#
# print(df)
