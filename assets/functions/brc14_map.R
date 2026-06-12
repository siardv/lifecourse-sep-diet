brc14_map <- function() {
  local_file <- here::here("assets", "data", "brc2014.xls")
  if (!file.exists(local_file)) {
    download_url <- glue(
      "https://www.cbs.nl/-/media/imported/",
      "onze-diensten/methoden/classificaties/", "documents/2015/09/brc2014.xls"
    )
    download.file(download_url, local_file, mode = "wb")
  }
  m <- readxl::read_excel(local_file, sheet = 2)
  m$ISCO2008unitgroup <- as.numeric(m$ISCO2008unitgroup)
  m$BRC2014beroepsgroep <- as.numeric(m$BRC2014beroepsgroep)
  stopifnot(!anyNA(m$ISCO2008unitgroup), !anyNA(m$BRC2014beroepsgroep))
  m
}
