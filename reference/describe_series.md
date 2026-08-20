# Describir una serie del Banco Central

Devuelve la metadata de una o varias series identificadas por sus
codigos exactos. Esta funcion no interpreta nombres en lenguaje natural.
Use
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md)
primero cuando no conozca los codigos.

## Uso

``` r
describe_series(
  series_id,
  token = NULL,
  verbose = getOption("bcchr.verbose", TRUE)
)
```

## Argumentos

- series_id:

  Vector de codigos exactos de series del Banco Central.

- token:

  Token de acceso a la API REST del Banco Central.

- verbose:

  Si es `TRUE`, informa cuando se consultan las cuatro frecuencias. Por
  defecto usa la opcion `bcchr.verbose` y luego `TRUE`.

## Valor

Un tibble con una fila por cada codigo solicitado.

## Ejemplos

``` r
if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
  describe_series(
    c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
    verbose = FALSE
  )[c("series_id", "frequency", "spanish_title")]
}
#> # A tibble: 2 × 3
#>   series_id        frequency spanish_title                                      
#>   <chr>            <chr>     <chr>                                              
#> 1 F073.TCO.PRE.Z.D DAILY     "Tipo de cambio nominal (dólar observado $CLP/USD)…
#> 2 F073.UFF.PRE.Z.D DAILY     "Unidad de fomento (UF)"                           
```
