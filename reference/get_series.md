# Obtener observaciones de series del Banco Central

Obtiene las observaciones de una o varias series identificadas por sus
codigos exactos y, opcionalmente, un rango de fechas comun. Esta funcion
solo obtiene datos para los codigos entregados; nunca interpreta ni
resuelve nombres de series.

## Uso

``` r
get_series(series_id, from = NULL, to = NULL, token = NULL)
```

## Argumentos

- series_id:

  Vector de codigos exactos de series del Banco Central.

- from:

  Fecha inicial opcional en formato `YYYY-MM-DD` o como objeto `Date`.

- to:

  Fecha final opcional en formato `YYYY-MM-DD` o como objeto `Date`.

- token:

  Token de acceso a la API REST del Banco Central. Por defecto lee la
  opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.

## Valor

Un tibble en formato largo con las columnas `series_id`, `date`, `value`
y `status_code`.

## Ejemplos

``` r
if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
  indicators <- get_series(
    c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
    from = "2025-01-02",
    to = "2025-01-05"
  )

  indicators |> head()
}
#> # A tibble: 6 × 4
#>   series_id        date        value status_code
#>   <chr>            <date>      <dbl> <chr>      
#> 1 F073.TCO.PRE.Z.D 2025-01-02   996. OK         
#> 2 F073.TCO.PRE.Z.D 2025-01-03  1000. OK         
#> 3 F073.UFF.PRE.Z.D 2025-01-02 38422. OK         
#> 4 F073.UFF.PRE.Z.D 2025-01-03 38424. OK         
#> 5 F073.UFF.PRE.Z.D 2025-01-04 38427. OK         
#> 6 F073.UFF.PRE.Z.D 2025-01-05 38429. OK         
```
