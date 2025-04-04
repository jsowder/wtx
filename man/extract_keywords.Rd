% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_keywords.R
\name{extract_keywords}
\alias{extract_keywords}
\title{Extract keywords using TF-IDF}
\usage{
extract_keywords(
  text_column,
  tfidf_cutoff = 0.05,
  keywords_per_row = 3,
  remove_numbers = TRUE,
  min_length = 3
)
}
\arguments{
\item{text_column}{A character vector representing the text to process.}

\item{tfidf_cutoff}{A numeric value representing the percentile cutoff for TF-IDF. Optional.}

\item{keywords_per_row}{A numeric value specifying the number of keywords to retain per row. Optional.}

\item{remove_numbers}{A logical flag indicating whether to remove numerical tokens. Optional.}

\item{min_length}{A numeric value specifying the minimum length of words to consider. Optional.}
}
\value{
A character vector of extracted keywords per input text, based on TF-IDF scoring.
}
\description{
A short description...
}
