#' Cake chart geom for ggplot2
#'
#' `geom_cake()` creates a rectangular "cake chart" where a rectangle is
#' subdivided into proportional slices. This is a more readable alternative to
#' pie charts, leveraging human ability to compare lengths along a common scale.
#'
#' @section Aesthetics:
#' `geom_cake()` understands the following aesthetics (required aesthetics are
#' in **bold**):
#' \itemize{
#'   \item **`x`** — Numeric values determining slice sizes.
#'   \item `fill` — Category variable for grouping and colouring slices.
#'   \item `colour` — Border colour (default: `"white"`).
#'   \item `alpha` — Transparency (default: `1`).
#'   \item `linewidth` — Border width (default: `0.5`).
#' }
#'
#' @param mapping Set of aesthetic mappings created by [aes()].
#' @param data The data to be displayed in this layer.
#' @param stat The statistical transformation to use on the data (default:
#'   `"cake"`).
#' @param position Position adjustment (default: `"identity"`).
#' @param ... Other arguments passed to [layer()].
#' @param orientation `"vertical"` (default, slices left-to-right) or
#'   `"horizontal"` (slices top-to-bottom).
#' @param sort Logical; if `TRUE` (default), sort slices largest-first.
#' @param show_labels Logical; if `TRUE` (default), show percentage labels
#'   inside slices.
#' @param min_pct_label Minimum proportion for a slice to receive a label
#'   (default: `0.05`, i.e. 5%).
#' @param na.rm If `FALSE` (default), missing values are removed with a
#'   warning.
#' @param show.legend Logical. Should this layer be included in the legends?
#' @param inherit.aes If `FALSE`, overrides the default aesthetics.
#'
#' @return A ggplot2 layer.
#'
#' @examples
#' library(ggplot2)
#'
#' df <- data.frame(
#'   value = c(40, 30, 20, 10),
#'   category = c("A", "B", "C", "D")
#' )
#'
#' ggplot(df, aes(x = value, fill = category)) +
#'   geom_cake() +
#'   theme_cake()
#'
#' # Horizontal orientation
#' ggplot(df, aes(x = value, fill = category)) +
#'   geom_cake(orientation = "horizontal") +
#'   theme_cake()
#'
#' @export
geom_cake <- function(mapping = NULL,
                      data = NULL,
                      stat = "cake",
                      position = "identity",
                      ...,
                      orientation = "vertical",
                      sort = TRUE,
                      show_labels = TRUE,
                      min_pct_label = 0.05,
                      na.rm = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatCake,
    geom = GeomCake,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      orientation = orientation,
      sort = sort,
      show_labels = show_labels,
      min_pct_label = min_pct_label,
      na.rm = na.rm,
      ...
    )
  )
}
