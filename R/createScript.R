#' Create files or scripts from templates
#'
#' @description Create files or scripts from brew templates supplied with the package.
#'
#' @param new_file name of the file to be created
#' @param template template to be used for the new file ("script_function", "script_control")
#' @param notes logical: include notes from the template in the file
#'
#' @return NULL
#'
#' @name createScript
#' @export createScript
#'
#' @examples
#' \dontrun{
#' createScript()
#' }
#'
createScript <- function(new_file = file.path(tempdir(), "tmp.R"), template = c("script_function", "script_control"),
                         notes = TRUE) {
  template_path <- system.file(sprintf("templates/%s.brew", template[1]), package = "envimaR")
  brew::brew(template_path, new_file)
}
