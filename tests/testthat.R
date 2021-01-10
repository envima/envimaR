library(testthat)
library(envimaR)

# test_check("envimaR")
testthat::test_file("./tests/testthat/initEnvimaR.R")


path <- testthat_example("initEnvimaR")
