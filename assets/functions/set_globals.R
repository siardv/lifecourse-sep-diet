set_globals <- function() {
  do.call(options, list(
    digits = 3, scipen = 50, knitr.kable.NA = "—",
    knitr.table.format = "html", max.print = 250, width = 170
  ))
  knitr::opts_knit$set(progress = FALSE, verbose = FALSE)
  knitr::opts_chunk$set(cache = FALSE)
  ok <- tryCatch(
    {
      sysfonts::font_add_google("EB Garamond", "Garamond")
      TRUE
    },
    error = function(e) FALSE
  )
  base_family <- if (ok) {
    "Garamond"
  } else {
    ""
  }
  if (ok) {
    showtext::showtext_auto()
    showtext::showtext_opts(dpi = 300)
  }
  garamond_theme <- ggplot2::theme_classic(
    base_size = 12,
    base_family = "Garamond"
  ) + ggplot2::theme(
    plot.title = ggplot2::element_text(
      size = 14,
      face = "bold", hjust = 0.5, margin = ggplot2::margin(b = 10)
    ),
    plot.subtitle = ggplot2::element_text(
      size = 12, face = "italic",
      hjust = 0.5, margin = ggplot2::margin(b = 10)
    ), plot.caption = ggplot2::element_text(
      size = 10,
      face = "italic", hjust = 0, margin = ggplot2::margin(t = 10)
    ),
    axis.title = ggplot2::element_text(face = "bold"), panel.grid.major = ggplot2::element_line(
      color = "grey80",
      linewidth = 0.5
    ), panel.grid.minor = ggplot2::element_line(
      color = "grey90",
      linewidth = 0.25
    ), plot.background = ggplot2::element_rect(
      fill = "white",
      colour = NA
    ), plot.margin = grid::unit(c(
      1, 1, 1,
      1
    ), "cm"), legend.position = "bottom", legend.box = "horizontal",
    legend.direction = "horizontal", legend.text = ggplot2::element_text(size = 8),
    legend.title = ggplot2::element_text(size = 8, face = "bold"),
    legend.background = ggplot2::element_rect(
      fill = "white",
      colour = "black"
    ), legend.key.size = grid::unit(
      0.4,
      "cm"
    ), legend.key.width = grid::unit(0.5, "cm"),
    legend.spacing.x = grid::unit(0.3, "cm"), legend.box.just = "center",
    legend.box.margin = ggplot2::margin(5, 5, 5, 5), legend.box.spacing = grid::unit(
      0,
      "cm"
    )
  )
  assign("garamond_theme", garamond_theme, envir = .GlobalEnv)
  ggplot2::theme_set(garamond_theme)
}
