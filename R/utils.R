#' Compute cake chart layout coordinates
#'
#' Given a named numeric vector or values + labels, compute the rectangle
#' coordinates for each slice in a unit square \[0,1\] x \[0,1\].
#'
#' @param values Numeric vector of positive values.
#' @param labels Character vector of labels (same length as `values`).
#' @param orientation `"vertical"` (slices left-to-right) or `"horizontal"`
#'   (slices top-to-bottom).
#' @param sort Logical; if `TRUE` (default), sort slices largest-first.
#' @param min_pct_label Minimum proportion to receive a label. Slices below
#'   this threshold get `show_label = FALSE`.
#'
#' @return A data.frame with columns: `label`, `value`, `proportion`,
#'   `xmin`, `xmax`, `ymin`, `ymax`, `label_x`, `label_y`, `pct_text`,
#'   `show_label`.
#'
#' @keywords internal
#' @noRd
compute_cake_layout <- function(values,
                                labels = names(values),
                                orientation = "vertical",
                                sort = TRUE,
                                min_pct_label = 0.05) {
  if (length(values) == 0) {
    cli::cli_abort("Cannot create a cake chart with zero values.")
  }
  if (any(values < 0, na.rm = TRUE)) {
    cli::cli_abort("All values must be non-negative.")
  }
  total <- sum(values, na.rm = TRUE)
  if (total == 0) {
    cli::cli_abort("Total of values must be greater than zero.")
  }

  if (is.null(labels)) {
    labels <- as.character(seq_along(values))
  }

  proportions <- values / total

  if (sort) {
    ord <- order(proportions, decreasing = TRUE)
    proportions <- proportions[ord]
    values <- values[ord]
    labels <- labels[ord]
  }

  n <- length(values)
  cum_prop <- c(0, cumsum(proportions))

  if (orientation == "vertical") {
    xmin <- cum_prop[seq_len(n)]
    xmax <- cum_prop[seq_len(n) + 1]
    ymin <- rep(0, n)
    ymax <- rep(1, n)
    label_x <- (xmin + xmax) / 2
    label_y <- rep(0.5, n)
  } else {
    # Horizontal: slices top-to-bottom
    xmin <- rep(0, n)
    xmax <- rep(1, n)
    ymax <- 1 - cum_prop[seq_len(n)]
    ymin <- 1 - cum_prop[seq_len(n) + 1]
    label_x <- rep(0.5, n)
    label_y <- (ymin + ymax) / 2
  }

  pct_text <- scales::percent(proportions, accuracy = 1)
  show_label <- proportions >= min_pct_label

  data.frame(
    label = labels,
    value = values,
    proportion = proportions,
    xmin = xmin,
    xmax = xmax,
    ymin = ymin,
    ymax = ymax,
    label_x = label_x,
    label_y = label_y,
    pct_text = pct_text,
    show_label = show_label,
    stringsAsFactors = FALSE
  )
}
