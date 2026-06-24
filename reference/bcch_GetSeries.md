# Obtener los datos de series.

Obtener los datos de series.

## Usage

``` r
bcch_GetSeries(
  timeseries = NULL,
  user = getOption("bcc_api_user"),
  pass = getOption("bcc_api_pass"),
  firstdate = NULL,
  lastdate = NULL
)
```

## Arguments

- timeseries:

  Código de la serie de tiempo a consultar (obligatorio).

- user:

  Nombre de usuario (obligatorio).

- pass:

  Contraseña (obligatorio).

- firstdate:

  Fecha desde la cual se requiere recoger datos. Si el parámetro no está
  presente, se recoge por defecto desde el primer dato disponible
  (opcional).

- lastdate:

  Fecha hasta la cual se requiere recoger datos. Si el parámetro no está
  presente, se recoge por defecto hasta el último dato disponible
  (opcional).

## Details

https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm

## Examples

``` r

if (FALSE) { # \dontrun{
options(
 bcc_api_user = 178956728,
 bcc_api_pass = "cxynr4qyLLBw"
)



} # }
```
