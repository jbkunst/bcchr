.bcch_request <- function(function_name, token, ...) {

  if (!is.character(token) || length(token) != 1 || !nzchar(token)) {
    stop(
      "Se requiere un token de la API del Banco Central. Configure `BCCH_TOKEN` o pase `token`.",
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
      description <- "error desconocido"
    }

    stop("Error de la API del Banco Central: ", description, call. = FALSE)
  }

  content
}

.bcch_token <- function(token = NULL) {

  if (is.null(token)) {
    token <- getOption("bcch_api_token", Sys.getenv("BCCH_TOKEN"))
  }

  token
}

.bcch_rows <- function(x) {

  if (length(x) == 0) {
    return(tibble::tibble())
  }

  fields <- unique(unlist(lapply(x, names), use.names = FALSE))

  values <- lapply(fields, function(field) {
    vapply(x, function(row) {
      value <- row[[field]]

      if (is.null(value) || length(value) == 0) {
        return(NA_character_)
      }

      as.character(value[[1]])
    }, character(1))
  })

  names(values) <- fields
  tibble::as_tibble(values)
}

#' Metadata de las series
#'
#' Obtiene el catalogo actual de series disponibles del Banco Central de Chile.
#' Use esta funcion para conocer que series existen, su frecuencia y su
#' cobertura temporal.
#'
#' @param frequency Filtro opcional de frecuencia. Puede ser `DAILY`, `MONTHLY`,
#'   `QUARTERLY` o `ANNUAL`. Si se omite, devuelve todas las frecuencias.
#' @param token Token de acceso a la API REST del Banco Central. Por defecto lee
#'   la opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.
#'
#' @return Un tibble con la metadata de las series y nombres de columnas en
#'   snake_case.
#' @export
metadata <- function(frequency = NULL, token = NULL) {

  frequencies <- c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")

  if (!is.null(frequency)) {
    frequency <- toupper(frequency)

    if (length(frequency) != 1 || !frequency %in% frequencies) {
      stop(
        "`frequency` debe ser DAILY, MONTHLY, QUARTERLY o ANNUAL.",
        call. = FALSE
      )
    }

    frequencies <- frequency
  }

  x <- lapply(frequencies, function(freq) {
    raw <- bcch_SearchSeries(freq, token = token)

    tibble::tibble(
      series_id = raw$seriesId,
      frequency = raw$frequencyCode,
      spanish_title = raw$spanishTitle,
      english_title = raw$englishTitle,
      first_observation = raw$firstObservation,
      last_observation = raw$lastObservation,
      updated_at = raw$updatedAt,
      created_at = raw$createdAt
    )
  })

  tibble::as_tibble(do.call(rbind, x))
}

#' Resolver una descripcion a series del Banco Central
#'
#' Busca en el catalogo del Banco Central usando un termino legible por una
#' persona y devuelve las series candidatas. Esta funcion solo encuentra
#' candidatos; no elige una serie por el usuario.
#'
#' @param query Texto a buscar, por ejemplo `"imacec"` o `"dolar observado"`.
#' @param frequency Filtro opcional de frecuencia pasado a [metadata()].
#' @param token Token de acceso a la API REST del Banco Central.
#'
#' @return Un tibble con todas las series candidatas encontradas.
#' @export
resolve_series <- function(query, frequency = NULL, token = NULL) {

  if (!is.character(query) || length(query) != 1 || !nzchar(query)) {
    stop("`query` debe ser una cadena de texto no vacia.", call. = FALSE)
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

#' Describir una serie del Banco Central
#'
#' Devuelve la metadata de una serie identificada por su codigo exacto. Esta
#' funcion no interpreta nombres en lenguaje natural. Use [resolve_series()]
#' primero cuando no conozca el codigo de la serie.
#'
#' @param series_id Codigo exacto de la serie del Banco Central.
#' @param token Token de acceso a la API REST del Banco Central.
#'
#' @return Un tibble de una fila con la descripcion de la serie.
#' @export
describe_series <- function(series_id, token = NULL) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` debe ser una cadena de texto no vacia.", call. = FALSE)
  }

  x <- metadata(token = token)
  x <- x[x$series_id == series_id, , drop = FALSE]

  if (nrow(x) == 0) {
    stop(
      "Codigo de serie desconocido. Use `resolve_series()` para encontrar un codigo valido.",
      call. = FALSE
    )
  }

  x
}

#' Obtener observaciones de una serie del Banco Central
#'
#' Obtiene las observaciones de una serie identificada por su codigo exacto y,
#' opcionalmente, un rango de fechas. Esta funcion solo obtiene datos para el
#' codigo entregado; nunca interpreta ni resuelve nombres de series.
#'
#' @param series_id Codigo exacto de la serie del Banco Central.
#' @param from Fecha inicial opcional en formato `YYYY-MM-DD` o como objeto
#'   `Date`.
#' @param to Fecha final opcional en formato `YYYY-MM-DD` o como objeto `Date`.
#' @param token Token de acceso a la API REST del Banco Central. Por defecto lee
#'   la opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.
#'
#' @return Un tibble con las columnas `date`, `value` y `status_code`.
#' @export
get_series <- function(series_id, from = NULL, to = NULL, token = NULL) {

  if (!is.character(series_id) || length(series_id) != 1 || !nzchar(series_id)) {
    stop("`series_id` debe ser una cadena de texto no vacia.", call. = FALSE)
  }

  x <- bcch_GetSeries(
    timeseries = series_id,
    firstdate = from,
    lastdate = to,
    token = token
  )

  tibble::tibble(
    date = x$indexDateString,
    value = x$value,
    status_code = x$statusCode
  )
}
