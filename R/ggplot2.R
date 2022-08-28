#' @importFrom ggplot2 autoplot
#' @export
ggplot2::autoplot

#' autoplot generic method for bcch_series objects
#'
#' @param object A `bcch_series` object from `bcch_GetSeries`.
#' @param ... Extra `bcch_series` objects.
#'
#' @examples
#'
#' options(
#'   bcc_api_user = 178956728,
#'   bcc_api_pass = "cxynr4qyLLBw"
#' )
#'
#' fd <- lubridate::floor_date(Sys.Date(), unit = "year")
#'
#' x <- bcch_GetSeries("F049.DES.TAS.INE9.10.M", firstdate = fd)
#'
#' autoplot(x)
#'
#' x2 <- bcch_GetSeries("F073.TCO.PRE.Z.D", firstdate = fd)
#'
#' autoplot(x2)
#'
#' autoplot(x, x2)
#'
#' autoplot(x, x2) +
#'   ggplot2::facet_wrap(~descripEsp, scales = "free_y")
#'
#' @importFrom rlang .data
#' @export
autoplot.bcch_series <- function(object, ...){

  extra_objects <- list(...)

  x <- append(list(object), extra_objects)

  x <- purrr::map_df(x, ~ dplyr::mutate(.x, descripEsp = attr(.x, "descripEsp")))

  ggplot2::ggplot(x) +
    ggplot2::geom_line(ggplot2::aes(.data$indexDateString, .data$value, color = .data$descripEsp))

}




