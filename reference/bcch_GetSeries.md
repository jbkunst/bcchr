# Obtener los datos de una serie

Acceso directo a la operación `GetSeries` del API del Banco Central.
Para la interfaz moderna use
[`get_series()`](https://jkunst.com/bcchr/reference/get_series.md).

## Usage

``` r
bcch_GetSeries(timeseries, firstdate = NULL, lastdate = NULL, token = NULL)
```

## Arguments

- timeseries:

  Código exacto de la serie.

- firstdate:

  Fecha inicial opcional.

- lastdate:

  Fecha final opcional.

- token:

  Token del API del Banco Central.

## Value

Un tibble con los nombres originales entregados por el API.
