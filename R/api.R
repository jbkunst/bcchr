# user   <- 178956728
# pssw   <- "cxynr4qyLLBw"
# codigo <- "F049.DES.TAS.INE9.10.M"
#
# options(
#   bcc_api_user = 178956728,
#   bcc_api_pass = "cxynr4qyLLBw"
# )

#' Obtener lista de series disponibles por frecuencia y su metadata.
#'
#' @param user (obligatorio): completar nombre de usuario.
#' @param pass (obligatorio): completar contraseña.
#' @param frequency (obligatorio): completar con la frecuencia para la cual se quiere consultar el catálogo de series disponibles. Puede tomar los valores DAILY, MONTHLY, QUARTERLY o ANNUAL.
#'
#' @details https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm
#'
#' @examples
#'
#' options(
#'  bcc_api_user = 178956728,
#'  bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#' bcch_SearchSeries("ANNUAL")
#'
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

#' Bbtener los datos de series.
#'
#' @param timeseries (obligatorio): incorporar código de la serie de tiempo a consultar.
#' @param user (obligatorio): completar nombre de usuario.
#' @param pass (obligatorio): completar contraseña.
#' @param firstdate (opcional): ingresar fecha desde la cual se requiere recoger datos. Si el parámetro no está presente, se recoge por defecto desde el primer dato disponible.
#' @param lastdate (opcional): ingresar fecha hasta la cual se requiere recoger datos. Si el parámetro no está presente, se recoge por defecto hasta el último dato disponible.
#'
#' @details https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm
#'
#' @examples
#'
#' options(
#'  bcc_api_user = 178956728,
#'  bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#' bcch_GetSeries("F049.DES.TAS.INE9.10.M")
#'
#' bcch_GetSeries("F073.TCO.PRE.Z.D")
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

  content <- httr::content(qget)

  df <- content[["Series"]][["Obs"]] |>
    purrr::transpose() |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), unlist))

  df <- suppressMessages(readr::type_convert(df, na = c("", "NA", "NaN", "NeuN")))
  df <- dplyr::mutate(df, indexDateString = lubridate::dmy(.data$indexDateString))

  attr(df, "descripEsp") <- content$Series$descripEsp
  attr(df, "descripIng") <- content$Series$descripIng
  attr(df, "seriesId") <- content$Series$seriesId

  class(df) <- c("bcch_series", class(df))

  df

}


