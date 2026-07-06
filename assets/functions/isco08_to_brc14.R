isco08_to_brc14 <- function(x) {
  m <- brc14_map()
  purrr::map_dbl(x, ~ m$BRC2014beroepsgroep[match(.x, m$ISCO2008unitgroup,
    nomatch = NA
  )])
}
