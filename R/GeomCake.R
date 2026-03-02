#' @rdname geom_cake
#' @format NULL
#' @usage NULL
#' @export
GeomCake <- ggproto("GeomCake", Geom,
  required_aes = c("xmin", "xmax", "ymin", "ymax"),

  default_aes = aes(
    colour = "white",
    fill = "grey35",
    linewidth = 0.5,
    alpha = 1
  ),

  draw_key = draw_key_rect,

  draw_panel = function(data, panel_params, coord, show_labels = TRUE) {
    coords <- coord$transform(data, panel_params)

    # Build rectangle grobs for each slice
    rect_grobs <- lapply(seq_len(nrow(coords)), function(i) {
      grid::rectGrob(
        x = coords$xmin[i],
        y = coords$ymin[i],
        width = coords$xmax[i] - coords$xmin[i],
        height = coords$ymax[i] - coords$ymin[i],
        just = c("left", "bottom"),
        gp = grid::gpar(
          col = coords$colour[i],
          fill = scales::alpha(coords$fill[i], coords$alpha[i]),
          lwd = coords$linewidth[i] * .pt
        )
      )
    })

    # Build text grobs for percentage labels
    text_grobs <- list()
    if (show_labels && "pct_text" %in% names(data)) {
      # Transform label positions
      label_data <- data.frame(
        x = data$label_x,
        y = data$label_y
      )
      label_coords <- coord$transform(label_data, panel_params)

      for (i in seq_len(nrow(data))) {
        if (isTRUE(data$show_label[i])) {
          text_grobs <- c(text_grobs, list(
            grid::textGrob(
              label = data$pct_text[i],
              x = label_coords$x[i],
              y = label_coords$y[i],
              gp = grid::gpar(
                col = "white",
                fontsize = 10,
                fontface = "bold"
              )
            )
          ))
        }
      }
    }

    grid::grobTree(
      do.call(grid::gList, rect_grobs),
      do.call(grid::gList, text_grobs)
    )
  }
)
