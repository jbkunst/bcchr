# Transformar la serie ej

Transformar la serie ej

## Usage

``` r
bcch_calculo_var_porc(dfserie, tipo = c("periodo_anterior", "anio_anterior"))
```

## Arguments

- dfserie:

  A objecto from `bcch_GetSeries`

- tipo:

  Tipo de variación porcentual `c("periodo_anterior", "anio_anterior")`

## Examples

``` r

if (FALSE) { # \dontrun{
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

} # }
```
