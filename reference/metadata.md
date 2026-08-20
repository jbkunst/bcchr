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

  Filtro opcional de frecuencia. Puede ser `DAILY`, `MONTHLY`,
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
