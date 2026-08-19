# Resolve a human description to Banco Central series

Search the Banco Central catalog using a human-readable term and return
the matching series candidates. This function finds candidates only; it
does not choose a series on the user's behalf.

## Usage

``` r
resolve_series(query, frequency = NULL, token = NULL)
```

## Arguments

- query:

  Text to search for, such as `"imacec"` or `"dolar observado"`.

- frequency:

  Optional frequency filter passed to
  [`metadata()`](https://jkunst.com/bcchr/reference/metadata.md).

- token:

  Banco Central REST API token.

## Value

A tibble with every matching series candidate.
