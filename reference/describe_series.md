# Describir una serie del Banco Central

Devuelve la metadata de una serie identificada por su codigo exacto.
Esta funcion no interpreta nombres en lenguaje natural. Use
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md)
primero cuando no conozca el codigo de la serie.

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

  Codigo exacto de la serie del Banco Central.

- token:

  Token de acceso a la API REST del Banco Central.

- verbose:

  Si es `TRUE`, informa cuando se consultan las cuatro frecuencias. Por
  defecto usa la opcion `bcchr.verbose` y luego `TRUE`.

## Valor

Un tibble de una fila con la descripcion de la serie.
