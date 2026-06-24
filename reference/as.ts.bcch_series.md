# as.ts generic method for bcch_series objects

as.ts generic method for bcch_series objects

## Usage

``` r
# S3 method for class 'bcch_series'
as.ts(x, ...)
```

## Arguments

- x:

  A `bcch_series` object

- ...:

  Arguments passed to methods.

## Examples

``` r

if (FALSE) { # \dontrun{
options(
 bcc_api_user = 178956728,
 bcc_api_pass = "cxynr4qyLLBw"
)

codigo <- "F032.PIB.FLU.R.CLP.EP18.Z.Z.0.T"

dfserie <- bcch_GetSeries(timeseries = codigo, firstdate = as.Date("2015-01-01"))

serie_ts <- as.ts(dfserie)

plot(serie_ts)

} # }
```
