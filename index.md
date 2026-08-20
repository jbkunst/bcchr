# bcchr

`bcchr` permite descubrir, describir y descargar series de la Base de
Datos Estadísticos del Banco Central de Chile desde R.

La interfaz principal usa nombres simples en `snake_case` y devuelve
tibbles con columnas consistentes. Las funciones de bajo nivel que
reflejan directamente las operaciones oficiales `GetSeries` y
`SearchSeries` siguen disponibles por compatibilidad.

Más información sobre la API del Banco Central en
<https://si3.bcentral.cl/estadisticas/Principal1/web_services/index.htm>.

## Instalación

``` r

# install.packages("devtools")
devtools::install_github("jbkunst/bcchr")
```

## Autenticación

La API REST del Banco Central requiere un token. Guárdelo en la variable
de entorno `BCCH_TOKEN`, por ejemplo en su archivo `.Renviron`:

``` text
BCCH_TOKEN=su_token
```

No guarde el token dentro de scripts ni lo suba a GitHub. Todos los
ejemplos que consultan directamente la API requieren que `BCCH_TOKEN`
esté configurado.

Puede verificar que R lo encuentre sin imprimirlo:

``` r

nzchar(Sys.getenv("BCCH_TOKEN"))
```

## Uso

### Ejemplo completo: tasa de desempleo

Supongamos que queremos obtener la tasa de desempleo de Chile. En la BDE
del Banco Central la serie se publica con el nombre **tasa de
desocupación**, por lo que primero buscamos candidatos con
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md):

``` r

library(bcchr)

# Requiere BCCH_TOKEN configurado; ver Autenticación.
candidatos <- resolve_series(
  "desocupacion",
  frequency = "MONTHLY"
)

candidatos |> head()
```

Entre los resultados está la serie nacional mensual no ajustada del INE,
`F049.DES.TAS.INE9.10.M`. Una vez que conocemos el código exacto,
podemos revisar su metadata:

``` r

serie <- "F049.DES.TAS.INE9.10.M"

describe_series(serie)
```

Luego descargamos las observaciones.
[`get_series()`](https://jkunst.com/bcchr/reference/get_series.md) no
interpreta nombres: recibe el código exacto y opcionalmente un rango de
fechas.

``` r

desempleo <- get_series(
  serie,
  from = "2020-01-01"
)

tail(desempleo)
```

Y para una visualización rápida:

``` r

plot_series(desempleo)
```

[`plot_series()`](https://jkunst.com/bcchr/reference/plot_series.md)
devuelve un objeto `ggplot`, por lo que puede seguir agregando capas o
temas de `ggplot2` normalmente.

### Explorar el catálogo completo

Cuando no tiene todavía un concepto específico para buscar,
[`metadata()`](https://jkunst.com/bcchr/reference/metadata.md) permite
revisar el catálogo disponible. Si conoce la frecuencia, indicarla evita
consultas innecesarias:

``` r

metadata("MONTHLY") |> head()
```

Si no especifica una frecuencia,
[`metadata()`](https://jkunst.com/bcchr/reference/metadata.md) consulta
`DAILY`, `MONTHLY`, `QUARTERLY` y `ANNUAL`. El paquete informa este
comportamiento porque requiere cuatro requests. El mensaje puede
desactivarse para una llamada con `verbose = FALSE` o globalmente con:

``` r

options(bcchr.verbose = FALSE)
```

## API de bajo nivel

[`bcch_GetSeries()`](https://jkunst.com/bcchr/reference/bcch_GetSeries.md)
y
[`bcch_SearchSeries()`](https://jkunst.com/bcchr/reference/bcch_SearchSeries.md)
se mantienen para quienes necesiten trabajar directamente con las dos
operaciones oficiales del Banco Central y sus nombres de campos
originales. Para código nuevo se recomienda la interfaz
[`metadata()`](https://jkunst.com/bcchr/reference/metadata.md) /
[`resolve_series()`](https://jkunst.com/bcchr/reference/resolve_series.md)
/
[`describe_series()`](https://jkunst.com/bcchr/reference/describe_series.md)
/ [`get_series()`](https://jkunst.com/bcchr/reference/get_series.md).
