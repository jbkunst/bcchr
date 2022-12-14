% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{bcch_calculo_var_porc}
\alias{bcch_calculo_var_porc}
\title{Transformar la serie ej}
\usage{
bcch_calculo_var_porc(dfserie, tipo = c("periodo_anterior", "anio_anterior"))
}
\arguments{
\item{dfserie}{A objecto from \code{bcch_GetSeries}}

\item{tipo}{Tipo de variación porcentual \code{c("periodo_anterior", "anio_anterior")}}
}
\description{
Transformar la serie ej
}
\examples{

options(
 bcc_api_user = 178956728,
 bcc_api_pass = "cxynr4qyLLBw"
)

codigo <- "F032.PIB.FLU.R.CLP.EP18.Z.Z.0.T"

dfserie <- bcch_GetSeries(timeseries = codigo, firstdate = as.Date("2015-01-01"))

dfserie2 <- bcch_calculo_var_porc(dfserie, tipo = "anio_anterior")

autoplot(dfserie, dfserie2) +
  ggplot2::facet_wrap(~descripEsp, scales = "free") +
  ggplot2::theme(legend.position = "bottom")

}
