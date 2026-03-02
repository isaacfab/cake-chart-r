test_that("cake_chart works with named vector", {
  p <- cake_chart(c(A = 40, B = 30, C = 20, D = 10))
  expect_s3_class(p, "ggplot")
})

test_that("cake_chart works with data frame", {
  df <- data.frame(
    value = c(40, 30, 20, 10),
    category = c("A", "B", "C", "D")
  )
  p <- cake_chart(df, x = value, fill = category)
  expect_s3_class(p, "ggplot")
})

test_that("cake_chart adds title when provided", {
  p <- cake_chart(c(A = 40, B = 30), title = "My Chart")
  expect_equal(p$labels$title, "My Chart")
})

test_that("cake_chart horizontal orientation works", {
  p <- cake_chart(c(A = 50, B = 50), orientation = "horizontal")
  expect_s3_class(p, "ggplot")
})

test_that("cake_chart errors on bad input", {
  expect_error(cake_chart("not valid"))
  expect_error(cake_chart(c(1, 2, 3)))
})

test_that("cake_chart data frame requires x and fill", {
  df <- data.frame(value = c(40, 30))
  expect_error(cake_chart(df))
})

test_that("cake_chart can be built without error", {
  p <- cake_chart(c(A = 40, B = 30, C = 20, D = 10))
  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})

test_that("scale_fill_cake applies without error", {
  df <- data.frame(
    value = c(40, 30, 20, 10),
    category = c("A", "B", "C", "D")
  )
  p <- ggplot(df, aes(x = value, fill = category)) +
    geom_cake() +
    scale_fill_cake() +
    theme_cake()

  built <- ggplot_build(p)
  expect_s3_class(built, "ggplot_built")
})
