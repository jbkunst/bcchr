#' Graficar series del Banco Central
#'
#' Grafica un data frame devuelto por [get_series()]. Cuando contiene varias
#' series, usa `series_id` para separarlas. Es una ayuda pequeña de
#' visualizacion: no agrega clases ni modifica los datos.
#'
#' @param x Data frame devuelto por [get_series()] con las columnas `date` y
#'   `value`.
#'
#' @return Un objeto ggplot.
#'
#' @examples
#' if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
#'   indicators <- get_series(
#'     c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
#'     from = "2025-01-01",
#'     to = "2025-03-31"
#'   )
#'
#'   plot_series(indicators)
#' }
#' @importFrom rlang .data
#' @export
plot_series <- function(x) {

  rlang::check_installed("ggplot2", reason = "para usar `plot_series()`")

  if (!all(c("date", "value") %in% names(x))) {
    stop("`x` debe contener las columnas `date` y `value`.", call. = FALSE)
  }

  multiple_series <- "series_id" %in% names(x) &&
    length(unique(x$series_id)) > 1L

  chart <- if (multiple_series) {
    ggplot2::ggplot(
      x,
      ggplot2::aes(
        x = .data$date,
        y = .data$value,
        color = .data$series_id,
        group = .data$series_id
      )
    )
  } else {
    ggplot2::ggplot(x, ggplot2::aes(x = .data$date, y = .data$value))
  }

  chart +
    ggplot2::geom_line() +
    ggplot2::labs(color = NULL) +
    ggplot2::theme_minimal()
}
