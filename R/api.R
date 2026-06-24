# user   <- 178956728
# pssw   <- "cxynr4qyLLBw"
# codigo <- "F049.DES.TAS.INE9.10.M"
#
# options(
#   bcc_api_user = 178956728,
#   bcc_api_pass = "cxynr4qyLLBw"
# )

#' Obtener los datos de series.
#'
#' @param timeseries Código de la serie de tiempo a consultar (obligatorio).
#' @param user Nombre de usuario (obligatorio).
#' @param pass Contraseña (obligatorio).
#' @param firstdate Fecha desde la cual se requiere recoger datos. Si el
#'   parámetro no está presente, se recoge por defecto desde el primer
#'   dato disponible (opcional).
#' @param lastdate Fecha hasta la cual se requiere recoger datos. Si el
#'   parámetro no está presente, se recoge por defecto hasta el
#'   último dato disponible (opcional).
#'
#' @details https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm
#'
#' @examples
#'
#' \dontrun{
#' options(
#'  bcc_api_user = 178956728,
#'  bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#  bcch_GetSeries(timeseries = "F049.DES.TAS.INE9.10.M")
#'
#  bcch_GetSeries(timeseries = "F073.TCO.PRE.Z.D")
#'
#' }
#'
#' @export
bcch_GetSeries <- function(
    timeseries = NULL,
    user = getOption("bcc_api_user"),
    pass = getOption("bcc_api_pass"),
    firstdate = NULL,
    lastdate = NULL
    ){

  stopifnot(is.character(timeseries))
  stopifnot(length(timeseries) == 1)

  qget <- httr::GET(
    "https://si3.bcentral.cl/SieteRestWS/SieteRestWS.ashx",
    query = list(
      user = user,
      pass = pass,
      timeseries = timeseries,
      `function` = "GetSeries",
      firstdate = firstdate,
      lastdate = lastdate
    )
  )

  raw <- httr::content(qget, as = "raw")
  txt <- iconv(rawToChar(raw), from = "ISO-8859-1", to = "UTF-8")
  content <- jsonlite::fromJSON(txt, simplifyVector = FALSE)

  if (!identical(content$Codigo, 0L)) {
    description <- content$Descripcion
    if (is.null(description)) {
      description <- "unknown error"
    }
    stop("Banco Central API error: ", description, call. = FALSE)
  }

  df <- content[["Series"]][["Obs"]] |>
    purrr::transpose() |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), unlist))

  df <- suppressMessages(readr::type_convert(df, na = c("", "NA", "NaN", "NeuN")))
  df <- dplyr::mutate(df, indexDateString = lubridate::dmy(.data$indexDateString))

  # attrs
  attr(df, "descripEsp")    <- content$Series$descripEsp
  attr(df, "descripIng")    <- content$Series$descripIng
  attr(df, "seriesId")      <- content$Series$seriesId
  attr(df, "frequencyCode") <- bcchr::bcchseries |>
    dplyr::filter(.data$seriesId == timeseries) |>
    dplyr::pull(.data$frequencyCode)

  class(df) <- c("bcch_series", class(df))

  df

}

#' Obtener lista de series disponibles por frecuencia y su metadata.
#'
#' @param user Nombre de usuario (obligatorio).
#' @param pass Contraseña (obligatorio).
#' @param frequency Frecuencia para la cual se quiere consultar el catálogo
#'   de series disponibles. Puede tomar los valores DAILY, MONTHLY, QUARTERLY
#'    o ANNUAL (obligatorio).
#'
#' @details https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm
#'
#' @examples
#'
#' \dontrun{
#' options(
#'  bcc_api_user = 178956728,
#'  bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#' bcch_SearchSeries("ANNUAL")
#'
#' }
#'
#' @export
bcch_SearchSeries <- function(
    frequency = NULL,
    user = getOption("bcc_api_user"),
    pass = getOption("bcc_api_pass")
    ){

  stopifnot(frequency %in% c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL"))

  qget <- httr::GET(
    "https://si3.bcentral.cl/SieteRestWS/SieteRestWS.ashx",
    query = list(
      user = user,
      pass = pass,
      `frequency` = frequency,
      `function` = "SearchSeries"
    )
  )

  content <- httr::content(qget)

  df <- content[["SeriesInfos"]] |>
    purrr::transpose() |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), unlist))

  df <- suppressMessages(
    readr::type_convert(df, na = c("", "NA", "NaN", "NeuN", "ND"))
    )

  df <- suppressMessages({
    df |>
      dplyr::mutate(
        dplyr::across(
          c(.data$firstObservation, .data$lastObservation,
            .data$updatedAt, .data$createdAt),
          lubridate::dmy
          )
        )
  })

  df

}

#' Descarga y leer Catálogo de Series
#'
#' @details https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm
#'
#' @examples
#'
#' \dontrun{
#' bcch_CatalogoSeries()
#' }
#'
#' @export
bcch_CatalogoSeries <- function(){

  url_path <- "https://si3.bcentral.cl/estadisticas/Principal1/Web_Services/Webservices/series.xlsx"

  tfile <- tempfile(fileext = ".xlsx")

  utils::download.file(url_path, tfile, method = "libcurl", mode = "wb")

  dfseries <- readxl::read_excel(tfile)

  dfseries

}

