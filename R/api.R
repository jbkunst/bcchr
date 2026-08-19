# Low-level Banco Central API ----------------------------------------------

#' Obtener los datos de una serie
#'
#' Acceso directo a la operación `GetSeries` del API del Banco Central.
#' Para la interfaz moderna use [get_series()].
#'
#' @param timeseries Código exacto de la serie.
#' @param firstdate Fecha inicial opcional.
#' @param lastdate Fecha final opcional.
#' @param token Token del API del Banco Central.
#'
#' @return Un tibble con los nombres originales entregados por el API.
#' @export
bcch_GetSeries <- function(timeseries, firstdate = NULL, lastdate = NULL, token = NULL) {

  if (!is.character(timeseries) || length(timeseries) != 1 || !nzchar(timeseries)) {
    stop("`timeseries` must be one non-empty character string.", call. = FALSE)
  }

  if (!is.null(firstdate)) {
    firstdate <- as.character(firstdate)
  }

  if (!is.null(lastdate)) {
    lastdate <- as.character(lastdate)
  }

  content <- .bcch_request(
    "GetSeries",
    .bcch_token(token),
    timeseries = timeseries,
    firstdate = firstdate,
    lastdate = lastdate
  )

  x <- .bcch_rows(content$Series$Obs)
  x$indexDateString <- as.Date(x$indexDateString, format = "%d-%m-%Y")
  x$value[x$value %in% c("", "NA", "NaN", "NeuN", "ND")] <- NA_character_
  x$value <- suppressWarnings(as.numeric(x$value))

  x
}

#' Obtener las series disponibles por frecuencia
#'
#' Acceso directo a la operación `SearchSeries` del API del Banco Central.
#' Para la interfaz moderna use [metadata()] o [resolve_series()].
#'
#' @param frequency Frecuencia: `DAILY`, `MONTHLY`, `QUARTERLY` o `ANNUAL`.
#' @param token Token del API del Banco Central.
#'
#' @return Un tibble con los nombres originales entregados por el API.
#' @export
bcch_SearchSeries <- function(frequency, token = NULL) {

  frequency <- toupper(frequency)

  if (length(frequency) != 1 ||
      !frequency %in% c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")) {
    stop("`frequency` must be DAILY, MONTHLY, QUARTERLY, or ANNUAL.", call. = FALSE)
  }

  content <- .bcch_request(
    "SearchSeries",
    .bcch_token(token),
    frequency = frequency
  )

  x <- .bcch_rows(content$SeriesInfos)
  date_columns <- intersect(
    c("firstObservation", "lastObservation", "updatedAt", "createdAt"),
    names(x)
  )

  x[date_columns] <- lapply(
    x[date_columns],
    as.Date,
    format = "%d-%m-%Y"
  )

  x
}
