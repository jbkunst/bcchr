# Series metadata

Get the current Banco Central series catalog. Use this function to
inspect which series exist and their frequency and temporal coverage.

## Usage

``` r
metadata(frequency = NULL, token = NULL)
```

## Arguments

- frequency:

  Optional frequency filter. One of `DAILY`, `MONTHLY`, `QUARTERLY`, or
  `ANNUAL`. When omitted, all frequencies are returned.

- token:

  Banco Central REST API token. By default it reads the `bcch_api_token`
  option and then the `BCCH_TOKEN` environment variable.

## Value

A tibble with series metadata using snake_case column names.
