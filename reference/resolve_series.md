# Resolver una descripcion a series del Banco Central

Busca en el catalogo del Banco Central usando un termino legible por una
persona y devuelve las series candidatas. Esta funcion solo encuentra
candidatos; no elige una serie por el usuario.

## Usage

``` r
resolve_series(
  query,
  frequency = NULL,
  token = NULL,
  verbose = getOption("bcchr.verbose", TRUE)
)
```

## Arguments

- query:

  Texto a buscar, por ejemplo `"imacec"` o `"dolar observado"`.

- frequency:

  Filtro opcional de frecuencia pasado a
  [`metadata()`](https://jkunst.com/bcchr/reference/metadata.md).

- token:

  Token de acceso a la API REST del Banco Central.

- verbose:

  Si es `TRUE`, informa cuando se consultan las cuatro frecuencias. Por
  defecto usa la opcion `bcchr.verbose` y luego `TRUE`.

## Value

Un tibble con todas las series candidatas encontradas.
