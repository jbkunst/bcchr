# Resolver una descripcion a series del Banco Central

Busca en el catalogo del Banco Central usando uno o varios terminos
legibles por una persona y devuelve las series candidatas. Esta funcion
solo encuentra candidatos; no elige una serie por el usuario.

## Uso

``` r
resolve_series(
  query,
  frequency = NULL,
  token = NULL,
  verbose = getOption("bcchr.verbose", TRUE)
)
```

## Argumentos

- query:

  Vector de textos a buscar, por ejemplo `"imacec"` o
  `c("dolar observado", "unidad de fomento")`.

- frequency:

  Filtro opcional de frecuencia pasado a
  [`metadata()`](https://jkunst.com/bcchr/reference/metadata.md).

- token:

  Token de acceso a la API REST del Banco Central.

- verbose:

  Si es `TRUE`, informa cuando se consultan las cuatro frecuencias. Por
  defecto usa la opcion `bcchr.verbose` y luego `TRUE`.

## Valor

Un tibble con todas las series candidatas encontradas y una columna
`query` que identifica el texto que produjo cada resultado.

## Ejemplos

``` r
if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
  candidates <- resolve_series(
    c("dolar observado", "unidad de fomento"),
    frequency = "DAILY",
    verbose = FALSE
  )

  candidates[c("query", "series_id", "frequency", "spanish_title")] |>
    head()
}
#> # A tibble: 2 × 4
#>   query             series_id        frequency spanish_title                    
#>   <chr>             <chr>            <chr>     <chr>                            
#> 1 dolar observado   F073.TCO.PRE.Z.D DAILY     "Tipo de cambio nominal (dólar o…
#> 2 unidad de fomento F073.UFF.PRE.Z.D DAILY     "Unidad de fomento (UF)"         
```
