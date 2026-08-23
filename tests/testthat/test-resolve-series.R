catalog <- tibble::tibble(
  series_id = c("F032.IMC.IND.Z.Z.EP18.C.M", "F049.DES.TAS.INE.M", "F073.TCO.PRE.Z.D"),
  frequency = c("MONTHLY", "MONTHLY", "DAILY"),
  spanish_title = c(
    "IMACEC empalmado, serie original",
    "Tasa de desempleo mensual nacional INE (porcentaje)",
    "Tipo de cambio del dólar observado"
  ),
  english_title = c("Monthly economic activity index", NA_character_, "Observed dollar exchange rate"),
  first_observation = c("1996-01-01", "2010-01-01", "1984-01-01"),
  last_observation = c("2026-01-01", "2026-01-01", "2026-01-01"),
  updated_at = rep("2026-02-01", 3),
  created_at = rep("2020-01-01", 3)
)

mock_metadata <- function(frequency = NULL, token = NULL, verbose = TRUE) catalog

test_that("resolve_series encuentra una consulta de una palabra", {
  local_mocked_bindings(metadata = mock_metadata, .package = "bcchr")

  result <- resolve_series("IMACEC")

  expect_equal(result$series_id, "F032.IMC.IND.Z.Z.EP18.C.M")
  expect_equal(result$query, "IMACEC")
})

test_that("resolve_series aplica AND a palabras no contiguas", {
  local_mocked_bindings(metadata = mock_metadata, .package = "bcchr")

  result <- resolve_series("desempleo INE")

  expect_equal(result$spanish_title, "Tasa de desempleo mensual nacional INE (porcentaje)")
})

test_that("resolve_series ignora mayusculas y acentos", {
  local_mocked_bindings(metadata = mock_metadata, .package = "bcchr")

  result <- resolve_series("DÓLAR observado")

  expect_equal(result$series_id, "F073.TCO.PRE.Z.D")
})

test_that("resolve_series conserva consultas multiples y el esquema", {
  local_mocked_bindings(metadata = mock_metadata, .package = "bcchr")

  result <- resolve_series(c("desempleo INE", "dólar observado"))

  expect_equal(result$query, c("desempleo INE", "dólar observado"))
  expect_equal(result$series_id, c("F049.DES.TAS.INE.M", "F073.TCO.PRE.Z.D"))
  expect_equal(names(result), c("query", names(catalog)))
})

test_that("resolve_series devuelve un resultado vacio con las mismas columnas", {
  local_mocked_bindings(metadata = mock_metadata, .package = "bcchr")

  result <- resolve_series("serie inexistente")

  expect_equal(nrow(result), 0L)
  expect_equal(names(result), c("query", names(catalog)))
})
