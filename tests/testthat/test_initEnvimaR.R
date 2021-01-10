context("Init environment")
library(envimaR)

root_folder <- file.path(tempdir(), "envimar_test_initEnvi")
if (dir.exists(root_folder)) unlink(root_folder, recursive = TRUE)
dir.create(root_folder)

test_that("use default envimar setup", {
  root_folder <- paste0(root_folder, "_01")
  envrmt <- initEnvimaR(root_folder = root_folder, standard_setup = "envimar")
  expect_equal(normalizePath(file.path(root_folder, "doc/figures")) == normalizePath(envrmt$figures))
  expect_equal(normalizePath(file.path(root_folder, "src/functions")) == normalizePath(envrmt$functions))
  expect_true(file.exists(file.path(root_folder, ".git")))
  expect_true(file.exists(file.path(root_folder, ".dvc")))
})


test_that("use envimar setup without dvc", {
  root_folder <- paste0(root_folder, "_02")
  envrmt <- initEnvimaR(root_folder = root_folder, standard_setup = "envimar_no_dvc")
  expect_equal(normalizePath(file.path(root_folder, "doc/figures")) == normalizePath(envrmt$figures))
  expect_equal(shortPathName(envrmt$functions), shortPathName(file.path(root_folder, "./src/functions")))
  expect_true(file.exists(file.path(root_folder, ".git")))
  expect_false(file.exists(file.path(root_folder, ".dvc")))
})

test_that("use envimar setup without dvc and git", {
  root_folder <- paste0(root_folder, "_03")
  envrmt <- initEnvimaR(root_folder = root_folder, standard_setup = "envimar_no_git_dvc")
  expect_equal(normalizePath(file.path(root_folder, "doc/figures")) == normalizePath(envrmt$figures))
  expect_equal(normalizePath(file.path(root_folder, "src/functions")) == normalizePath(envrmt$functions))
  expect_false(file.exists(file.path(root_folder, ".git")))
  expect_false(file.exists(file.path(root_folder, ".dvc")))
})
