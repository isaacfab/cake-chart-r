# cakechart

> **Friends don't let friends make pie charts.**

`cakechart` is a small R package that draws **cake charts** — rectangles, sliced
into proportional pieces along a common scale. It is the chart you should have
been reaching for every time you reached for a pie.

```r
cake_chart(c(Chrome = 65, Safari = 19, Edge = 5, Firefox = 3, Other = 8))
```

Works as a one-line standalone function and as a first-class `ggplot2`
extension (`geom_cake()`, `scale_fill_cake()`, `theme_cake()`).

---

## Why not pie?

Pie charts ask your eyes to do the one thing they are bad at: comparing angles
and arc lengths. Decades of perceptual research — Cleveland & McGill (1984),
Heer & Bostock (2010), and roughly every data-viz textbook since — rank
position-along-a-common-scale at the top of the accuracy hierarchy and
angle/area near the bottom.

In practice that means:

- **Pie chart:** "is the blue slice bigger than the orange slice? …maybe?"
- **Cake chart:** "blue is bigger. Next question."

Pies fail hardest exactly when you need them to work hardest:

| Situation                                     | Pie chart                  | Cake chart                |
| --------------------------------------------- | -------------------------- | ------------------------- |
| Two slices within a few percent of each other | Indistinguishable          | Obvious                   |
| More than ~5 categories                       | Rainbow of confetti        | Still readable            |
| Showing change over time (small multiples)    | A wall of clocks           | Stacked bars, easy to scan|
| Putting numbers on the slices                 | Crammed into wedges        | Sit cleanly inside a rectangle |
| 3D, exploded, or tilted "for style"           | A felony                   | Not possible              |

If you've ever zoomed in on a pie chart to figure out which sliver was which,
this package is for you.

---

## Installation

```r
# install.packages("devtools")
devtools::install_github("isaacfab/cake-chart-r")
```

---

## Quick start

A named vector is the fastest path to a chart:

```r
library(cakechart)

# Global desktop browser share, roughly
browsers <- c(Chrome = 65, Safari = 19, Edge = 5, Firefox = 3, Other = 8)
cake_chart(browsers, title = "Desktop browser market share")
```

Or hand it a data frame and tell it which columns to use:

```r
budget <- data.frame(
  program = c("Social Security", "Medicare/Medicaid", "Defense",
              "Interest", "Other"),
  share   = c(21, 25, 13, 13, 28)
)

cake_chart(budget, x = share, fill = program,
           title = "U.S. federal outlays, share of total")
```

---

## ggplot2 integration

`geom_cake()` slots into the rest of your `ggplot2` pipeline, which is where
cake charts really pull ahead of pies. Faceted small multiples, for example,
are the kind of thing pie charts cannot do without inducing a migraine:

```r
library(ggplot2)

elections <- data.frame(
  year  = rep(c(2016, 2020, 2024), each = 3),
  party = rep(c("Party A", "Party B", "Other"), 3),
  share = c(46, 48, 6,
            51, 47, 2,
            50, 48, 2)
)

ggplot(elections, aes(x = share, fill = party)) +
  geom_cake(orientation = "horizontal") +
  scale_fill_cake() +
  theme_cake() +
  facet_wrap(~ year, ncol = 1) +
  labs(title = "National vote share by year")
```

Compose it like any other geom — title, caption, custom palettes, the whole
`ggplot2` toolbox is available:

```r
ggplot(budget, aes(x = share, fill = program)) +
  geom_cake(min_pct_label = 0.10) +
  scale_fill_cake() +
  theme_cake() +
  labs(
    title    = "Where every federal dollar goes",
    subtitle = "Cake chart, sorted largest-first",
    caption  = "Source: made-up numbers, illustrative only"
  )
```

---

## Options

| Argument        | What it does                                               | Default       |
| --------------- | ---------------------------------------------------------- | ------------- |
| `orientation`   | `"vertical"` (left-to-right) or `"horizontal"` (top-down)  | `"vertical"`  |
| `sort`          | Sort slices largest-first                                  | `TRUE`        |
| `show_labels`   | Print percentage labels inside slices                      | `TRUE`        |
| `min_pct_label` | Hide labels for slices smaller than this proportion        | `0.05`        |
| `title`         | Optional chart title (standalone `cake_chart()` only)      | `NULL`        |

`scale_fill_cake()` defaults to the **Okabe–Ito** palette, which is
colour-blind safe and looks good in print. `theme_cake()` strips the axes and
grid you don't need so the data carries the chart.

---

## When *should* you use a pie chart?

Honestly? When your boss makes you. Otherwise: use a cake.

---

## License

MIT © Isaac Faber. See [LICENSE](LICENSE).
