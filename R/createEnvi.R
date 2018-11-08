#' Define and create a project environment
#'
#' @description Defines folder structures and creates them if necessary, loads
#' libraries, and sets other project relevant parameters.
#'
#' @param root_folder project root_folder folder directory.
#' @param folders list of subfolders within the project root folder.
#' @param folder_names names of the variables that point to subfolders. If not
#' provided, the folder base paths of the folders is used.
#' @param path_prefix a prefix for the path variable names.
#' @param global export path strings as global variables.
#' @param alternative_env_id alternative system environment attribute used to
#' check for setting an alternative \code{root_folder}.
#' @param alternative_env_id value of the attribute for which the alternative
#' \code{root_folder} should be set.
#' @param alternative_root_folder alternative root folder for alternative domain.
#'
#' @return A list containing the project settings.
#'
#' @name createEnvi
#' @export createEnvi
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#' @examples
#' \dontrun{
#' createEnvi(root_folder = tempdir(), folders = c("data/", "data/tmp/"))
#'}

createEnvi = function(root_folder = tempdir(), folders = c("data", "data/tmp"),
                      folder_names = NULL, path_prefix = "path_", global = FALSE,
                      alternative_env_id = NULL,
                      alternative_env_value = NULL,
                      alternative_root_folder = NULL){

  # Set root folder or alternative root folder
  root_folder = gsub("\\\\", "/", path.expand(root_folder))

  if(!is.null(alternative_env_id)){
    if(Sys.getenv()[alternative_env_id] == alternative_env_value){
      root_folder = alternative_root_folder
    }
  }

  # Create folder list and set variable names pointing to the path values
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

  if (global) makeGlobalVariable(names = names(folders), values = folders)

  return(folders)
}
