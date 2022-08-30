#' @importFrom stats as.ts
#' @export
stats::as.ts

#' as.ts generic method for bcch_series objects
#'
#' @param x A `bcch_series` object
#' @param ... Arguments passed to methods.
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
#' serie_ts <- as.ts(dfserie)
#'
#' plot(serie_ts)
#'
#' @export
as.ts.bcch_series <- function(x, ...){

  fc <- attr(x, "frequencyCode")

  if(!is.null(fc)) {
    freq <- switch(
      fc,
      "QUARTERLY" = 4,
      "MONTHLY"   = 12
    )
  } else {
    freq <- NULL
  }

  serie_ts <- xts::xts(
    x = x[["value"]],
    order.by = x[["indexDateString"]],
    frequency = freq
    )

  serie_ts

}
