# Changelog

## bcchr 0.1.0

### Interfaz moderna

- Nueva interfaz en `snake_case` para el flujo principal:
  [`metadata()`](https://jkunst.com/bcchr/reference/metadata.md),
  [`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md),
  [`describe_series()`](https://jkunst.com/bcchr/reference/describe_series.md)
  y [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md).
- [`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md)
  concentra la búsqueda por texto humano y devuelve candidatos;
  [`describe_series()`](https://jkunst.com/bcchr/reference/describe_series.md)
  y [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md)
  trabajan con códigos exactos.
- [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md)
  devuelve una estructura simple con `date`, `value` y `status_code`.
- [`metadata()`](https://jkunst.com/bcchr/reference/metadata.md)
  consulta el catálogo vigente del Banco Central en vez de depender de
  un catálogo empaquetado.

### API y autenticación

- Autenticación migrada a API token mediante `BCCH_TOKEN`, la opción
  `bcch_api_token` o el argumento `token`.
- [`bcch_GetSeries()`](https://jkunst.com/bcchr/reference/bcch_GetSeries.md)
  y
  [`bcch_SearchSeries()`](https://jkunst.com/bcchr/reference/bcch_SearchSeries.md)
  se mantienen como capa de bajo nivel que refleja las dos operaciones
  oficiales de la API.
- Cuando una búsqueda requiere consultar las cuatro frecuencias, el
  paquete lo informa. El mensaje puede desactivarse con
  `verbose = FALSE` o `options(bcchr.verbose = FALSE)`.

### Paquete y documentación

- Se eliminan del core el catálogo empaquetado, helpers de
  transformación y métodos S3 antiguos. La versión completa anterior
  queda disponible en el tag `v0.0.2`.
- Se reducen las dependencias del core a `httr`, `jsonlite`, `rlang` y
  `tibble`.
- Se agrega
  [`plot_series()`](https://jkunst.com/bcchr/reference/plot_series.md)
  como helper opcional basado en `ggplot2`.
- README y referencia de pkgdown ahora priorizan la interfaz moderna y
  agrupan la API de bajo nivel al final.
- Se agrega la vignette **Visualización con ggplot2**, con un ejemplo
  inspirado en el dashboard de indicadores financieros: historia
  reciente, último valor, variación y fecha del último dato.
- Se actualiza la identidad visual de pkgdown con navy, azul y dorado
  inspirados en el Banco Central de Chile.

## bcchr 0.0.2

- Fixed
  [`bcch_GetSeries()`](https://jkunst.com/bcchr/reference/bcch_GetSeries.md)
  JSON parsing for Banco Central responses encoded as `ISO-8859-1` by
  reading raw bytes, converting to `UTF-8`, and parsing with `jsonlite`.
- Added explicit Banco Central API error handling in
  [`bcch_GetSeries()`](https://jkunst.com/bcchr/reference/bcch_GetSeries.md).
- Added `jsonlite` to `Imports`.
- Updated the minimum R version to 4.1.0 because the package uses the
  native pipe operator `|>`.
