context("Set environment")
library(envimaR)

root_folder <- file.path(tempdir(), "envimar_test_createEnvi")
if (dir.exists(root_folder)) unlink(root_folder, recursive = TRUE)
dir.create(root_folder)

test_that("use default values from LUTs", {
  git_repository <- "myrep1"
  lut_mode <- TRUE
  envrmt <- createEnvi(
    root_folder = root_folder,
    git_repository = git_repository, lut_mode = lut_mode,
    create_folders = FALSE
  )
  expect_equal(normalizePath(file.path(root_folder, "data")) == normalizePath(envrmt$path_data))
  expect_equal(normalizePath(file.path(root_folder, git_repository, "src")) == normalizePath(envrmt$path_src))
})

test_that("folder structure", {
  folders <- c(
    "data/", "data/tmp/", "data/aerial/org", "data/lidar/org",
    "data/a/test/org", "data/b/test/org"
  )
  envrmt <- createEnvi(
    root_folder = root_folder, folders = folders,
    create_folders = FALSE
  )

  expect_true(normalizePath(file.path(root_folder, "data/b/test/org")) == normalizePath(envrmt$path_b_test_org))
  expect_true(normalizePath(file.path(root_folder, "data/lidar/org")) == normalizePath(envrmt$path_lidar_org))
})
