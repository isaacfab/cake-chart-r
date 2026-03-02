#' Default fill scale for cake charts
#'
#' Provides a colour-blind-friendly discrete fill scale based on the
#' Okabe-Ito palette. Drop-in replacement for [scale_fill_discrete()] that
#' works well with cake charts.
#'
#' @param ... Arguments passed to [ggplot2::discrete_scale()].
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' library(ggplot2)
#'
#' df <- data.frame(value = c(40, 30, 20, 10), category = c("A", "B", "C", "D"))
#' ggplot(df, aes(x = value, fill = category)) +
#'   geom_cake() +
#'   scale_fill_cake() +
#'   theme_cake()
#'
#' @export
scale_fill_cake <- function(...) {
  # Okabe-Ito colour-blind-friendly palette
  cake_palette <- c(
    "#E69F00", "#56B4E9", "#009E73", "#F0E442",
    "#0072B2", "#D55E00", "#CC79A7", "#999999"
  )

  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) {
      if (n > length(cake_palette)) {
        cli::cli_warn(
          "scale_fill_cake() has {length(cake_palette)} colours; \\
           {n} requested. Colours will be recycled."
        )
        rep_len(cake_palette, n)
      } else {
        cake_palette[seq_len(n)]
      }
    },
    ...
  )
}
