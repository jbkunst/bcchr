usethis::use_package("httr")
usethis::use_package("readr")
usethis::use_package("purrr")
usethis::use_package("tibble")
usethis::use_package("dplyr")
usethis::use_package("lubridate")
usethis::use_package("ggplot2")
usethis::use_package("rlang")
usethis::use_package("readxl")
usethis::use_package("utils")

usethis::use_mit_license()

usethis::use_github_actions_badge()

usethis::use_github_action_check_standard()

# pkgdown -----------------------------------------------------------------
usethis::use_pkgdown()
usethis::use_pkgdown_github_pages()

# test pkgdown ------------------------------------------------------------
pkgdown::init_site()
pkgdown::build_home(preview = TRUE)

