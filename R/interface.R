#' Series metadata
#'
#' Return the packaged Banco Central series catalog with consistent snake_case
#' column names. Use this function to inspect which series are available.
#'
#' @param frequency Optional frequency filter. One of `DAILY`, `MONTHLY`,
#'   `QUARTERLY`, or `ANNUAL`.
#'
#' @return A tibble with series code, frequency, Spanish title, and English title.
#' @export
metadata <- function(frequency = NULL) {

  x <- bcchseries |>
    dplyr::transmute(
      series_id = .data$seriesId,
      frequency = .data$frequencyCode,
      spanish_title = .data$spanishTitle,
      english_title = .data$englishTitle
    )

  if (!is.null(frequency)) {
    frequency <- toupper(frequency)

    if (length(frequency) != 1 ||
        !frequency %in% c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")) {
      stop("`frequency` must be DAILY, MONTHLY, QUARTERLY, or ANNUAL.", call. = FALSE)
    }

    x <- dplyr::filter(x, .data$frequency == frequency)
  }

  x
}

#' Resolve a human description to Banco Central series
#'
#' Search the series catalog using a human-readable term. This function only
#' finds candidates; it does not choose a series on the user's behalf.
#'
#' @param query Text to search for, such as `"imacec"` or `"dolar observado"`.
#' @param frequency Optional frequency filter passed to [metadata()].
#'
#' @return A tibble with every matching series candidate.
#' @export
resolve_series <- function(query, frequency = NULL) {

  if (!is.character(query) || length(query) != 1 || !nzchar(query)) {
    stop("`query` must be one non-empty character string.", call. = FALSE)
  }

  normalize <- function(x) {
    x <- iconv(x, to = "ASCII//TRANSLIT")
    x[is.na(x)] <- ""
    tolower(x)
  }

  x <- metadata(frequency)
  query <- normalize(query)

  keep <- grepl(query, normalize(x$series_id), fixed = TRUE) |
    grepl(query, normalize(x$spanish_title), fixed = TRUE) |
    grepl(query, normalize(x$english_title), fixed = TRUE)

  x[keep, , drop = FALSE]
}

#' Describe one Banco Central series
#'
#' Return metadata for one exact Banco Central series code. This function does
#' not interpret human-readable names; use [resolve_series()] first when the
#' code is unknown.
#'
#' @param series_id Exact Banco Central series code.
#'
#' @return A one-row tibble describing the series.
#' @export
describe_series <- function(series_id) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` must be one non-empty character string.", call. = FALSE)
  }

  x <- dplyr::filter(metadata(), .data$series_id == series_id)

  if (nrow(x) == 0) {
    stop(
      "Unknown series code. Use `resolve_series()` to find a valid code.",
      call. = FALSE
    )
  }

  x
}

#' Get observations for one Banco Central series
#'
#' Retrieve observations for one exact Banco Central series code. This function
#' deliberately does not resolve human-readable names: use [resolve_series()]
#' before calling it when the code is unknown.
#'
#' @param series_id Exact Banco Central series code.
#' @param from Optional first date.
#' @param to Optional last date.
#' @param token Banco Central REST API token. By default it reads the
#'   `bcch_api_token` option and then the `BCCH_TOKEN` environment variable.
#'
#' @return A tibble with `date`, `value`, and `status_code`.
#' @export
get_series <- function(
    series_id,
    from = NULL,
    to = NULL,
    token = getOption("bcch_api_token", Sys.getenv("BCCH_TOKEN"))
    ) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` must be one non-empty character string.", call. = FALSE)
  }

  x <- bcch_GetSeries(
    timeseries = series_id,
    firstdate = from,
    lastdate = to,
    token = token
  )

  tibble::as_tibble(x) |>
    dplyr::transmute(
      date = .data$indexDateString,
      value = .data$value,
      status_code = .data$statusCode
    )
}
