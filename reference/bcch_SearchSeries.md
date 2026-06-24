# Obtener lista de series disponibles por frecuencia y su metadata.

Obtener lista de series disponibles por frecuencia y su metadata.

## Usage

``` r
bcch_SearchSeries(
  frequency = NULL,
  user = getOption("bcc_api_user"),
  pass = getOption("bcc_api_pass")
)
```

## Arguments

- frequency:

  Frecuencia para la cual se quiere consultar el catálogo de series
  disponibles. Puede tomar los valores DAILY, MONTHLY, QUARTERLY o
  ANNUAL (obligatorio).

- user:

  Nombre de usuario (obligatorio).

- pass:

  Contraseña (obligatorio).

## Details

https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm

## Examples

``` r

if (FALSE) { # \dontrun{
options(
 bcc_api_user = 178956728,
 bcc_api_pass = "cxynr4qyLLBw"
)

bcch_SearchSeries("ANNUAL")

} # }
```
