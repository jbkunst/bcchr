# Get observations for one Banco Central series

Retrieve observations for one exact Banco Central series code and an
optional date range. This function does one thing only: it retrieves
data for the code supplied. It never interprets or resolves
human-readable series names.

## Uso

``` r
get_series(series_id, from = NULL, to = NULL, token = NULL)
```

## Argumentos

- series_id:

  Exact Banco Central series code.

- from:

  Optional first date in `YYYY-MM-DD` format or a `Date`.

- to:

  Optional last date in `YYYY-MM-DD` format or a `Date`.

- token:

  Banco Central REST API token. By default it reads the `bcch_api_token`
  option and then the `BCCH_TOKEN` environment variable.

## Valor

A tibble with `date`, `value`, and `status_code`.
