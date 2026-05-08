#!/usr/bin/env Rscript
# Build the PNG figures embedded in README.md.
#
# Run from the package root:
#   Rscript tools/readme/build_figures.R
#
# Output is written to man/figures/ so the figures are included when the
# package is built and rendered by GitHub from the rendered README.

suppressPackageStartupMessages({
  library(ggplot2)
  library(patchwork)   # for side-by-side composition
  library(cakechart)   # devtools::load_all() if you're iterating
})

fig_dir <- "man/figures"
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

save_png <- function(plot, file, width = 8, height = 4.5, dpi = 150) {
  path <- file.path(fig_dir, file)
  ggsave(path, plot, width = width, height = height, dpi = dpi,
         bg = "white")
  message("wrote ", path)
}

# Shared palette so pie and cake are compared on geometry alone, not colour.
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#999999")


# ---- 1. Hero: pie vs. cake on the same data ---------------------------------
# Picked to be deliberately mean to pies: several mid-sized slices that are
# close in magnitude, so the angle comparison is genuinely hard.

browsers <- data.frame(
  browser = c("Chrome", "Safari", "Edge", "Firefox", "Samsung", "Opera", "Other"),
  share   = c(38, 21, 14, 11, 8, 5, 3)
)
browsers$browser <- factor(browsers$browser, levels = browsers$browser)

pie_plot <- ggplot(browsers, aes(x = "", y = share, fill = browser)) +
  geom_col(width = 1, colour = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = okabe_ito) +
  labs(title = "Pie chart", fill = NULL) +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "right"
  )

cake_plot <- ggplot(browsers, aes(x = share, fill = browser)) +
  geom_cake(min_pct_label = 0.04) +
  scale_fill_manual(values = okabe_ito) +
  theme_cake() +
  labs(title = "Cake chart", fill = NULL) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

hero <- pie_plot + cake_plot +
  plot_annotation(
    title    = "Same data. Same colours. One of them you can read.",
    subtitle = "Global desktop browser share",
    theme    = theme(
      plot.title    = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(colour = "grey40")
    )
  )

save_png(hero, "pie-vs-cake.png", width = 10, height = 5)


# ---- 2. Faceted small multiples (the move pies cannot make) -----------------

elections <- data.frame(
  year  = rep(c(2016, 2020, 2024), each = 3),
  party = factor(rep(c("Party A", "Party B", "Other"), 3),
                 levels = c("Party A", "Party B", "Other")),
  share = c(46, 48,  6,
            51, 47,  2,
            50, 48,  2)
)

faceted <- ggplot(elections, aes(x = share, fill = party)) +
  geom_cake(orientation = "vertical", min_pct_label = 0.03) +
  scale_fill_manual(values = okabe_ito[c(5, 6, 8)]) +
  theme_cake() +
  facet_wrap(~ year, ncol = 1, strip.position = "left") +
  labs(
    title    = "National vote share, three cycles",
    subtitle = "Small multiples are trivial with cake charts and a nightmare with pies",
    fill     = NULL
  ) +
  theme(
    strip.text       = element_text(face = "bold"),
    strip.background = element_blank(),
    plot.title       = element_text(face = "bold")
  )

save_png(faceted, "cake-faceted.png", width = 8, height = 4.5)


# ---- 3. A clean standalone cake (the "this is what good looks like" shot) ---

budget <- data.frame(
  program = c("Social Security", "Medicare/Medicaid", "Defense",
              "Interest", "Other"),
  share   = c(21, 25, 13, 13, 28)
)

budget_plot <- cake_chart(budget, x = share, fill = program,
                          title = "Where every federal dollar goes") +
  labs(caption = "Illustrative figures") +
  theme(plot.title = element_text(face = "bold"))

save_png(budget_plot, "cake-budget.png", width = 8, height = 3.5)

message("done.")
