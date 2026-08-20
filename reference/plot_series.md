# Graficar series del Banco Central

Grafica un data frame devuelto por
[`get_series()`](https://jkunst.com/bcchr/reference/get_series.md).
Cuando contiene varias series, usa `series_id` para separarlas. Es una
ayuda pequeña de visualizacion: no agrega clases ni modifica los datos.

## Uso

``` r
plot_series(x)
```

## Argumentos

- x:

  Data frame devuelto por
  [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md) con
  las columnas `date` y `value`.

## Valor

Un objeto ggplot.

## Ejemplos

``` r
if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
  indicators <- get_series(
    c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
    from = "2025-01-01",
    to = "2025-03-31"
  )

  plot_series(indicators)
}
```
