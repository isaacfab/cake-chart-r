test_that("StatCake compute_panel returns correct structure", {
  df <- data.frame(
    x = c(40, 30, 20, 10),
    fill = c("A", "B", "C", "D"),
    PANEL = 1L,
    group = 1:4
  )

  result <- StatCake$compute_panel(df, scales = list())

  expect_true(all(c("xmin", "xmax", "ymin", "ymax", "label", "fill",
                     "pct_text", "show_label") %in% names(result)))
  expect_equal(nrow(result), 4)
  # Should be sorted: 40%, 30%, 20%, 10%
  expect_equal(result$xmin[1], 0)
  expect_equal(result$xmax[nrow(result)], 1)
})

test_that("StatCake aggregates duplicate fill values", {
  df <- data.frame(
    x = c(20, 20, 30, 10),
    fill = c("A", "A", "B", "C"),
    PANEL = 1L,
    group = 1:4
  )

  result <- StatCake$compute_panel(df, scales = list())
  expect_equal(nrow(result), 3)
  # A=40, B=30, C=10 after aggregation
  expect_equal(result$label[1], "A")
})

test_that("StatCake horizontal orientation works", {
  df <- data.frame(
    x = c(50, 50),
    fill = c("A", "B"),
    PANEL = 1L,
    group = 1:2
  )

  result <- StatCake$compute_panel(df, scales = list(),
                                   orientation = "horizontal")
  expect_equal(result$xmin, c(0, 0))
  expect_equal(result$xmax, c(1, 1))
})

test_that("geom_cake creates a ggplot layer", {
  df <- data.frame(
    value = c(40, 30, 20, 10),
    category = c("A", "B", "C", "D")
  )

  p <- ggplot(df, aes(x = value, fill = category)) + geom_cake()
  expect_s3_class(p, "ggplot")
  expect_equal(length(p$layers), 1)
})

test_that("geom_cake plot can be built without error", {
  df <- data.frame(
    value = c(40, 30, 20, 10),
    category = c("A", "B", "C", "D")
  )

  p <- ggplot(df, aes(x = value, fill = category)) +
    geom_cake() +
    theme_cake()

  # Building the plot should not error
  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})
