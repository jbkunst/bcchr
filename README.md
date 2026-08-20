# bcchr

[![R-CMD-check](https://github.com/jbkunst/bcchr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jbkunst/bcchr/actions/workflows/R-CMD-check.yaml)

Cliente R pequeño para descubrir, describir y descargar una o varias series de la Base de Datos Estadísticos del Banco Central de Chile.

Documentación completa: <https://jkunst.com/bcchr/>

## Instalación

```r
# install.packages("remotes")
remotes::install_github("jbkunst/bcchr")
```

## Autenticación

La API REST del Banco Central requiere un token. La forma recomendada es guardarlo en `BCCH_TOKEN`, por ejemplo en `~/.Renviron`:

```text
BCCH_TOKEN=su_token
```

Puede comprobar que R lo encuentra sin imprimirlo:

```r
nzchar(Sys.getenv("BCCH_TOKEN"))
```

No guarde el token en scripts ni lo suba al repositorio.

## Uso rápido

La interfaz principal sigue un flujo simple: buscar una serie, revisar su metadata y descargarla usando su código exacto.

```r
library(bcchr)

candidatos <- resolve_series(
  "desocupacion",
  frequency = "MONTHLY"
)

serie <- "F049.DES.TAS.INE9.10.M"

describe_series(serie)

desempleo <- get_series(
  serie,
  from = "2020-01-01"
)

plot_series(desempleo)
```

Las funciones principales también aceptan vectores. `get_series()` devuelve los
resultados en formato largo, identificados por `series_id`:

```r
indicadores <- get_series(
  c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
  from = "2025-01-01",
  to = "2025-03-31"
)

plot_series(indicadores)
```

Para explorar el catálogo directamente:

```r
metadata("MONTHLY") |> head()
```

## Interfaz

- `metadata()`: descubre las series disponibles y su cobertura.
- `resolve_series()`: busca candidatos para uno o varios textos humanos.
- `describe_series()`: describe uno o varios códigos exactos.
- `get_series()`: descarga una o varias series en formato largo.
- `plot_series()`: gráfico rápido opcional con `ggplot2`.

`bcch_GetSeries()` y `bcch_SearchSeries()` siguen disponibles como API de bajo nivel para trabajar directamente con las dos operaciones oficiales del Banco Central.

## Desarrollo

La versión actual es `0.1.0`. El paquete mantiene deliberadamente un core pequeño y evita clases, cachés y dependencias adicionales cuando no son necesarias.

La versión anterior completa permanece disponible en el tag `v0.0.2`.
