# Modern bcchr interface ---------------------------------------------------

.bcch_request <- function(function_name, token, ...) {

  if (!is.character(token) || length(token) != 1 || !nzchar(token)) {
    stop(
      "A Banco Central API token is required. Set `BCCH_TOKEN` or pass `token`.",
      call. = FALSE
    )
  }

  response <- httr::GET(
    "https://si3.bcentral.cl/SieteRestWS/SieteRestWS.ashx",
    query = c(list(token = token, `function` = function_name), list(...))
  )

  httr::stop_for_status(response)

  raw <- httr::content(response, as = "raw")
  text <- iconv(rawToChar(raw), from = "ISO-8859-1", to = "UTF-8")
  content <- jsonlite::fromJSON(text, simplifyVector = FALSE)

  if (!identical(content$Codigo, 0L)) {
    description <- content$Descripcion

    if (is.null(description)) {
      description <- "unknown error"
    }

    stop("Banco Central API error: ", description, call. = FALSE)
  }

  content
}

.bcch_token <- function(token = NULL) {

  if (is.null(token)) {
    token <- getOption("bcch_api_token", Sys.getenv("BCCH_TOKEN"))
  }

  token
}

#' Series metadata
#'
#' Get the current Banco Central series catalog. Use this function to inspect
#' which series exist and their frequency and temporal coverage.
#'
#' @param frequency Optional frequency filter. One of `DAILY`, `MONTHLY`,
#'   `QUARTERLY`, or `ANNUAL`. When omitted, all frequencies are returned.
#' @param token Banco Central REST API token. By default it reads the
#'   `bcch_api_token` option and then the `BCCH_TOKEN` environment variable.
#'
#' @return A tibble with series metadata using snake_case column names.
#' @export
metadata <- function(frequency = NULL, token = NULL) {

  frequencies <- c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")

  if (!is.null(frequency)) {
    frequency <- toupper(frequency)

    if (length(frequency) != 1 || !frequency %in% frequencies) {
      stop("`frequency` must be DAILY, MONTHLY, QUARTERLY, or ANNUAL.", call. = FALSE)
    }

    frequencies <- frequency
  }

  token <- .bcch_token(token)

  purrr::map_dfr(frequencies, function(freq) {
    content <- .bcch_request("SearchSeries", token, frequency = freq)

    content$SeriesInfos |>
      purrr::transpose() |>
      tibble::as_tibble() |>
      dplyr::mutate(dplyr::across(dplyr::everything(), unlist)) |>
      dplyr::transmute(
        series_id = .data$seriesId,
        frequency = .data$frequencyCode,
        spanish_title = .data$spanishTitle,
        english_title = .data$englishTitle,
        first_observation = lubridate::dmy(.data$firstObservation),
        last_observation = lubridate::dmy(.data$lastObservation),
        updated_at = lubridate::dmy(.data$updatedAt),
        created_at = lubridate::dmy(.data$createdAt)
      )
  })
}

#' Resolve a human description to Banco Central series
#'
#' Search the Banco Central catalog using a human-readable term and return the
#' matching series candidates. This function finds candidates only; it does not
#' choose a series on the user's behalf.
#'
#' @param query Text to search for, such as `"imacec"` or `"dolar observado"`.
#' @param frequency Optional frequency filter passed to [metadata()].
#' @param token Banco Central REST API token.
#'
#' @return A tibble with every matching series candidate.
#' @export
resolve_series <- function(query, frequency = NULL, token = NULL) {

  if (!is.character(query) || length(query) != 1 || !nzchar(query)) {
    stop("`query` must be one non-empty character string.", call. = FALSE)
  }

  normalize <- function(x) {
    x <- iconv(x, to = "ASCII//TRANSLIT")
    x[is.na(x)] <- ""
    tolower(x)
  }

  x <- metadata(frequency, token)
  query <- normalize(query)

  keep <- grepl(query, normalize(x$series_id), fixed = TRUE) |
    grepl(query, normalize(x$spanish_title), fixed = TRUE) |
    grepl(query, normalize(x$english_title), fixed = TRUE)

  x[keep, , drop = FALSE]
}

#' Describe one Banco Central series
#'
#' Return metadata for one exact Banco Central series code. This function does
#' not interpret human-readable names. Use [resolve_series()] first when the
#' series code is unknown.
#'
#' @param series_id Exact Banco Central series code.
#' @param token Banco Central REST API token.
#'
#' @return A one-row tibble describing the series.
#' @export
describe_series <- function(series_id, token = NULL) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` must be one non-empty character string.", call. = FALSE)
  }

  x <- dplyr::filter(metadata(token = token), .data$series_id == series_id)

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
#' Retrieve observations for one exact Banco Central series code and an optional
#' date range. This function does one thing only: it retrieves data for the code
#' supplied. It never interprets or resolves human-readable series names.
#'
#' @param series_id Exact Banco Central series code.
#' @param from Optional first date in `YYYY-MM-DD` format or a `Date`.
#' @param to Optional last date in `YYYY-MM-DD` format or a `Date`.
#' @param token Banco Central REST API token. By default it reads the
#'   `bcch_api_token` option and then the `BCCH_TOKEN` environment variable.
#'
#' @return A tibble with `date`, `value`, and `status_code`.
#' @export
get_series <- function(series_id, from = NULL, to = NULL, token = NULL) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` must be one non-empty character string.", call. = FALSE)
  }

  if (!is.null(from)) {
    from <- as.character(from)
  }

  if (!is.null(to)) {
    to <- as.character(to)
  }

  content <- .bcch_request(
    "GetSeries",
    .bcch_token(token),
    timeseries = series_id,
    firstdate = from,
    lastdate = to
  )

  content$Series$Obs |>
    purrr::transpose() |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), unlist)) |>
    suppressMessages(readr::type_convert(na = c("", "NA", "NaN", "NeuN", "ND"))) |>
    dplyr::transmute(
      date = lubridate::dmy(.data$indexDateString),
      value = .data$value,
      status_code = .data$statusCode
    )
}
