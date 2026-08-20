# bcchr 0.1.0.9000

* `metadata()`, `resolve_series()`, `describe_series()` y `get_series()` ahora
  aceptan vectores. Las consultas de varias series reutilizan la metadata y
  devuelven resultados en formato largo.
* `get_series()` agrega `series_id` a su resultado y respeta el limite oficial
  de cinco consultas de series por segundo.
* `plot_series()` separa automaticamente varias series y la referencia de
  pkgdown incorpora ejemplos ejecutables cuando `BCCH_TOKEN` esta disponible.

# bcchr 0.1.0

## Interfaz moderna

* Nueva interfaz en `snake_case` para el flujo principal: `metadata()`,
  `resolve_series()`, `describe_series()` y `get_series()`.
* `resolve_series()` concentra la búsqueda por texto humano y devuelve candidatos;
  `describe_series()` y `get_series()` trabajan con códigos exactos.
* `get_series()` devuelve una estructura simple con `date`, `value` y
  `status_code`.
* `metadata()` consulta el catálogo vigente del Banco Central en vez de depender
  de un catálogo empaquetado.

## API y autenticación

* Autenticación migrada a API token mediante `BCCH_TOKEN`, la opción
  `bcch_api_token` o el argumento `token`.
* `bcch_GetSeries()` y `bcch_SearchSeries()` se mantienen como capa de bajo nivel
  que refleja las dos operaciones oficiales de la API.
* Cuando una búsqueda requiere consultar las cuatro frecuencias, el paquete lo
  informa. El mensaje puede desactivarse con `verbose = FALSE` o
  `options(bcchr.verbose = FALSE)`.

## Paquete y documentación

* Se eliminan del core el catálogo empaquetado, helpers de transformación y
  métodos S3 antiguos. La versión completa anterior queda disponible en el tag
  `v0.0.2`.
* Se reducen las dependencias del core a `httr`, `jsonlite`, `rlang` y `tibble`.
* Se agrega `plot_series()` como helper opcional basado en `ggplot2`.
* README y referencia de pkgdown ahora priorizan la interfaz moderna y agrupan la
  API de bajo nivel al final.
* Se agrega la vignette **Visualización con ggplot2**, con un ejemplo inspirado
  en el dashboard de indicadores financieros: historia reciente, último valor,
  variación y fecha del último dato.
* Se actualiza la identidad visual de pkgdown con navy, azul y dorado inspirados
  en el Banco Central de Chile.

# bcchr 0.0.2

* Fixed `bcch_GetSeries()` JSON parsing for Banco Central responses encoded as
  `ISO-8859-1` by reading raw bytes, converting to `UTF-8`, and parsing with
  `jsonlite`.
* Added explicit Banco Central API error handling in `bcch_GetSeries()`.
* Added `jsonlite` to `Imports`.
* Updated the minimum R version to 4.1.0 because the package uses the native
  pipe operator `|>`.
