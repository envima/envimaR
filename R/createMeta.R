#' Create list of metadata from project environment.
#'
#' @description Create list of metadata from project environment.
#'
#' @param prj_name name of the project
#'
#' @return list of metadata.
#'
#' @name createMeta
#' @export createMeta
#'
#' @examples
#' \dontrun{
#' createMeta(tempdir())
#' }
#'
createMeta <- function(prj_name) {
  meta <- list()
  meta$prj <- prj_name
  meta$git_commit <- system("git rev-parse HEAD", intern = TRUE)
  return(meta)
}

