test_that("compute_cake_layout returns correct proportions", {
  result <- compute_cake_layout(c(40, 30, 20, 10), labels = c("A", "B", "C", "D"))
  expect_equal(nrow(result), 4)
  expect_equal(sum(result$proportion), 1)
  # Sorted largest first by default

  expect_equal(result$label, c("A", "B", "C", "D"))
  expect_equal(result$proportion, c(0.4, 0.3, 0.2, 0.1))
})

test_that("compute_cake_layout vertical rectangles span unit square", {
  result <- compute_cake_layout(c(50, 50), labels = c("A", "B"))
  expect_equal(result$xmin, c(0, 0.5))
  expect_equal(result$xmax, c(0.5, 1))
  expect_equal(result$ymin, c(0, 0))
  expect_equal(result$ymax, c(1, 1))
})

test_that("compute_cake_layout horizontal rectangles span unit square", {
  result <- compute_cake_layout(c(50, 50), labels = c("A", "B"),
                                orientation = "horizontal")
  expect_equal(result$ymax, c(1, 0.5))
  expect_equal(result$ymin, c(0.5, 0))
  expect_equal(result$xmin, c(0, 0))
  expect_equal(result$xmax, c(1, 1))
})

test_that("compute_cake_layout respects sort = FALSE", {
  result <- compute_cake_layout(c(10, 40, 20), labels = c("A", "B", "C"),
                                sort = FALSE)
  expect_equal(result$label, c("A", "B", "C"))
  expect_equal(result$value, c(10, 40, 20))
})

test_that("compute_cake_layout suppresses small slice labels", {
  result <- compute_cake_layout(c(95, 5), labels = c("Big", "Small"),
                                min_pct_label = 0.06)
  expect_true(result$show_label[1])
  expect_false(result$show_label[2])
})

test_that("compute_cake_layout errors on empty or zero input", {
  expect_error(compute_cake_layout(numeric(0)))
  expect_error(compute_cake_layout(c(0, 0)))
})

test_that("compute_cake_layout errors on negative values", {
  expect_error(compute_cake_layout(c(10, -5), labels = c("A", "B")))
})

test_that("compute_cake_layout uses seq index labels when names missing", {
  result <- compute_cake_layout(c(30, 70))
  expect_equal(result$label[result$value == 70], "2")
  expect_equal(result$label[result$value == 30], "1")
})

test_that("compute_cake_layout label positions are centered in slices", {
  result <- compute_cake_layout(c(A = 60, B = 40))
  # First slice (60%) xmin=0, xmax=0.6 -> label_x = 0.3

  expect_equal(result$label_x[1], 0.3)
  expect_equal(result$label_y[1], 0.5)
})
