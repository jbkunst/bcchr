# Changelog

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
