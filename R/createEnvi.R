#' Define and create a project environment
#'
#' @description Defines folder structures and creates them if necessary, loads
#' libraries, and sets other project relevant parameters.
#'
#' @param projRootDir  project github root directory (your github name)
#' @param projFolders list of subfolders in project
#' @param GRASSlocation folder for GRASS data
#' @param global boolean esport path strings as global variables default is false
#' @param path_prefix character a prefix for the path variables names default is ""
#'
#' @return A list containing the project settings.
#'
#' @name createEnvi
#' @export createEnvi
#'
#' @examples
#' \dontrun{
#'
#' createEnvi(root = tempdir(), folders = c("data/", "data/tmp/"))
#'}

createEnvi = function(root = tempdir(), folders = c("data/", "data/tmp/")){

  # Handle windows backslash path
  if(.Platform$OS.type == "windows"){
    root <- gsub("\\\\", "/", path.expand(root))
  }

  # A
  path.expand("~")
  file.path("test", "test1")


  pth<-list()
  # check  tailing / and if not existing append
  if (substr(projRootDir,nchar(projRootDir) - 1,nchar(projRootDir)) != "/") {
    projRootDir <- paste0(projRootDir,"/")
  }

  # create directories if needed
  for (folder in projFolders) {
    if (!file.exists(file.path(projRootDir,folder))) {
      dir.create(file.path(projRootDir,folder), recursive = TRUE)
      p<-gsub("/", "_", substr(folder,1,nchar(folder) - 1))
      name <- paste0(path_prefix,p)
      value <- paste0(projRootDir,folder)
      assign(name, value)
      pth[[name]]<- value
      if (global) makGlobalVar(name, value)
    } else {
      p<-gsub("/", "_", substr(folder,1,nchar(folder) - 1))
      name <- paste0(path_prefix,p)
      value <- paste0(projRootDir,folder)
      assign(name, value)
      pth[[name]]<- value
      if (global) makGlobalVar(name, value)
    }
  }
  if (!file.exists(file.path(projRootDir,GRASSlocation))) {
    dir.create(file.path(projRootDir,GRASSlocation), recursive = TRUE)
    p<-gsub("/", "_", substr(GRASSlocation,1,nchar(GRASSlocation) - 1))
    name <- paste0(path_prefix,p)
    value <- paste0(projRootDir,GRASSlocation)
    assign(name, value)
    pth[[name]]<- value
    if (global) makGlobalVar(name, value)
  } else {
    p<-gsub("/", "_", substr(GRASSlocation,1,nchar(GRASSlocation) - 1))
    name <- paste0(path_prefix,p)
    value <- paste0(projRootDir,GRASSlocation)
    assign(name, value)
    pth[[name]]<- value
    if (global) makGlobalVar(name, value)
  }

  return(pth)
}
