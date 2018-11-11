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




#' Compile folder list and create folders
#'
#' @description  Compile folder list with absolut paths and create folders if
#' necessary.
#'
#' @param root_folder root directory of the project.
#' @param folders list of subfolders within the project directory.
#' @param folder_names names of the variables that point to subfolders. If not
#' provided, the base paths of the folders is used.
#' @param path_prefix a prefix for the folder names.
#'
#' @return  List with folder paths and names.
#'
#' @keywords internal
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#'@examples
#' \dontrun{
#' # createFolders(root_folder = "~/edu", folders = c("data/", "data/tmp/"))
#' }
# Create folder list and set variable names pointing to the path values
createFolders = function(root_folder, folders,
                         folder_names = NULL, path_prefix = "path_"){

  folders = lapply(folders, function(f){
    file.path(root_folder, f)
  })

  if(is.null(folder_names)){
    names(folders) = basename(unlist(folders))

    while(any(duplicated(names(folders)))){
      names(folders)[duplicated(names(folders))] =
        paste(basename(dirname(unlist(folders)))[duplicated(names(folders))],
              names(folders[duplicated(names(folders))]), sep = "_")
    }
  } else {
    names(folders) = folder_names
  }

  if(!is.null(path_prefix)) names(folders) = paste0(path_prefix, names(folders))

  # Check paths for existance and create if necessary
  for(f in folders){
    if(!file.exists(f)) dir.create(f, recursive = TRUE)
  }

  return(folders)
}




#' Load libraries and try to install missing ones
#'
#' @description  Load libaries in the R environment and try to install misssing
#' ones.
#'
#' @param libs  vector with the  names of libraries
#'
#' @return  List indicating which library has been loaded successfully.
#'
#' @keywords internal
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#'@examples
#' \dontrun{
#' # loadLibraries(libs = C("link2GI"))
#' }
loadLibraries = function(libs){
  success = lapply(libs, function(l){
    if(!l %in% installed.packages()){
      install.packages(l)
    }
    require(l, character.only = TRUE)
  })
  names(success) = libs
  return(success)
}
