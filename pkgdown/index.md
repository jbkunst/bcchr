# bcchr

`bcchr` es una interfaz pequeña para trabajar desde R con la Base de Datos Estadísticos del Banco Central de Chile.

El paquete separa deliberadamente cuatro tareas: **descubrir**, **resolver**, **describir** y **descargar** series. Las funciones aceptan uno o varios valores, devuelven tibbles simples y usan códigos exactos cuando corresponde.

## Autenticación

La API REST del Banco Central requiere un token. Guárdelo en la variable de entorno `BCCH_TOKEN`:

```text
BCCH_TOKEN=su_token
```

No guarde el token dentro de scripts ni lo publique en GitHub.

## Flujo principal

| Función | Para qué sirve |
|---|---|
| `metadata()` | Explorar las series disponibles |
| `resolve_series()` | Buscar candidatos desde uno o varios textos |
| `describe_series()` | Revisar la metadata de uno o varios códigos exactos |
| `get_series()` | Descargar una o varias series en formato largo |
| `plot_series()` | Hacer un gráfico rápido con `ggplot2` |

## Ejemplo: tasa de desempleo

En la BDE del Banco Central la tasa de desempleo aparece como **tasa de desocupación**. Primero buscamos candidatos:

```r
library(bcchr)

candidatos <- resolve_series(
  "desocupacion",
  frequency = "MONTHLY"
)

candidatos |> head()
```

La serie nacional mensual no ajustada del INE es `F049.DES.TAS.INE9.10.M`. Con el código exacto podemos describirla y descargarla:

```r
serie <- "F049.DES.TAS.INE9.10.M"

describe_series(serie)

desempleo <- get_series(
  serie,
  from = "2020-01-01"
)

tail(desempleo)
```

Y para una inspección rápida:

```r
plot_series(desempleo)
```

También se pueden descargar varias series en una sola llamada:

```r
indicadores <- get_series(
  c("F073.TCO.PRE.Z.D", "F073.UFF.PRE.Z.D"),
  from = "2025-01-01",
  to = "2025-03-31"
)

plot_series(indicadores)
```

Para un ejemplo ejecutado y una personalización con `ggplot2`, vea [Visualización con ggplot2](articles/ggplot.html).

## Explorar el catálogo

Si ya conoce la frecuencia, especificarla evita consultas innecesarias:

```r
metadata("MONTHLY") |> head()
```

Sin frecuencia, `metadata()` consulta `DAILY`, `MONTHLY`, `QUARTERLY` y `ANNUAL`. Puede silenciar el aviso con `verbose = FALSE` o globalmente con:

```r
options(bcchr.verbose = FALSE)
```

## API de bajo nivel

`bcch_GetSeries()` y `bcch_SearchSeries()` reflejan directamente las dos operaciones oficiales del Banco Central y se mantienen disponibles para quienes necesiten trabajar con los nombres de campos originales.
