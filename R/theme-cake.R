#' Minimal theme for cake charts
#'
#' A clean theme that removes axes, gridlines, and background, letting the
#' cake chart speak for itself. Built on top of [theme_void()].
#'
#' @param base_size Base font size (default: `12`).
#' @param base_family Base font family (default: `""`).
#'
#' @return A [ggplot2::theme] object.
#'
#' @examples
#' library(ggplot2)
#'
#' df <- data.frame(value = c(40, 30, 20, 10), category = c("A", "B", "C", "D"))
#' ggplot(df, aes(x = value, fill = category)) +
#'   geom_cake() +
#'   theme_cake()
#'
#' @export
theme_cake <- function(base_size = 12, base_family = "") {
  theme_void(base_size = base_size, base_family = base_family) %+replace%
    theme(
      legend.position = "bottom",
      legend.title = element_blank(),
      plot.margin = margin(10, 10, 10, 10)
    )
}
