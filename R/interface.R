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

.check_character_vector <- function(x, name) {

  if (!is.character(x) || length(x) == 0 || anyNA(x) || any(!nzchar(trimws(x)))) {
    stop(paste0("`", name, "` debe ser un vector de texto no vacio."), call. = FALSE)
  }

  invisible(x)
}

#' Metadata de las series
#'
#' Obtiene el catalogo actual de series disponibles del Banco Central de Chile.
#' Use esta funcion para conocer que series existen, su frecuencia y su
#' cobertura temporal.
#'
#' @param frequency Vector opcional de frecuencias. Puede contener `DAILY`,
#'   `MONTHLY`, `QUARTERLY` o `ANNUAL`. Si se omite, devuelve todas las
#'   frecuencias.
#' @param token Token de acceso a la API REST del Banco Central. Por defecto lee
#'   la opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.
#' @param verbose Si es `TRUE`, informa cuando se consultan las cuatro
#'   frecuencias. Por defecto usa la opcion `bcchr.verbose` y luego `TRUE`.
#'
#' @return Un tibble con la metadata de las series y nombres de columnas en
#'   snake_case.
#'
#' @examples
#' if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
#'   metadata(c("MONTHLY", "QUARTERLY"), verbose = FALSE) |>
#'     head()
#' }
#' @export
metadata <- function(
    frequency = NULL,
    token = NULL,
    verbose = getOption("bcchr.verbose", TRUE)
    ) {

  frequencies <- c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")

  if (!is.null(frequency)) {
    .check_character_vector(frequency, "frequency")
    frequency <- unique(toupper(frequency))

    if (any(!frequency %in% frequencies)) {
      stop(
        "`frequency` debe ser DAILY, MONTHLY, QUARTERLY o ANNUAL.",
        call. = FALSE
      )
    }

    frequencies <- frequency
  } else if (isTRUE(verbose)) {
    rlang::inform(
      "Consultando las 4 frecuencias del Banco Central; esto puede tardar unos segundos."
    )
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
#' Busca en el catalogo del Banco Central usando uno o varios terminos legibles
#' por una persona y devuelve las series candidatas. Esta funcion solo encuentra
#' candidatos; no elige una serie por el usuario.
#'
#' @param query Vector de textos a buscar, por ejemplo `"imacec"` o
#'   `c("dolar observado", "unidad de fomento")`.
#' @param frequency Filtro opcional de frecuencia pasado a [metadata()].
#' @param token Token de acceso a la API REST del Banco Central.
#' @param verbose Si es `TRUE`, informa cuando se consultan las cuatro
#'   frecuencias. Por defecto usa la opcion `bcchr.verbose` y luego `TRUE`.
#'
#' @return Un tibble con todas las series candidatas encontradas y una columna
#'   `query` que identifica el texto que produjo cada resultado.
#'
#' @examples
#' if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
#'   candidates <- resolve_series(
#'     c("dolar observado", "unidad de fomento"),
#'     frequency = "DAILY",
#'     verbose = FALSE
#'   )
#'
#'   candidates[c("query", "series_id", "frequency", "spanish_title")] |>
#'     head()
#' }
#' @export
resolve_series <- function(
    query,
    frequency = NULL,
    token = NULL,
    verbose = getOption("bcchr.verbose", TRUE)
    ) {

  .check_character_vector(query, "query")

  normalize <- function(x) {
    x <- iconv(x, to = "ASCII//TRANSLIT")
    x[is.na(x)] <- ""
    tolower(x)
  }

  x <- metadata(frequency, token, verbose = verbose)
  normalized_query <- normalize(query)
  normalized_series_id <- normalize(x$series_id)
  normalized_spanish_title <- normalize(x$spanish_title)
  normalized_english_title <- normalize(x$english_title)

  results <- Map(function(label, term) {
    keep <- grepl(term, normalized_series_id, fixed = TRUE) |
      grepl(term, normalized_spanish_title, fixed = TRUE) |
      grepl(term, normalized_english_title, fixed = TRUE)

    result <- x[keep, , drop = FALSE]
    result$query <- rep(label, nrow(result))
    result[c("query", setdiff(names(result), "query"))]
  }, query, normalized_query)

  tibble::as_tibble(do.call(rbind, results))
}

#' Describir una serie del Banco Central
#'
#' Devuelve la metadata de una o varias series identificadas por sus codigos
#' exactos. Esta funcion no interpreta nombres en lenguaje natural. Use
#' [resolve_series()] primero cuando no conozca los codigos.
#'
#' @param series_id Vector de codigos exactos de series del Banco Central.
#' @param token Token de acceso a la API REST del Banco Central.
#' @param verbose Si es `TRUE`, informa cuando se consultan las cuatro
#'   frecuencias. Por defecto usa la opcion `bcchr.verbose` y luego `TRUE`.
#'
#' @return Un tibble con una fila por cada codigo solicitado.
#'
#' @examples
#' if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
#'   describe_series(
#'     c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
#'     verbose = FALSE
#'   )[c("series_id", "frequency", "spanish_title")]
#' }
#' @export
describe_series <- function(
    series_id,
    token = NULL,
    verbose = getOption("bcchr.verbose", TRUE)
    ) {

  .check_character_vector(series_id, "series_id")

  x <- metadata(token = token, verbose = verbose)
  positions <- match(series_id, x$series_id)

  if (anyNA(positions)) {
    unknown <- unique(series_id[is.na(positions)])
    stop(
      paste0(
        "Codigos de serie desconocidos: ",
        paste(unknown, collapse = ", "),
        ". Use `resolve_series()` para encontrar codigos validos."
      ),
      call. = FALSE
    )
  }

  x[positions, , drop = FALSE]
}

#' Obtener observaciones de series del Banco Central
#'
#' Obtiene las observaciones de una o varias series identificadas por sus
#' codigos exactos y, opcionalmente, un rango de fechas comun. Esta funcion solo
#' obtiene datos para los codigos entregados; nunca interpreta ni resuelve
#' nombres de series.
#'
#' @param series_id Vector de codigos exactos de series del Banco Central.
#' @param from Fecha inicial opcional en formato `YYYY-MM-DD` o como objeto
#'   `Date`.
#' @param to Fecha final opcional en formato `YYYY-MM-DD` o como objeto `Date`.
#' @param token Token de acceso a la API REST del Banco Central. Por defecto lee
#'   la opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.
#'
#' @return Un tibble en formato largo con las columnas `series_id`, `date`,
#'   `value` y `status_code`.
#'
#' @examples
#' if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
#'   indicators <- get_series(
#'     c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
#'     from = "2025-01-02",
#'     to = "2025-01-05"
#'   )
#'
#'   indicators |> head()
#' }
#' @export
get_series <- function(series_id, from = NULL, to = NULL, token = NULL) {

  .check_character_vector(series_id, "series_id")
  series_id <- unique(series_id)

  results <- lapply(seq_along(series_id), function(index) {
    # La API permite consultar hasta cinco series distintas por segundo.
    if (index > 1L && (index - 1L) %% 5L == 0L) {
      Sys.sleep(1)
    }

    id <- series_id[[index]]
    x <- bcch_GetSeries(
      timeseries = id,
      firstdate = from,
      lastdate = to,
      token = token
    )

    tibble::tibble(
      series_id = rep(id, nrow(x)),
      date = x$indexDateString,
      value = x$value,
      status_code = x$statusCode
    )
  })

  tibble::as_tibble(do.call(rbind, results))
}
