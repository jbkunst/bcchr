#' Graficar una serie del Banco Central
#'
#' Grafica un data frame devuelto por [get_series()]. Es una ayuda pequeña de
#' visualización: no agrega clases ni modifica los datos.
#'
#' @param x Data frame devuelto por [get_series()] con las columnas `date` y
#'   `value`.
#'
#' @return Un objeto ggplot.
#' @importFrom rlang .data
#' @export
plot_series <- function(x) {

  rlang::check_installed("ggplot2", reason = "para usar `plot_series()`")

  if (!all(c("date", "value") %in% names(x))) {
    stop("`x` debe contener las columnas `date` y `value`.", call. = FALSE)
  }

  ggplot2::ggplot(x, ggplot2::aes(x = .data$date, y = .data$value)) +
    ggplot2::geom_line()
}
