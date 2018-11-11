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




#' Extent folder list by git repository
#'
#' @description  Extent folder list by git repository and create subdirectories
#' according to default values.
#'
#' @param folders list of subfolders within the project directory.
#' @param git_repository name of the project's git repository. Will be
#' added to the folders and subfolders defined in default "lut" or supplied by
#' user will be created.
#' @param git_folders subdirectories within git repository that should be
#' created.
#' @param lut_mode use predefined environmental settings. In this case, only the
#' name of the git repository must be supplied to the function.
#'
#' @name addGitFolders
#' @keywords internal
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#'@examples
#' \dontrun{
#'
#' addGitFolders(folders = c("data", "data/tmp"), git_repository = "myproject")
#'
#' }

addGitFolders = function(folders, git_repository = NULL, git_folders = NULL,
                         lut_mode = FALSE) {
  if(is.null(git_folders) & dflt$git_folders){
    git_folders = dflt$git_folders
  }
  folders = c(folders, file.path(git_repository, dflt$git_subfolders))
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

  if(!is.null(path_prefix)) names(folders) = paste(path_prefix, names(folders))

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
    if(!l %in% utils::installed.packages()){
      utils::install.packages(l)
    }
    require(l, character.only = TRUE)
  })
  names(success) = libs
  return(success)
}




#' Source functions from standard or given directory
#'
#' @description  Source functions into the R environment located in a specified
#' folder.
#'
#' @param fcts_folder path of the folder holding the functions. All files in
#' this folder will be sourced.
#'
#' @return  Information if sourcing was successfull based on try function.
#'
#' @keywords internal
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#'@examples
#' \dontrun{
#' # sourceFunctions(fcts_folder = "~/project/src/fcts")
#' }
sourceFunctions = function(fcts_folder){
  fcts = list.files(fcts_folder, full.names = TRUE)
  success = lapply(fcts, function(f){
    try(source(f), silent = TRUE)
  })
  names(success) = fcts
  return(success)
}




#' Get values of default environment look-up table
#'
#' @description
#' Get values of default environment look-up table (not required for the package
#' but to cross-check from a user).
#'
#' @param None
#'
#' @return List containing lut content.
#'
#' @name lutInfo
#' @export lutInfo
#'
#' @details None
#'
#' @examples None
#' \dontrun{
#' lutInfo()
#' }

lutInfo <- function(){
  return(dflt)
}
