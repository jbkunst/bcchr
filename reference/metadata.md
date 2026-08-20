# Metadata de las series

Obtiene el catalogo actual de series disponibles del Banco Central de
Chile. Use esta funcion para conocer que series existen, su frecuencia y
su cobertura temporal.

## Uso

``` r
metadata(
  frequency = NULL,
  token = NULL,
  verbose = getOption("bcchr.verbose", TRUE)
)
```

## Argumentos

- frequency:

  Vector opcional de frecuencias. Puede contener `DAILY`, `MONTHLY`,
  `QUARTERLY` o `ANNUAL`. Si se omite, devuelve todas las frecuencias.

- token:

  Token de acceso a la API REST del Banco Central. Por defecto lee la
  opcion `bcch_api_token` y luego la variable de entorno `BCCH_TOKEN`.

- verbose:

  Si es `TRUE`, informa cuando se consultan las cuatro frecuencias. Por
  defecto usa la opcion `bcchr.verbose` y luego `TRUE`.

## Valor

Un tibble con la metadata de las series y nombres de columnas en
snake_case.

## Ejemplos

``` r
if (nzchar(Sys.getenv("BCCH_TOKEN"))) {
  metadata(c("MONTHLY", "QUARTERLY"), verbose = FALSE) |>
    head()
}
#> # A tibble: 6 × 8
#>   series_id           frequency spanish_title    english_title first_observation
#>   <chr>               <chr>     <chr>            <chr>         <date>           
#> 1 G073.IPC.IND.2018.M MONTHLY   IPC General his… Historical H… 1989-04-01       
#> 2 G073.IPC.IND.2023.M MONTHLY   General (empalm… Headline (CB… 1998-12-01       
#> 3 G073.IPC.V12.2018.M MONTHLY   IPC General his… Historical H… 1990-04-01       
#> 4 G073.IPC.V12.2023.M MONTHLY   General (empalm… Headline (CB… 1999-12-01       
#> 5 G073.IPC.VAR.2018.M MONTHLY   IPC General his… Historical H… 1989-05-01       
#> 6 G073.IPC.VAR.2023.M MONTHLY   General (empalm… Headline (CB… 1999-01-01       
#> # ℹ 3 more variables: last_observation <date>, updated_at <date>,
#> #   created_at <date>
```
