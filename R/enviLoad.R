#' Load data from rds format and associated yaml metadata file.
#'
#' @description Load data from rds format and associated yaml metadata file.
#'
#' @param file_path name and path of the rds file.
#'
#' @return list of 2 containing data and metadata.
#'
#' @name enviLoad
#' @export enviLoad
#'
#' @examples
#' \dontrun{
#' a <- 1
#' meta <- list(a = "a is a variable")
#' enviSave(a, file.path(tempdir(), "test.rds"), meta)
#' b <- enviLoad(file.path(tempdir(), "test.rds"))
#' }
#'
enviLoad <- function(file_path) {
  dat <- readRDS(file_path)
  meta <- yaml::read_yaml(paste0(tools::file_path_sans_ext(file_path), ".yaml"))
  return(list(dat = dat, meta = meta))
}
