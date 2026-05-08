#' @rdname geom_cake
#' @format NULL
#' @usage NULL
#' @export
StatCake <- ggproto("StatCake", Stat,
  required_aes = c("x"),

  default_aes = aes(fill = after_stat(label)),

  compute_panel = function(data, scales,
                           orientation = "vertical",
                           sort = TRUE,
                           min_pct_label = 0.05) {
    # Aggregate: if fill is present use it for grouping, otherwise use row labels
    if ("fill" %in% names(data)) {
      agg <- stats::aggregate(data$x, by = list(fill = data$fill), FUN = sum)
      values <- agg$x
      labels <- as.character(agg$fill)
    } else {
      values <- data$x
      labels <- as.character(seq_along(values))
    }

    layout <- compute_cake_layout(
      values = values,
      labels = labels,
      orientation = orientation,
      sort = sort,
      min_pct_label = min_pct_label
    )

    data.frame(
      xmin = layout$xmin,
      xmax = layout$xmax,
      ymin = layout$ymin,
      ymax = layout$ymax,
      label_x = layout$label_x,
      label_y = layout$label_y,
      pct_text = layout$pct_text,
      show_label = layout$show_label,
      label = layout$label,
      fill = layout$label,
      group = seq_len(nrow(layout)),
      stringsAsFactors = FALSE
    )
  }
)
