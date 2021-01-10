#' Saves data in rds format and adds a yaml metadata file.
#'
#' @description Saves data in rds format and saves metadata in a corresponding yaml file.
#'
#' @param variable name of the data variable to be saved.
#' @param file_path name and path of the rds file.
#' @param meta name of the metadata list.
#'
#' @return NULL
#'
#' @name enviSave
#' @export enviSave
#'
#' @examples
#' \dontrun{
#' a <- 1
#' meta <- list(a = "a is a variable")
#' enviSave(a, file.path(tempdir(), "test.rds"), meta)
#' }
#'
enviSave <- function(variable, file_path, meta) {
  saveRDS(variable, file_path)
  yaml::write_yaml(meta, paste0(tools::file_path_sans_ext(file_path), ".yaml"))
}
