# Obtener las series disponibles por frecuencia

Acceso directo a la operación `SearchSeries` del API del Banco Central.
Para la interfaz moderna use
[`metadata()`](https://jkunst.com/bcchr/reference/metadata.md) o
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md).

## Usage

``` r
bcch_SearchSeries(frequency, token = NULL)
```

## Arguments

- frequency:

  Frecuencia: `DAILY`, `MONTHLY`, `QUARTERLY` o `ANNUAL`.

- token:

  Token del API del Banco Central.

## Value

Un tibble con los nombres originales entregados por el API.
