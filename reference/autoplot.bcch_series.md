# autoplot generic method for bcch_series objects

autoplot generic method for bcch_series objects

## Usage

``` r
# S3 method for class 'bcch_series'
autoplot(object, ...)
```

## Arguments

- object:

  A `bcch_series` object from `bcch_GetSeries`.

- ...:

  Extra `bcch_series` objects.

## Examples

``` r

if (FALSE) { # \dontrun{
options(
  bcc_api_user = 178956728,
  bcc_api_pass = "cxynr4qyLLBw"
)

fd <- lubridate::floor_date(Sys.Date(), unit = "year")

x <- bcch_GetSeries("F049.DES.TAS.INE9.10.M", firstdate = fd)

autoplot(x)

x2 <- bcch_GetSeries("F073.TCO.PRE.Z.D", firstdate = fd)

autoplot(x2)

autoplot(x, x2)

autoplot(x, x2) +
  ggplot2::facet_wrap(~descripEsp, scales = "free_y")

} # }
```
