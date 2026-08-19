#' Plot a Banco Central series
#'
#' Plot a data frame returned by [get_series()]. This is a small convenience
#' helper; it does not add classes or modify the data.
#'
#' @param x A data frame returned by [get_series()] with `date` and `value`
#'   columns.
#'
#' @return A ggplot object.
#' @importFrom rlang .data
#' @export
plot_series <- function(x) {

  rlang::check_installed("ggplot2", reason = "to use `plot_series()`")

  if (!all(c("date", "value") %in% names(x))) {
    stop("`x` must contain `date` and `value` columns.", call. = FALSE)
  }

  ggplot2::ggplot(x, ggplot2::aes(x = .data$date, y = .data$value)) +
    ggplot2::geom_line()
}
