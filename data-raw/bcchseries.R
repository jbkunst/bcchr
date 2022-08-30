library(tidyverse)

# descarga ----------------------------------------------------------------
UNITS <- c("DAILY", "MONTHLY", "QUARTERLY", "ANNUAL")

bcchseries <- purrr::map_df(UNITS, bcch_SearchSeries)


# validacion --------------------------------------------------------------
bcchseries |>
  mutate(base = str_extract(spanishTitle, "=100")) |>
  select(-englishTitle) |>
  filter(!is.na(base))

dplyr::glimpse(bcchseries)

dplyr::bind_rows(bcchseries) |>
  dplyr::distinct(seriesId, .keep_all = TRUE)

series2 <- bcch_CatalogoSeries()

glimpse(series2)

bcchseries |>
  anti_join(series2, by = c("seriesId" = "Código")) |>
  View()


# export ------------------------------------------------------------------
bcchseries <- bcchseries |>
  dplyr::select(seriesId, frequencyCode, spanishTitle, englishTitle)

usethis::use_data(bcchseries, overwrite = TRUE)


