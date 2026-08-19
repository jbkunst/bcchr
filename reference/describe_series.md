# Describe one Banco Central series

Return metadata for one exact Banco Central series code. This function
does not interpret human-readable names. Use
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md)
first when the series code is unknown.

## Usage

``` r
describe_series(series_id, token = NULL)
```

## Arguments

- series_id:

  Exact Banco Central series code.

- token:

  Banco Central REST API token.

## Value

A one-row tibble describing the series.
