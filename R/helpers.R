#' Transformar la serie ej
#'
#' @param dfserie A objecto from `bcch_GetSeries`
#' @param tipo Tipo de variación porcentual `c("periodo_anterior", "anio_anterior")`
#'
#' @examples
#'
#' options(
#'  bcc_api_user = 178956728,
#'  bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#' codigo <- "F032.PIB.FLU.R.CLP.EP18.Z.Z.0.T"
#'
#' dfserie <- bcch_GetSeries(timeseries = codigo, firstdate = as.Date("2015-01-01"))
#'
#' dfserie2 <- bcch_calculo_var_porc(dfserie, tipo = "anio_anterior")
#'
#' autoplot(dfserie, dfserie2) +
#'   ggplot2::facet_wrap(~descripEsp, scales = "free") +
#'   ggplot2::theme(legend.position = "bottom")
#'
#' @export
bcch_calculo_var_porc <- function(dfserie,
                                  tipo = c("periodo_anterior", "anio_anterior")
){
  # tipo <- "periodo_anterior"
  # tipo <- "anio_anterior"
  freq <- attr(dfserie, "frequencyCode")

  stopifnot(any(class(dfserie) %in% "bcch_series"))
  stopifnot(!is.null(freq))
  stopifnot(tipo %in% c("periodo_anterior", "anio_anterior"))
  stopifnot(length(tipo) == 1)

  dfserie <- dplyr::arrange(dfserie, .data$indexDateString)

  if(tipo == "anio_anterior"){

    # UNITS <- c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")
    nlag <- dplyr::case_when(
      freq == "MONTHLY" ~ 12,
      freq == "QUARTERLY" ~ 4,
      freq == "ANNUAL" ~ 1,
    )

  } else {
    nlag <- 1
  }

  dfserie <- dfserie |>
    dplyr::mutate(
      value_prv = dplyr::lag(.data$value, n = nlag),
      value_new = .data$value/.data$value_prv - 1
    )

  dfserie <- dfserie |>
    dplyr::select(.data$indexDateString, value = .data$value_new, .data$statusCode)

  attr(dfserie, "descripEsp") <- stringr::str_c(
    attr(dfserie, "descripEsp"),
    stringr::str_glue(" variacion c/r {tipo}")
  )

  attr(dfserie, "bcch_calculo_var_porc") <- tipo

  dfserie

}
