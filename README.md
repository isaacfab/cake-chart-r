# cakechart

Rectangular alternatives to pie charts for R. Cake charts subdivide a rectangle into proportional slices, leveraging human strengths at comparing lengths along a common scale rather than angles and arc lengths.

Works as a standalone function or as a ggplot2 extension.

## Installation

```r
# install from source
devtools::install_github("isaacfab/cake-chart-r")
```

## Quick start

```r
library(cakechart)

# from a named vector
cake_chart(c(A = 40, B = 30, C = 20, D = 10))

# from a data frame
df <- data.frame(value = c(40, 30, 20, 10), category = c("A", "B", "C", "D"))
cake_chart(df, x = value, fill = category)
```

## ggplot2 integration

```r
ggplot(df, aes(x = value, fill = category)) +
  geom_cake() +
  scale_fill_cake() +
  theme_cake()
```

## Options

- **Orientation** -- vertical (default, left-to-right) or horizontal (top-to-bottom)
- **Sorting** -- optional largest-first ordering (`sort = TRUE`)
- **Labels** -- automatic percentage labels with a configurable minimum threshold (`min_pct_label`)
- **Colour-blind friendly** -- `scale_fill_cake()` uses the Okabe-Ito palette

```r
cake_chart(c(A = 40, B = 30, C = 20, D = 10),
           orientation = "horizontal", sort = TRUE, title = "My cake chart")
```

## License

MIT
