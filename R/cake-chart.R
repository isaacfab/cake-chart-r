#' Create a standalone cake chart
#'
#' A convenience function that produces a complete cake chart from either a
#' named numeric vector or a data frame with value and category columns.
#'
#' @param data A named numeric vector **or** a data frame.
#' @param x When `data` is a data frame, an unquoted column name for values.
#' @param fill When `data` is a data frame, an unquoted column name for
#'   categories.
#' @param orientation `"vertical"` (default) or `"horizontal"`.
#' @param sort Logical; if `TRUE` (default), sort slices largest-first.
#' @param show_labels Logical; if `TRUE` (default), show percentage labels.
#' @param min_pct_label Minimum proportion for a label (default: `0.05`).
#' @param title Optional chart title.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @examples
#' # Named vector
#' cake_chart(c(A = 40, B = 30, C = 20, D = 10))
#'
#' # Data frame
#' df <- data.frame(value = c(40, 30, 20, 10), category = c("A", "B", "C", "D"))
#' cake_chart(df, x = value, fill = category)
#'
#' # Horizontal
#' cake_chart(c(A = 40, B = 30, C = 20, D = 10), orientation = "horizontal")
#'
#' @export
cake_chart <- function(data,
                       x = NULL,
                       fill = NULL,
                       orientation = "vertical",
                       sort = TRUE,
                       show_labels = TRUE,
                       min_pct_label = 0.05,
                       title = NULL) {
  if (is.numeric(data) && !is.null(names(data))) {
    # Named vector input
    df <- data.frame(
      value = unname(data),
      category = names(data),
      stringsAsFactors = FALSE
    )
    mapping <- aes(x = .data$value, fill = .data$category)
  } else if (is.data.frame(data)) {
    x_quo <- rlang::enquo(x)
    fill_quo <- rlang::enquo(fill)

    if (rlang::quo_is_null(x_quo)) {
      cli::cli_abort("Column {.arg x} must be provided when {.arg data} is a data frame.")
    }
    if (rlang::quo_is_null(fill_quo)) {
      cli::cli_abort("Column {.arg fill} must be provided when {.arg data} is a data frame.")
    }

    df <- data
    mapping <- aes(x = !!x_quo, fill = !!fill_quo)
  } else {
    cli::cli_abort(
      "{.arg data} must be a named numeric vector or a data frame."
    )
  }

  p <- ggplot(df, mapping) +
    geom_cake(
      orientation = orientation,
      sort = sort,
      show_labels = show_labels,
      min_pct_label = min_pct_label
    ) +
    scale_fill_cake() +
    theme_cake()

  if (!is.null(title)) {
    p <- p + ggtitle(title)
  }

  p
}
