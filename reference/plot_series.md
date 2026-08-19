# Plot a Banco Central series

Plot a data frame returned by
[`get_series()`](https://jkunst.com/bcchr/reference/get_series.md). This
is a small convenience helper; it does not add classes or modify the
data.

## Usage

``` r
plot_series(x)
```

## Arguments

- x:

  A data frame returned by
  [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md)
  with `date` and `value` columns.

## Value

A ggplot object.
