#' Generates a variable with a certain value in the R environment
#'
#' @description  Generates a variable with a certain value in the R environment.
#'
#' @param names  vector with the  names of the variable(s)
#' @param values vector with values of the variable(s)
#'
#' @name makeGlobalVariable
#' @keywords internal
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#'@examples
#' \dontrun{
#' # creates the global variable \code{path_data} with the value \code{~/data}
#' makeGlobalVariable(names = "path_data", values = "~/data")
#'
#' }

makeGlobalVariable = function(names, values) {
  if (!exists("enivmaR")) enivmaR = new.env(parent=globalenv())

  for(i in seq(length(names))){
    if (exists(names[i], envir = enivmaR)) {
      warning(paste("The variable", names[i],"already exist in .GlobalEnv"))
    } else {
      assign(names[i], values[i], envir = enivmaR, inherits = TRUE)
    }
  }
}
